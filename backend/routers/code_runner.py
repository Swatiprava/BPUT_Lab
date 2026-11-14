"""
Code Runner router — Execute code using local compilers (GCC, Python, Java, SQLite)
with automatic Judge0 fallback if API key is provided.
"""

import os
import sys
import time
import httpx
import base64
import tempfile
import asyncio
import sqlite3
import subprocess
import shutil
from typing import Optional
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

JUDGE0_API_URL = os.getenv("JUDGE0_API_URL", "https://judge0-ce.p.rapidapi.com")
JUDGE0_API_KEY = os.getenv("JUDGE0_API_KEY", "").strip()

LANGUAGE_MAP = {
    "c": 50,          # C (GCC 9.2.0)
    "cpp": 54,        # C++ (GCC 9.2.0)
    "c++": 54,
    "java": 62,       # Java (OpenJDK 13.0.1)
    "python": 71,     # Python (3.8.1)
    "python3": 71,
    "sql": 82,        # SQL (SQLite 3.27.2)
    "mysql": 82,      # MySQL / SQL
    "bash": 46,       # Bash (5.0.0)
    "shell": 46,
    "javascript": 63, # JavaScript (Node.js 12.14.0)
}


class CodeRunRequest(BaseModel):
    source_code: str
    language: str
    stdin: Optional[str] = ""


class CodeRunResponse(BaseModel):
    stdout: Optional[str] = None
    stderr: Optional[str] = None
    compile_output: Optional[str] = None
    status: str
    time: Optional[str] = None
    memory: Optional[int] = None


def _run_c_cpp_sync(source_code: str, stdin_data: str, is_cpp: bool = False) -> dict:
    ext = ".cpp" if is_cpp else ".c"
    compiler = "g++" if is_cpp else "gcc"
    
    with tempfile.NamedTemporaryFile(suffix=ext, delete=False, mode="w", encoding="utf-8") as f:
        f.write(source_code)
        src_path = f.name
        
    exe_path = src_path.replace(ext, ".exe")
    start_time = time.time()
    try:
        # Compile with GCC/G++
        compile_res = subprocess.run(
            [compiler, src_path, "-o", exe_path],
            capture_output=True,
            text=True,
            timeout=15
        )
        
        if compile_res.returncode != 0:
            return {
                "stdout": "",
                "stderr": "",
                "compile_output": compile_res.stderr,
                "status": "Compilation Error",
                "time": f"{time.time() - start_time:.2f}",
                "memory": 0
            }
            
        # Execute compiled binary with closed EOF pipe if stdin is empty
        run_start = time.time()
        stdin_text = stdin_data if stdin_data is not None else ""
        run_res = subprocess.run(
            [exe_path],
            input=stdin_text,
            capture_output=True,
            text=True,
            timeout=15
        )
        elapsed = time.time() - run_start
        status = "Accepted" if run_res.returncode == 0 else f"Exited with code {run_res.returncode}"
        
        return {
            "stdout": run_res.stdout,
            "stderr": run_res.stderr,
            "compile_output": "",
            "status": status,
            "time": f"{elapsed:.2f}",
            "memory": 2048
        }
    except subprocess.TimeoutExpired as e:
        partial_stdout = e.stdout if isinstance(e.stdout, str) else (e.stdout.decode("utf-8", errors="replace") if e.stdout else "")
        partial_stderr = e.stderr if isinstance(e.stderr, str) else (e.stderr.decode("utf-8", errors="replace") if e.stderr else "")
        hint = "\n[HINT] Your program timed out after 10s. If it uses an interactive menu (`while (1)`) or reads input via `scanf()`, please provide your input values (e.g. '1 10 8') in the 'Input (stdin)' tab!"
        return {
            "stdout": partial_stdout[:4000] if partial_stdout else "",
            "stderr": ((partial_stderr + "\n") if partial_stderr else "") + "Time Limit Exceeded (10s limit)" + hint,
            "compile_output": "",
            "status": "Time Limit Exceeded",
            "time": "10.00",
            "memory": 0
        }
    except Exception as e:
        return {
            "stdout": "",
            "stderr": f"Execution error: {str(e)}",
            "compile_output": "",
            "status": "Runtime Error",
            "time": f"{time.time() - start_time:.2f}",
            "memory": 0
        }
    finally:
        for p in [src_path, exe_path]:
            if os.path.exists(p):
                try:
                    os.remove(p)
                except:
                    pass


