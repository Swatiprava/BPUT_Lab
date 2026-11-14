"""
Generate student Excel files for each semester.
10 students per semester (3rd, 4th, 5th, 6th).
Each file has: Name, Registration Number, Semester, Username, Password
"""

import openpyxl
from openpyxl.styles import Font, Alignment, PatternFill, Border, Side
import os

# Student data per semester
students_data = {
    3: [
        ("Aarav Sharma", "BPUT2024CS001", 3, "aarav.sharma", "Lab@2024cs001"),
        ("Priya Mishra", "BPUT2024CS002", 3, "priya.mishra", "Lab@2024cs002"),
        ("Rohit Patel", "BPUT2024CS003", 3, "rohit.patel", "Lab@2024cs003"),
        ("Sneha Das", "BPUT2024CS004", 3, "sneha.das", "Lab@2024cs004"),
        ("Amit Kumar", "BPUT2024CS005", 3, "amit.kumar", "Lab@2024cs005"),
        ("Kavita Nayak", "BPUT2024CS006", 3, "kavita.nayak", "Lab@2024cs006"),
        ("Sujit Behera", "BPUT2024CS007", 3, "sujit.behera", "Lab@2024cs007"),
        ("Rashmita Mohanty", "BPUT2024CS008", 3, "rashmita.mohanty", "Lab@2024cs008"),
        ("Deepak Sahoo", "BPUT2024CS009", 3, "deepak.sahoo", "Lab@2024cs009"),
        ("Ananya Rath", "BPUT2024CS010", 3, "ananya.rath", "Lab@2024cs010"),
    ],
    4: [
        ("Siddharth Mohapatra", "BPUT2023CS011", 4, "siddharth.mohapatra", "Lab@2023cs011"),
        ("Lipsa Pradhan", "BPUT2023CS012", 4, "lipsa.pradhan", "Lab@2023cs012"),
        ("Bikash Swain", "BPUT2023CS013", 4, "bikash.swain", "Lab@2023cs013"),
        ("Sonali Parida", "BPUT2023CS014", 4, "sonali.parida", "Lab@2023cs014"),
        ("Rajesh Jena", "BPUT2023CS015", 4, "rajesh.jena", "Lab@2023cs015"),
        ("Mamata Rout", "BPUT2023CS016", 4, "mamata.rout", "Lab@2023cs016"),
        ("Prakash Nanda", "BPUT2023CS017", 4, "prakash.nanda", "Lab@2023cs017"),
        ("Sushree Panda", "BPUT2023CS018", 4, "sushree.panda", "Lab@2023cs018"),
        ("Tushar Lenka", "BPUT2023CS019", 4, "tushar.lenka", "Lab@2023cs019"),
        ("Rina Mohanty", "BPUT2023CS020", 4, "rina.mohanty", "Lab@2023cs020"),
    ],
    5: [
        ("Abhishek Satpathy", "BPUT2022CS021", 5, "abhishek.satpathy", "Lab@2022cs021"),
        ("Debashree Sahu", "BPUT2022CS022", 5, "debashree.sahu", "Lab@2022cs022"),
        ("Kishore Tripathy", "BPUT2022CS023", 5, "kishore.tripathy", "Lab@2022cs023"),
        ("Monalisa Kar", "BPUT2022CS024", 5, "monalisa.kar", "Lab@2022cs024"),
        ("Niranjan Barik", "BPUT2022CS025", 5, "niranjan.barik", "Lab@2022cs025"),
        ("Pallavi Mishra", "BPUT2022CS026", 5, "pallavi.mishra", "Lab@2022cs026"),
        ("Ranjan Das", "BPUT2022CS027", 5, "ranjan.das", "Lab@2022cs027"),
        ("Smita Acharya", "BPUT2022CS028", 5, "smita.acharya", "Lab@2022cs028"),
        ("Tapas Mahapatra", "BPUT2022CS029", 5, "tapas.mahapatra", "Lab@2022cs029"),
        ("Uma Priyadarshini", "BPUT2022CS030", 5, "uma.priyadarshini", "Lab@2022cs030"),
    ],
    6: [
        ("Vikas Mohanty", "BPUT2021CS031", 6, "vikas.mohanty", "Lab@2021cs031"),
        ("Barsha Nayak", "BPUT2021CS032", 6, "barsha.nayak", "Lab@2021cs032"),
        ("Chandan Sethi", "BPUT2021CS033", 6, "chandan.sethi", "Lab@2021cs033"),
        ("Dipti Routray", "BPUT2021CS034", 6, "dipti.routray", "Lab@2021cs034"),
        ("Ganesh Pradhan", "BPUT2021CS035", 6, "ganesh.pradhan", "Lab@2021cs035"),
        ("Harshita Mishra", "BPUT2021CS036", 6, "harshita.mishra", "Lab@2021cs036"),
        ("Jitendra Panda", "BPUT2021CS037", 6, "jitendra.panda", "Lab@2021cs037"),
        ("Kalyani Behera", "BPUT2021CS038", 6, "kalyani.behera", "Lab@2021cs038"),
        ("Laxman Rao", "BPUT2021CS039", 6, "laxman.rao", "Lab@2021cs039"),
        ("Mitali Sahoo", "BPUT2021CS040", 6, "mitali.sahoo", "Lab@2021cs040"),
    ],
}

output_dir = os.path.join(os.path.dirname(__file__), "..", "data")
os.makedirs(output_dir, exist_ok=True)

# Styles
header_font = Font(name='Calibri', bold=True, size=12, color="FFFFFF")
header_fill = PatternFill(start_color="1F4E79", end_color="1F4E79", fill_type="solid")
title_font = Font(name='Calibri', bold=True, size=14, color="1F4E79")
data_font = Font(name='Calibri', size=11)
border = Border(
    left=Side(style='thin'),
    right=Side(style='thin'),
    top=Side(style='thin'),
    bottom=Side(style='thin')
)

for semester, students in students_data.items():
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = f"Semester {semester} Students"

    # Title row
    ws.merge_cells('A1:E1')
    title_cell = ws['A1']
    title_cell.value = f"BPUT Rourkela — CSE Department — Semester {semester} Students"
    title_cell.font = title_font
    title_cell.alignment = Alignment(horizontal='center', vertical='center')
    ws.row_dimensions[1].height = 30

    # Empty row
    ws.row_dimensions[2].height = 10

    # Headers
    headers = ["Name", "Registration Number", "Semester", "Username", "Password"]
    for col, header in enumerate(headers, 1):
        cell = ws.cell(row=3, column=col, value=header)
        cell.font = header_font
        cell.fill = header_fill
        cell.alignment = Alignment(horizontal='center', vertical='center')
        cell.border = border

    # Data rows
    for row_idx, student in enumerate(students, 4):
        for col_idx, value in enumerate(student, 1):
            cell = ws.cell(row=row_idx, column=col_idx, value=value)
            cell.font = data_font
            cell.alignment = Alignment(horizontal='center', vertical='center')
            cell.border = border

    # Column widths
    ws.column_dimensions['A'].width = 30
    ws.column_dimensions['B'].width = 22
    ws.column_dimensions['C'].width = 12
    ws.column_dimensions['D'].width = 25
    ws.column_dimensions['E'].width = 20

    filepath = os.path.join(output_dir, f"students_sem{semester}.xlsx")
    wb.save(filepath)
    print(f"Created: {filepath}")

print("\nAll student Excel files generated successfully!")
print(f"Total students: {sum(len(s) for s in students_data.values())}")
