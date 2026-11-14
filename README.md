# PPD Lab Platform — BPUT CSE

> Online Lab Platform for BPUT Computer Science Engineers  
> Write, compile, and submit semester lab experiments straight from your browser.

![PPD Lab Platform](frontend/src/assets/hero.png)

## ✨ Features

- **Monaco Code Editor** — Full-featured IDE with syntax highlighting, autocomplete, and themes
- **Interactive CLI** — Real-time terminal input/output with stdin support
- **Multi-Language Support** — C, Java, Python, SQL/MySQL
- **Real-time Code Execution** — Compile and run code instantly via Judge0 API
- **Student Portal** — Browse experiments by subject and semester, view submission status
- **Faculty Portal** — Review student submissions, track pending/submitted status with real-time IST timestamps
- **BPUT Curriculum Aligned** — Semesters 3–6 with verified lab manuals and experiment schedules
- **Supabase Backend** — Authentication, database, and real-time data powered by Supabase

## 🏗️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | React 19 + Vite, Tailwind CSS, Monaco Editor, React Router |
| **Backend** | FastAPI (Python), Uvicorn |
| **Database** | Supabase (PostgreSQL) |
| **Code Execution** | Judge0 CE API |
| **Auth** | Supabase Auth (email/password) |

## 📁 Project Structure

```
PPD/
├── frontend/              # React + Vite frontend
│   ├── src/
│   │   ├── pages/         # Landing, Login, Dashboard, CodeLab, Faculty pages
│   │   ├── lib/           # API client, utilities, schedule, teachers data
│   │   └── components/    # Reusable UI components
│   └── public/            # Static assets
├── backend/               # FastAPI backend
│   ├── routers/           # API routes (auth, subjects, experiments, submissions, code_runner)
│   ├── manuals_data/      # Lab manual content (sem 3–6)
│   └── supabase_client.py # Supabase connection
├── db/                    # Database schema & migrations
│   ├── schema.ts          # Drizzle schema definition
│   ├── migration.sql      # SQL migration
│   └── seed.sql           # Seed data
├── data/                  # Student & teacher datasets
│   ├── students_sem*.xlsx # Student rosters per semester
│   └── teachers.csv       # Faculty assignments
└── Syllabus/              # BPUT syllabus documents (sem 3–6)
```

## 🚀 Getting Started

### Prerequisites

- **Node.js** ≥ 18
- **Python** ≥ 3.10
- **Supabase** account (free tier works)

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/PPD-Lab-Platform.git
cd PPD-Lab-Platform
```

### 2. Backend Setup

```bash
cd backend
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS/Linux

pip install -r requirements.txt

# Copy and fill in your Supabase credentials
copy .env.example .env       # Windows
# cp .env.example .env       # macOS/Linux

# Start the backend server
uvicorn main:app --host 0.0.0.0 --port 8000
```

### 3. Frontend Setup

```bash
cd frontend

npm install

# Copy and fill in your Supabase credentials
copy .env.example .env       # Windows
# cp .env.example .env       # macOS/Linux

# Start the dev server
npm run dev
```

### 4. Open in browser

```
http://localhost:5173
```

### 5. Database Setup

Run the SQL in `db/migration.sql` and `db/seed.sql` in your Supabase SQL editor to create tables and seed experiment data.

## 📸 Screenshots

### Landing Page
Sleek dark-themed landing with student and faculty portals.

### Student Dashboard
Browse subjects, view experiments grouped by week, track submission status with IST timestamps.

### Code Lab (IDE)
Monaco-powered editor with real-time compilation, interactive terminal, and one-click submit.

### Faculty Portal
Review student submissions, see real-time status (Submitted/Pending), view code with syntax highlighting.

## 👥 Faculty Assignments

| Faculty | Subjects |
|---------|----------|
| Dr. Smruti Rekha Das | Data Structures Lab, Design & Analysis of Algorithms Lab |
| Prof. Ananya Mohanty | Database Engineering Lab, Computer Networks Lab |
| Dr. Rajesh Kumar Panda | Computer Organization Lab, Theory of Computation Lab |

## 🔑 Environment Variables

### Backend (`backend/.env`)
| Variable | Description |
|----------|-------------|
| `SUPABASE_URL` | Your Supabase project URL |
| `SUPABASE_KEY` | Supabase anon/public key |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service role key (admin) |
| `JUDGE0_API_URL` | Judge0 API endpoint |
| `JUDGE0_API_KEY` | RapidAPI key for Judge0 |

### Frontend (`frontend/.env`)
| Variable | Description |
|----------|-------------|
| `VITE_SUPABASE_URL` | Your Supabase project URL |
| `VITE_SUPABASE_ANON_KEY` | Supabase anon/public key |
| `VITE_API_URL` | Backend API URL (default: `http://localhost:8000`) |

## 📄 License

This project is built for academic use at BPUT, Rourkela.

---

Built with ❤️ for BPUT CSE Department
