-- ============================================================
-- PPD Lab Platform — Database Schema
-- Biju Patnaik University of Technology (BPUT), Rourkela
-- Department of Computer Science & Engineering
-- ============================================================
-- Run this SQL in your Supabase SQL Editor to create all tables
-- ============================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- 1. STUDENTS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS students (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    registration_number TEXT UNIQUE NOT NULL,
    semester INTEGER NOT NULL CHECK (semester >= 1 AND semester <= 8),
    username TEXT UNIQUE NOT NULL,
    auth_user_id UUID UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast lookups
CREATE INDEX IF NOT EXISTS idx_students_semester ON students(semester);
CREATE INDEX IF NOT EXISTS idx_students_auth_user_id ON students(auth_user_id);

-- ============================================================
-- 2. SUBJECTS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS subjects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    semester INTEGER NOT NULL CHECK (semester >= 1 AND semester <= 8),
    language TEXT NOT NULL DEFAULT 'python',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_subjects_semester ON subjects(semester);

-- ============================================================
-- 3. EXPERIMENTS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS experiments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject_id UUID NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    experiment_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    boilerplate_code TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(subject_id, experiment_number)
);

CREATE INDEX IF NOT EXISTS idx_experiments_subject ON experiments(subject_id);

-- ============================================================
-- 4. SUBMISSIONS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS submissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    experiment_id UUID NOT NULL REFERENCES experiments(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    output TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'submitted', 'evaluated')),
    submitted_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(student_id, experiment_id)
);

CREATE INDEX IF NOT EXISTS idx_submissions_student ON submissions(student_id);
CREATE INDEX IF NOT EXISTS idx_submissions_experiment ON submissions(experiment_id);

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE experiments ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- Students can read their own profile
CREATE POLICY "Students can view their own profile"
    ON students FOR SELECT
    USING (auth.uid() = auth_user_id);

-- All authenticated users can read subjects
CREATE POLICY "Authenticated users can view subjects"
    ON subjects FOR SELECT
    TO authenticated
    USING (true);

-- All authenticated users can read experiments
CREATE POLICY "Authenticated users can view experiments"
    ON experiments FOR SELECT
    TO authenticated
    USING (true);

-- Students can view/create/update their own submissions
CREATE POLICY "Students can view own submissions"
    ON submissions FOR SELECT
    USING (
        student_id IN (
            SELECT id FROM students WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Students can insert own submissions"
    ON submissions FOR INSERT
    WITH CHECK (
        student_id IN (
            SELECT id FROM students WHERE auth_user_id = auth.uid()
        )
    );

CREATE POLICY "Students can update own submissions"
    ON submissions FOR UPDATE
    USING (
        student_id IN (
            SELECT id FROM students WHERE auth_user_id = auth.uid()
        )
    );

-- Service role bypasses RLS, so backend admin operations work without issues
