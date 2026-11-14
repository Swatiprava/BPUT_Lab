/**
 * PPD Lab Platform — Academic Lab Schedule & Timetable Engine
 * Biju Patnaik University of Technology (BPUT), Rourkela
 * Department of Computer Science & Engineering
 *
 * Rules:
 * - 2 questions/experiments per week per subject (unless overridden)
 * - Each subject in a semester has a unique, non-overlapping lab day
 * - Odd Semesters (Sem 3 & Sem 5) start in August (Monsoon Session)
 * - Even Semesters (Sem 4 & Sem 6) start in January (Spring Session)
 */

export const SUBJECT_SCHEDULES = {
  // ===== SEMESTER 3 (Odd Semester - Starts Aug 2024) =====
  CSPC2202: {
    code: 'CSPC2202',
    name: 'Data Structures Lab',
    semester: 3,
    dayOfWeek: 'Monday',
    dayIndex: 1, // 1 = Monday
    timeSlot: '02:00 PM – 05:00 PM',
    labRoom: 'Lab 1 (Turing Hall)',
    sessionStartDate: '2024-08-05', // First Monday of Aug 2024
  },
  CSPC2203: {
    code: 'CSPC2203',
    name: 'Object Oriented Programming Lab',
    semester: 3,
    dayOfWeek: 'Thursday',
    dayIndex: 4, // 4 = Thursday
    timeSlot: '02:00 PM – 05:00 PM',
    labRoom: 'Lab 2 (Gosling Center)',
    sessionStartDate: '2024-08-08', // First Thursday of Aug 2024
  },

  // ===== SEMESTER 4 (Even Semester - Starts Jan 2025) =====
  CSPC2206: {
    code: 'CSPC2206',
    name: 'Design & Analysis of Algorithms Lab',
    semester: 4,
    dayOfWeek: 'Monday',
    dayIndex: 1,
    timeSlot: '09:30 AM – 12:30 PM',
    labRoom: 'Lab 1 (Knuth Suite)',
    sessionStartDate: '2025-01-06',
  },
  CSPC2204: {
    code: 'CSPC2204',
    name: 'Database Engineering Lab',
    semester: 4,
    dayOfWeek: 'Tuesday',
    dayIndex: 2,
    timeSlot: '02:00 PM – 05:00 PM',
    labRoom: 'Lab 3 (Codd Computing Lab)',
    sessionStartDate: '2025-01-07',
  },
  CSPC2205: {
    code: 'CSPC2205',
    name: 'Computer Organization & Architecture Lab',
    semester: 4,
    dayOfWeek: 'Wednesday',
    dayIndex: 3,
    timeSlot: '02:00 PM – 05:00 PM',
    labRoom: 'Lab 4 (Hardware Sim Lab)',
    sessionStartDate: '2025-01-08',
    experimentsPerWeek: 1,
  },
  CSPC2207: {
    code: 'CSPC2207',
    name: 'Computer Networks Lab',
    semester: 4,
    dayOfWeek: 'Friday',
    dayIndex: 5,
    timeSlot: '02:00 PM – 05:00 PM',
    labRoom: 'Lab 2 (Cerf Network Center)',
    sessionStartDate: '2025-01-10',
  },

  // ===== SEMESTER 5 (Odd Semester - Starts Aug 2024) =====
  CSPC3202: {
    code: 'CSPC3202',
    name: 'Operating Systems Laboratory',
    semester: 5,
    dayOfWeek: 'Tuesday',
    dayIndex: 2,
    timeSlot: '09:30 AM – 12:30 PM',
    labRoom: 'Lab 1 (Unix & Systems Lab)',
    sessionStartDate: '2024-08-06',
  },
  CSPC3203: {
    code: 'CSPC3203',
    name: 'Machine Learning Laboratory',
    semester: 5,
    dayOfWeek: 'Thursday',
    dayIndex: 4,
    timeSlot: '09:30 AM – 12:30 PM',
    labRoom: 'Lab 5 (AI / GPU Compute Lab)',
    sessionStartDate: '2024-08-08',
  },
  CSPC3201: {
    code: 'CSPC3201',
    name: 'Theory of Computation Laboratory',
    semester: 5,
    dayOfWeek: 'Friday',
    dayIndex: 5,
    timeSlot: '09:30 AM – 12:30 PM',
    labRoom: 'Lab 3 (Automata Lab)',
    sessionStartDate: '2024-08-09',
  },

  // ===== SEMESTER 6 (Even Semester - Starts Jan 2025) =====
  CSPC3204: {
    code: 'CSPC3204',
    name: 'Compiler Design Laboratory',
    semester: 6,
    dayOfWeek: 'Monday',
    dayIndex: 1,
    timeSlot: '02:00 PM – 05:00 PM',
    labRoom: 'Lab 1 (Language Processing Lab)',
    sessionStartDate: '2025-01-06',
  },
  CSPC3205: {
    code: 'CSPC3205',
    name: 'Software Engineering Laboratory',
    semester: 6,
    dayOfWeek: 'Wednesday',
    dayIndex: 3,
    timeSlot: '09:30 AM – 12:30 PM',
    labRoom: 'Lab 2 (Agile & DevOps Lab)',
    sessionStartDate: '2025-01-08',
  },
}

