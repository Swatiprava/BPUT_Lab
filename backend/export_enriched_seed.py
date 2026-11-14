"""
Export enriched experiments into db/seed.sql so the database seed script is kept in sync.
"""

import os
import sys
sys.path.insert(0, os.path.dirname(__file__))

from supabase_client import get_supabase_admin

def escape_sql(text):
    if text is None:
        return "NULL"
    return "'" + text.replace("'", "''") + "'"

def export_seed():
    admin = get_supabase_admin()
    
    # Fetch subjects
    sub_res = admin.table("subjects").select("*").order("semester").execute()
    subjects = sub_res.data
    
    # Fetch experiments with subjects
    exp_res = admin.table("experiments").select("*, subjects(code, name, semester, language)").order("experiment_number").execute()
    experiments = exp_res.data
    
    seed_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), "db", "seed.sql")
    print(f"Exporting enriched seed data to {seed_path}...")
    
    lines = [
        "-- ============================================================",
        "-- PPD Lab Platform — Seed Data",
        "-- All subjects and enriched experiments from BPUT CSE Syllabus",
        "-- ============================================================",
        "-- Run this in Supabase SQL Editor AFTER running migration.sql",
        "-- ============================================================",
        "",
        "-- ============================================================",
        "-- SUBJECTS",
        "-- ============================================================",
        "",
        "INSERT INTO subjects (code, name, semester, language) VALUES"
    ]
    
    sub_rows = []
    for s in subjects:
        sub_rows.append(f"({escape_sql(s['code'])}, {escape_sql(s['name'])}, {s['semester']}, {escape_sql(s['language'])})")
    
    lines.append(",\n".join(sub_rows))
    lines.append("ON CONFLICT (code) DO NOTHING;")
    lines.append("")
    
    # Group experiments by subject
    exps_by_sub = {}
    for exp in experiments:
        code = exp["subjects"]["code"]
        if code not in exps_by_sub:
            exps_by_sub[code] = []
        exps_by_sub[code].append(exp)
        
    for s in subjects:
        code = s["code"]
        name = s["name"]
        sem = s["semester"]
        lang = s["language"]
        
        sub_exps = exps_by_sub.get(code, [])
        if not sub_exps:
            continue
            
        sub_exps.sort(key=lambda x: x["experiment_number"])
        
        lines.append("")
        lines.append("-- ============================================================")
        lines.append(f"-- {code}: {name} (Sem {sem}, {lang.upper()})")
        lines.append("-- ============================================================")
        lines.append("INSERT INTO experiments (subject_id, experiment_number, title, description, boilerplate_code) VALUES")
        
        exp_rows = []
        for e in sub_exps:
            s_id = f"(SELECT id FROM subjects WHERE code={escape_sql(code)})"
            e_num = e["experiment_number"]
            title = escape_sql(e["title"])
            desc = escape_sql(e.get("description") or "")
            bp = escape_sql(e.get("boilerplate_code") or "")
            exp_rows.append(f"({s_id}, {e_num}, {title}, {desc}, {bp})")
            
        lines.append(",\n".join(exp_rows))
        lines.append("ON CONFLICT (subject_id, experiment_number) DO UPDATE SET")
        lines.append("  title = EXCLUDED.title,")
        lines.append("  description = EXCLUDED.description,")
        lines.append("  boilerplate_code = EXCLUDED.boilerplate_code;")
        
    content = "\n".join(lines) + "\n"
    
    with open(seed_path, "w", encoding="utf-8") as f:
        f.write(content)
        
    print(f"SUCCESS: Exported {len(subjects)} subjects and {len(experiments)} experiments ({len(content)} bytes) to db/seed.sql")

if __name__ == "__main__":
    export_seed()
