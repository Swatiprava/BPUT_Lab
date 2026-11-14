"""
PPD Lab Platform — FastAPI Backend
Biju Patnaik University of Technology, Rourkela
Department of Computer Science & Engineering
"""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

load_dotenv()

from routers import auth, subjects, experiments, submissions, code_runner, students

app = FastAPI(
    title="PPD Lab Platform API",
    description="Backend API for the BPUT CSE Lab Environment Platform",
    version="1.0.0",
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=[os.getenv("FRONTEND_URL", "http://localhost:5173")],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(subjects.router, prefix="/api/subjects", tags=["Subjects"])
app.include_router(experiments.router, prefix="/api/experiments", tags=["Experiments"])
app.include_router(submissions.router, prefix="/api/submissions", tags=["Submissions"])
app.include_router(code_runner.router, prefix="/api/code", tags=["Code Execution"])
app.include_router(students.router, prefix="/api/students", tags=["Students"])


@app.get("/")
async def root():
    return {"message": "PPD Lab Platform API — BPUT Rourkela, CSE Department"}


@app.get("/api/health")
async def health_check():
    return {"status": "healthy"}