/**
 * Calculate the exact week and calendar date for a given subject experiment
 * @param {string} subjectCode - e.g. "CSPC2202"
 * @param {number} experimentNumber - 1-indexed experiment number (1 to 13)
 * @returns {object} Schedule details including week number, date, formatted strings
 */
export function getExperimentSchedule(subjectCode, experimentNumber) {
  const sched = SUBJECT_SCHEDULES[subjectCode] || {
    dayOfWeek: 'Monday',
    timeSlot: '02:00 PM – 05:00 PM',
    labRoom: 'Main Computer Lab',
    sessionStartDate: '2024-08-05',
  }

  // Experiments per week (default 2 unless overridden per subject)
  const perWeek = sched.experimentsPerWeek || 2
  const weekNumber = Math.ceil(experimentNumber / perWeek)
  const questionIndexInWeek = ((experimentNumber - 1) % perWeek) + 1 // 1-based index within week

  // Start date of week 1
  const baseDate = new Date(sched.sessionStartDate)
  // Each subsequent week adds 7 days
  const targetDate = new Date(baseDate.getTime() + (weekNumber - 1) * 7 * 24 * 60 * 60 * 1000)

  const dateOptions = { year: 'numeric', month: 'short', day: '2-digit' }
  const formattedDate = targetDate.toLocaleDateString('en-IN', dateOptions)
  const fullDateStr = targetDate.toLocaleDateString('en-IN', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })

  return {
    weekNumber,
    questionIndexInWeek,
    totalQuestionsInWeek: perWeek,
    dayOfWeek: sched.dayOfWeek,
    timeSlot: sched.timeSlot,
    labRoom: sched.labRoom,
    formattedDate,
    fullDateStr,
    isoDate: targetDate.toISOString().split('T')[0],
  }
}

/**
 * Group an array of experiments by academic lab week
 * @param {string} subjectCode - e.g. "CSPC2202"
 * @param {Array} experiments - list of experiment objects
 * @returns {Array} List of week groups with metadata and experiments
 */
export function groupExperimentsByWeek(subjectCode, experiments) {
  if (!experiments || experiments.length === 0) return []

  const weeksMap = new Map()

  // Sort by experiment_number
  const sorted = [...experiments].sort((a, b) => a.experiment_number - b.experiment_number)

  for (const exp of sorted) {
    const sched = getExperimentSchedule(subjectCode, exp.experiment_number)
    const weekKey = sched.weekNumber

    if (!weeksMap.has(weekKey)) {
      weeksMap.set(weekKey, {
        weekNumber: sched.weekNumber,
        dayOfWeek: sched.dayOfWeek,
        formattedDate: sched.formattedDate,
        fullDateStr: sched.fullDateStr,
        timeSlot: sched.timeSlot,
        labRoom: sched.labRoom,
        experiments: [],
      })
    }

    weeksMap.get(weekKey).experiments.push({
      ...exp,
      schedule: sched,
    })
  }

  return Array.from(weeksMap.values())
}
