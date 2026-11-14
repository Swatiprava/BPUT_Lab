import axios from 'axios'

const API_URL = import.meta.env.VITE_API_URL || ''

const api = axios.create({
  baseURL: `${API_URL}/api`,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 15000,
})

// Add auth token to requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('access_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Auth API
export const authAPI = {
  login: (email, password) => api.post('/auth/login', { email, password }),
  getMe: () => api.get('/auth/me', {
    headers: { authorization: `Bearer ${localStorage.getItem('access_token')}` }
  }),
}

// Subjects API
export const subjectsAPI = {
  getAll: (semester) => api.get('/subjects', { params: { semester } }),
  getById: (id) => api.get(`/subjects/${id}`),
}

// Experiments API
export const experimentsAPI = {
  getAll: (subjectId) => api.get('/experiments', { params: { subject_id: subjectId } }),
  getById: (id) => api.get(`/experiments/${id}`),
}

// Students API (Real DB records)
export const studentsAPI = {
  getAll: (semester) => api.get('/students', { params: { semester } }),
}

// Submissions API
export const submissionsAPI = {
  getAll: (studentId, experimentId) =>
    api.get('/submissions', { params: { student_id: studentId, experiment_id: experimentId } }),
  create: (data) => api.post('/submissions', data),
}

// Code Execution API
export const codeAPI = {
  run: (sourceCode, language, stdin = '') =>
    api.post('/code/run', { source_code: sourceCode, language, stdin }),
}

export default api