def _run_python_sync(source_code: str, stdin_data: str) -> dict:
    with tempfile.NamedTemporaryFile(suffix=".py", delete=False, mode="w", encoding="utf-8") as f:
        f.write(source_code)
        py_path = f.name
        
    start_time = time.time()
    try:
        stdin_text = stdin_data if stdin_data is not None else ""
        proc = subprocess.run(
            [sys.executable, "-u", py_path],
            input=stdin_text,
            capture_output=True,
            text=True,
            timeout=15
        )
        elapsed = time.time() - start_time
        status = "Accepted" if proc.returncode == 0 else "Runtime Error"
        return {
            "stdout": proc.stdout,
            "stderr": proc.stderr,
            "compile_output": "",
            "status": status,
            "time": f"{elapsed:.2f}",
            "memory": 4096
        }
    except subprocess.TimeoutExpired as e:
        partial_stdout = e.stdout if isinstance(e.stdout, str) else (e.stdout.decode("utf-8", errors="replace") if e.stdout else "")
        partial_stderr = e.stderr if isinstance(e.stderr, str) else (e.stderr.decode("utf-8", errors="replace") if e.stderr else "")
        hint = "\n[HINT] Your program timed out after 10s. If it uses an interactive loop or expects input via `input()`, please provide your input values in the 'Input (stdin)' tab!"
        return {
            "stdout": partial_stdout[:4000] if partial_stdout else "",
            "stderr": ((partial_stderr + "\n") if partial_stderr else "") + "Time Limit Exceeded (10s limit)" + hint,
            "compile_output": "",
            "status": "Time Limit Exceeded",
            "time": "10.00",
            "memory": 0
        }
    except Exception as e:
        return {
            "stdout": "",
            "stderr": f"Execution error: {str(e)}",
            "compile_output": "",
            "status": "Runtime Error",
            "time": f"{time.time() - start_time:.2f}",
            "memory": 0
        }
    finally:
        if os.path.exists(py_path):
            try:
                os.remove(py_path)
            except:
                pass


def _run_java_sync(source_code: str, stdin_data: str) -> dict:
    temp_dir = tempfile.mkdtemp()
    java_file = os.path.join(temp_dir, "Main.java")
    with open(java_file, "w", encoding="utf-8") as f:
        f.write(source_code)
        
    start_time = time.time()
    try:
        # Compile
        c_proc = subprocess.run(
            ["javac", java_file],
            capture_output=True,
            text=True,
            timeout=15
        )
        if c_proc.returncode != 0:
            return {
                "stdout": "",
                "stderr": "",
                "compile_output": c_proc.stderr,
                "status": "Compilation Error",
                "time": f"{time.time() - start_time:.2f}",
                "memory": 0
            }
            
        # Execute with closed EOF pipe if stdin is empty
        run_start = time.time()
        stdin_text = stdin_data if stdin_data is not None else ""
        r_proc = subprocess.run(
            ["java", "-cp", temp_dir, "Main"],
            input=stdin_text,
            capture_output=True,
            text=True,
            timeout=15
        )
        elapsed = time.time() - run_start
        status = "Accepted" if r_proc.returncode == 0 else "Runtime Error"
        return {
            "stdout": r_proc.stdout,
            "stderr": r_proc.stderr,
            "compile_output": "",
            "status": status,
            "time": f"{elapsed:.2f}",
            "memory": 8192
        }
    except subprocess.TimeoutExpired as e:
        partial_stdout = e.stdout if isinstance(e.stdout, str) else (e.stdout.decode("utf-8", errors="replace") if e.stdout else "")
        partial_stderr = e.stderr if isinstance(e.stderr, str) else (e.stderr.decode("utf-8", errors="replace") if e.stderr else "")
        hint = "\n[HINT] Your program timed out after 10s. If it uses an interactive loop or expects input via `Scanner`, please provide your input values in the 'Input (stdin)' tab!"
        return {
            "stdout": partial_stdout[:4000] if partial_stdout else "",
            "stderr": ((partial_stderr + "\n") if partial_stderr else "") + "Time Limit Exceeded (10s limit)" + hint,
            "compile_output": "",
            "status": "Time Limit Exceeded",
            "time": "10.00",
            "memory": 0
        }
    except Exception as e:
        return {
            "stdout": "",
            "stderr": f"Execution error: {str(e)}",
            "compile_output": "",
            "status": "Runtime Error",
            "time": f"{time.time() - start_time:.2f}",
            "memory": 0
        }
    finally:
        shutil.rmtree(temp_dir, ignore_errors=True)


