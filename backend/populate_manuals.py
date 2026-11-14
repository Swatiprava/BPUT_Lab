"""
Master script to populate all 112 experiments across all 11 BPUT CSE subjects
with comprehensive, university-standard lab manuals.
"""

import sys
import os
import time

sys.path.insert(0, os.path.dirname(__file__))

from supabase_client import get_supabase_admin
from manuals_data.sem3 import SEM3_MANUALS
from manuals_data.sem4 import SEM4_MANUALS
from manuals_data.sem5 import SEM5_MANUALS
from manuals_data.sem6 import SEM6_MANUALS

def main():
    all_manuals = {}
    all_manuals.update(SEM3_MANUALS)
    all_manuals.update(SEM4_MANUALS)
    all_manuals.update(SEM5_MANUALS)
    all_manuals.update(SEM6_MANUALS)

    print(f"Loaded {len(all_manuals)} university lab manuals from data modules.")

    admin = get_supabase_admin()
    print("Connecting to Supabase and fetching existing experiments...")
    
    res = admin.table("experiments").select("id, experiment_number, title, subject_id, subjects(code, name, semester)").execute()
    experiments = res.data
    total = len(experiments)
    print(f"Found {total} experiments in database to update.")

    updated_count = 0
    missing_count = 0

    for exp in experiments:
        exp_id = exp["id"]
        exp_num = exp["experiment_number"]
        sub_code = exp["subjects"]["code"]
        title = exp["title"]

        manual = all_manuals.get((sub_code, exp_num))
        if not manual:
            print(f"⚠️ Warning: Missing manual for {sub_code} Exp {exp_num}: '{title}'")
            missing_count += 1
            continue

        try:
            admin.table("experiments").update({"description": manual.strip()}).eq("id", exp_id).execute()
            updated_count += 1
            if updated_count % 10 == 0 or updated_count == total:
                print(f"[{updated_count}/{total}] Enriched {sub_code} Exp {exp_num:02d}: {title} ({len(manual)} chars)")
        except Exception as e:
            print(f"[ERROR] Failed to update {sub_code} Exp {exp_num}: {e}")
            time.sleep(1)

    print("\n" + "=" * 60)
    print(f"RESULT: Successfully updated {updated_count}/{total} experiments in Supabase.")
    if missing_count > 0:
        print(f"WARNING: {missing_count} experiments had no template.")
    else:
        print("SUCCESS: 100% of experiments now have comprehensive university lab manuals!")
    print("=" * 60)

if __name__ == "__main__":
    main()
