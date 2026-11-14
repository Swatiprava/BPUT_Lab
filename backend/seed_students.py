"""
Seed student users into Supabase Auth and the students database table.
Reads student details from generate_students.py and creates users in Supabase.
"""

import asyncio
from supabase_client import get_supabase_admin
from generate_students import students_data

def seed_students():
    admin = get_supabase_admin()
    print("Connecting to Supabase to register and seed student accounts...")

    total_created = 0
    total_skipped = 0

    for sem, students in students_data.items():
        print(f"\n--- Processing Semester {sem} ({len(students)} students) ---")
        for name, reg_no, semester, username, password in students:
            email = f"{username}@bput.ac.in"

            auth_user_id = None
            try:
                # Create user in Supabase Auth
                user_res = admin.auth.admin.create_user({
                    "email": email,
                    "password": password,
                    "email_confirm": True,
                    "user_metadata": {
                        "name": name,
                        "registration_number": reg_no,
                        "semester": semester,
                        "username": username
                    }
                })
                if user_res.user:
                    auth_user_id = user_res.user.id
                    print(f" [AUTH CREATED] {name} ({email})")
            except Exception as e:
                err_str = str(e)
                if "already registered" in err_str or "already been registered" in err_str:
                    print(f" [AUTH EXISTS] {email}")
                else:
                    print(f" [AUTH WARN] {email}: {err_str}")

            # Upsert into students table
            try:
                # Check if exists
                check = admin.table("students").select("id, auth_user_id").eq("registration_number", reg_no).execute()
                if check.data:
                    # Update auth_user_id if available
                    if auth_user_id:
                        admin.table("students").update({"auth_user_id": auth_user_id}).eq("registration_number", reg_no).execute()
                    total_skipped += 1
                else:
                    student_payload = {
                        "name": name,
                        "registration_number": reg_no,
                        "semester": semester,
                        "username": username,
                    }
                    if auth_user_id:
                        student_payload["auth_user_id"] = auth_user_id

                    admin.table("students").insert(student_payload).execute()
                    total_created += 1
                    print(f"   -> Inserted into students table: {reg_no}")
            except Exception as db_err:
                print(f"   -> DB Error for {reg_no}: {db_err}")

    print(f"\n[DONE] Student seeding complete: {total_created} new added, {total_skipped} existing.")

if __name__ == "__main__":
    seed_students()