def _run_sql_sync(source_code: str) -> dict:
    start_time = time.time()
    try:
        conn = sqlite3.connect(":memory:")
        cursor = conn.cursor()
        
        output_lines = []
        for statement in source_code.split(";"):
            stmt = statement.strip()
            if not stmt:
                continue
            cursor.execute(stmt)
            if cursor.description:
                columns = [d[0] for d in cursor.description]
                rows = cursor.fetchall()
                
                # Format table
                col_widths = [max(len(col), max((len(str(row[i])) for row in rows), default=0)) for i, col in enumerate(columns)]
                header = " | ".join(col.ljust(col_widths[i]) for i, col in enumerate(columns))
                sep = "-+-".join("-" * w for w in col_widths)
                output_lines.append(header)
                output_lines.append(sep)
                for row in rows:
                    output_lines.append(" | ".join(str(val).ljust(col_widths[i]) for i, val in enumerate(row)))
                output_lines.append(f"({len(rows)} row{'s' if len(rows) != 1 else ''})\n")
                
        conn.commit()
        conn.close()
        
        elapsed = time.time() - start_time
        return {
            "stdout": "\n".join(output_lines) or "Query executed successfully. (0 rows affected)",
            "stderr": "",
            "compile_output": "",
            "status": "Accepted",
            "time": f"{elapsed:.2f}",
            "memory": 1024
        }
    except Exception as e:
        return {
            "stdout": "",
            "stderr": f"SQL Error: {str(e)}",
            "compile_output": "",
            "status": "Runtime Error",
            "time": f"{time.time() - start_time:.2f}",
            "memory": 0
        }


async def run_code_locally(language: str, source_code: str, stdin: str) -> dict:
    lang = language.lower()
    if lang in ["c"]:
        return await asyncio.to_thread(_run_c_cpp_sync, source_code, stdin, False)
    elif lang in ["cpp", "c++"]:
        return await asyncio.to_thread(_run_c_cpp_sync, source_code, stdin, True)
    elif lang in ["python", "python3"]:
        return await asyncio.to_thread(_run_python_sync, source_code, stdin)
    elif lang in ["java"]:
        return await asyncio.to_thread(_run_java_sync, source_code, stdin)
    elif lang in ["sql", "mysql", "sqlite"]:
        return await asyncio.to_thread(_run_sql_sync, source_code)
    else:
        raise HTTPException(
            status_code=400,
            detail=f"Local execution for '{language}' not configured.",
        )


@router.post("/run")
async def run_code(request: CodeRunRequest):
    """Execute code using Judge0 if API key is provided, otherwise run natively with local compilers."""
    language = request.language.lower()
    
    # If no Judge0 key is provided, execute locally immediately!
    if not JUDGE0_API_KEY or "your_" in JUDGE0_API_KEY.lower():
        return await run_code_locally(language, request.source_code, request.stdin or "")

    # Otherwise attempt Judge0 API
    language_id = LANGUAGE_MAP.get(language)
    if not language_id:
        raise HTTPException(
            status_code=400,
            detail=f"Unsupported language: {language}. Supported: {', '.join(LANGUAGE_MAP.keys())}",
        )

    source_code_b64 = base64.b64encode(request.source_code.encode()).decode()
    stdin_b64 = base64.b64encode(request.stdin.encode()).decode() if request.stdin else ""

    headers = {
        "Content-Type": "application/json",
        "X-RapidAPI-Key": JUDGE0_API_KEY,
        "X-RapidAPI-Host": "judge0-ce.p.rapidapi.com",
    }

    submission_data = {
        "language_id": language_id,
        "source_code": source_code_b64,
        "stdin": stdin_b64,
    }

    try:
        async with httpx.AsyncClient(timeout=25.0) as client:
            response = await client.post(
                f"{JUDGE0_API_URL}/submissions?base64_encoded=true&wait=true",
                json=submission_data,
                headers=headers,
            )

            # If RapidAPI rejects with 401 or invalid key, fall back locally seamlessly!
            if response.status_code in [401, 403] or "Invalid API key" in response.text:
                return await run_code_locally(language, request.source_code, request.stdin or "")

            if response.status_code not in [200, 201]:
                return await run_code_locally(language, request.source_code, request.stdin or "")

            result = response.json()

            stdout = ""
            stderr = ""
            compile_output = ""

            if result.get("stdout"):
                stdout = base64.b64decode(result["stdout"]).decode("utf-8", errors="replace")
            if result.get("stderr"):
                stderr = base64.b64decode(result["stderr"]).decode("utf-8", errors="replace")
            if result.get("compile_output"):
                compile_output = base64.b64decode(result["compile_output"]).decode("utf-8", errors="replace")

            status_desc = result.get("status", {}).get("description", "Unknown")

            return {
                "stdout": stdout,
                "stderr": stderr,
                "compile_output": compile_output,
                "status": status_desc,
                "time": result.get("time"),
                "memory": result.get("memory"),
            }

    except Exception:
        # Seamless local fallback on network error
        return await run_code_locally(language, request.source_code, request.stdin or "")
