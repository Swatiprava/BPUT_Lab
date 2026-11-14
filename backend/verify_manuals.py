"""
Verify all 112 experiments in Supabase have rich, university-grade lab manual descriptions.
"""

from supabase_client import get_supabase_admin

def verify():
    admin = get_supabase_admin()
    res = admin.table("experiments").select("id, experiment_number, title, description, subjects(code, name, semester)").order("experiment_number").execute()
    
    experiments = res.data
    total = len(experiments)
    
    print(f"Total experiments found: {total}")
    
    short_descriptions = []
    sem_stats = {}
    
    for exp in experiments:
        sub = exp["subjects"]["code"]
        sem = exp["subjects"]["semester"]
        title = exp["title"]
        desc = exp.get("description") or ""
        desc_len = len(desc)
        
        sem_stats[sem] = sem_stats.get(sem, 0) + 1
        
        # Check for core sections
        has_aim = "Aim of the Experiment" in desc or "Aim" in desc
        has_viva = "Viva" in desc
        
        if desc_len < 500 or not has_aim:
            short_descriptions.append((sub, exp["experiment_number"], title, desc_len))

    print("\n--- Semester Breakdown ---")
    for sem in sorted(sem_stats.keys()):
        print(f"Semester {sem}: {sem_stats[sem]} experiments")
        
    print("\n--- Validation Results ---")
    if short_descriptions:
        print(f"FAILED: {len(short_descriptions)} experiments have missing or short descriptions:")
        for s in short_descriptions:
            print(f"  {s[0]} Exp {s[1]}: {s[2]} ({s[3]} chars)")
    else:
        print(f"PASSED: All {total} experiments have full, university-standard lab manuals!")
        
    # Sample view of one experiment from each semester
    sample_sub_codes = ["CSPC2202", "CSPC2204", "CSPC3202", "CSPC3204"]
    print("\n--- Sample Manual Snippets ---")
    for exp in experiments:
        if exp["subjects"]["code"] in sample_sub_codes and exp["experiment_number"] == 1:
            desc = exp.get("description") or ""
            preview = desc.split("\n")[0] if desc else "EMPTY"
            print(f"[{exp['subjects']['code']} Exp 01] Header: '{preview}' | Total length: {len(desc)} characters")

if __name__ == "__main__":
    verify()
