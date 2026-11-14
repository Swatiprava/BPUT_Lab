/**
 * PPD Lab Platform — Drizzle ORM Schema
 * Biju Patnaik University of Technology (BPUT), Rourkela
 * Department of Computer Science & Engineering
 */

import { pgTable, uuid, text, integer, timestamp, unique, check } from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';

// ============================================================
// 1. STUDENTS TABLE
// ============================================================
export const students = pgTable('students', {
  id: uuid('id').primaryKey().defaultRandom(),
  name: text('name').notNull(),
  registrationNumber: text('registration_number').unique().notNull(),
  semester: integer('semester').notNull(),
  username: text('username').unique().notNull(),
  authUserId: uuid('auth_user_id').unique(),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
});

// ============================================================
// 2. SUBJECTS TABLE
// ============================================================
export const subjects = pgTable('subjects', {
  id: uuid('id').primaryKey().defaultRandom(),
  code: text('code').unique().notNull(),
  name: text('name').notNull(),
  semester: integer('semester').notNull(),
  language: text('language').notNull().default('python'),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
});

// ============================================================
// 3. EXPERIMENTS TABLE
// ============================================================
export const experiments = pgTable('experiments', {
  id: uuid('id').primaryKey().defaultRandom(),
  subjectId: uuid('subject_id').notNull().references(() => subjects.id, { onDelete: 'cascade' }),
  experimentNumber: integer('experiment_number').notNull(),
  title: text('title').notNull(),
  description: text('description').notNull(),
  boilerplateCode: text('boilerplate_code'),
  createdAt: timestamp('created_at', { withTimezone: true }).defaultNow(),
}, (table) => ({
  uniqueSubjectExperiment: unique().on(table.subjectId, table.experimentNumber),
}));

// ============================================================
// 4. SUBMISSIONS TABLE
// ============================================================
export const submissions = pgTable('submissions', {
  id: uuid('id').primaryKey().defaultRandom(),
  studentId: uuid('student_id').notNull().references(() => students.id, { onDelete: 'cascade' }),
  experimentId: uuid('experiment_id').notNull().references(() => experiments.id, { onDelete: 'cascade' }),
  code: text('code').notNull(),
  output: text('output'),
  status: text('status').notNull().default('pending'),
  submittedAt: timestamp('submitted_at', { withTimezone: true }).defaultNow(),
}, (table) => ({
  uniqueStudentExperiment: unique().on(table.studentId, table.experimentId),
}));
