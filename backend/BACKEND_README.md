# DevVault Backend - API Specifications & Integration Guide

## 🎯 Overview

This document outlines all the APIs needed to support the DevVault Flutter frontend application. It includes detailed endpoint specifications, required data structures, request/response formats, and integration guidelines.

---

## 🏗️ Project Structure

```
backend/
├── src/
│   ├── authentication/
│   │   ├── auth.routes.ts         # Auth endpoints
│   │   ├── auth.model.ts          # Auth schema
│   │   ├── auth.service.ts        # Auth logic
│   │   └── auth.controller.ts     # Route handlers
│   ├── projects/
│   │   ├── project.routes.ts      # Project CRUD endpoints
│   │   ├── project.model.ts       # Project schema
│   │   ├── project.service.ts     # Project logic
│   │   └── project.controller.ts  # Route handlers
│   ├── tasks/
│   │   ├── task.routes.ts         # Task CRUD endpoints
│   │   ├── task.model.ts          # Task schema
│   │   ├── task.service.ts        # Task logic
│   │   └── task.controller.ts     # Route handlers
│   ├── notes/
│   │   ├── note.routes.ts         # Note CRUD endpoints
│   │   ├── note.model.ts          # Note schema
│   │   ├── note.service.ts        # Note logic
│   │   └── note.controller.ts     # Route handlers
│   ├── learning/
│   │   ├── learning.routes.ts     # Learning endpoints
│   │   ├── learning.model.ts      # Learning schema
│   │   └── learning.controller.ts # Route handlers
│   ├── interview/
│   │   ├── interview.routes.ts    # Interview endpoints
│   │   ├── interview.model.ts     # Question schema
│   │   └── interview.controller.ts# Route handlers
│   ├── users/
│   │   ├── user.routes.ts         # User profile endpoints
│   │   ├── user.model.ts          # User profile schema
│   │   └── user.controller.ts     # Route handlers
│   ├── middleware/
│   │   ├── auth.middleware.ts     # JWT verification
│   │   └── error.middleware.ts    # Error handling
│   ├── config/
│   │   └── database.ts            # MongoDB configuration
│   ├── app.ts                     # Express app setup
│   └── index.ts                   # Server entry point
├── package.json
├── tsconfig.json
└── .env.example
```

---

## 🔐 Authentication APIs

### 1. **User Registration**
**Endpoint:** `POST /api/v1/auth/register`

**Request Body:**
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "password": "securePassword123",
  "confirmPassword": "securePassword123"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Account created successfully",
  "data": {
    "userId": "uuid-string",
    "email": "user@example.com",
    "name": "John Doe",
    "createdAt": "2026-07-03T10:30:00Z"
  }
}
```

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Email already registered",
  "errors": {
    "email": "Email already exists"
  }
}
```

---

### 2. **User Login**
**Endpoint:** `POST /api/v1/auth/login`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "userId": "uuid-string",
    "email": "user@example.com",
    "name": "John Doe",
    "accessToken": "jwt-token-here",
    "refreshToken": "refresh-token-here",
    "expiresIn": 3600
  }
}
```

**Error Response (401 Unauthorized):**
```json
{
  "success": false,
  "message": "Invalid email or password"
}
```

---

### 3. **Forgot Password**
**Endpoint:** `POST /api/v1/auth/forgot-password`

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "OTP sent to your email",
  "data": {
    "email": "user@example.com",
    "otpExpiry": 600
  }
}
```

---

### 4. **Verify OTP**
**Endpoint:** `POST /api/v1/auth/verify-otp`

**Request Body:**
```json
{
  "email": "user@example.com",
  "otp": "123456"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "OTP verified",
  "data": {
    "resetToken": "token-for-password-reset",
    "expiresIn": 600
  }
}
```

---

### 5. **Reset Password**
**Endpoint:** `POST /api/v1/auth/reset-password`

**Request Body:**
```json
{
  "resetToken": "token-from-verify-otp",
  "newPassword": "newPassword123",
  "confirmPassword": "newPassword123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

---

### 6. **Change Password (Authenticated)**
**Endpoint:** `POST /api/v1/auth/change-password`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "currentPassword": "oldPassword123",
  "newPassword": "newPassword123",
  "confirmPassword": "newPassword123"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

---

### 7. **Refresh Token**
**Endpoint:** `POST /api/v1/auth/refresh-token`

**Request Body:**
```json
{
  "refreshToken": "refresh-token-here"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "accessToken": "new-jwt-token",
    "refreshToken": "new-refresh-token",
    "expiresIn": 3600
  }
}
```

---

## 📋 Projects APIs

### 1. **Get All Projects (Authenticated)**
**Endpoint:** `GET /api/v1/projects`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
```
?page=1&limit=10&search=DevVault&status=In Progress&sort=deadline
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "projects": [
      {
        "id": "project-uuid-1",
        "userId": "user-uuid",
        "name": "DevVault",
        "summary": "Developer career tracking app",
        "status": "In Progress",
        "progress": 0.82,
        "stack": "Flutter, Dart, GoRouter",
        "deadline": "2026-07-18",
        "team": "3 members",
        "tags": ["Flutter", "Mobile"],
        "notes": "On track for release",
        "createdAt": "2026-06-01T10:30:00Z",
        "updatedAt": "2026-07-03T15:45:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 5,
      "totalPages": 1
    }
  }
}
```

---

### 2. **Get Project Detail (Authenticated)**
**Endpoint:** `GET /api/v1/projects/{projectId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "project-uuid-1",
    "userId": "user-uuid",
    "name": "DevVault",
    "summary": "Developer career tracking app",
    "status": "In Progress",
    "progress": 0.82,
    "stack": "Flutter, Dart, GoRouter",
    "deadline": "2026-07-18",
    "team": "3 members",
    "tags": ["Flutter", "Mobile"],
    "notes": "On track for release",
    "timeline": {
      "startDate": "2026-06-01",
      "milestones": [
        {
          "name": "MVP Release",
          "date": "2026-07-01",
          "status": "Completed"
        }
      ]
    },
    "attachments": [],
    "createdAt": "2026-06-01T10:30:00Z",
    "updatedAt": "2026-07-03T15:45:00Z"
  }
}
```

---

### 3. **Create Project (Authenticated)**
**Endpoint:** `POST /api/v1/projects`

**Headers:**
```
Authorization: Bearer {accessToken}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "New Project",
  "summary": "Project description",
  "status": "Planning",
  "progress": 0,
  "stack": "Flutter, Firebase",
  "deadline": "2026-08-15",
  "team": "2 members",
  "tags": ["Mobile", "Firebase"],
  "notes": "Project notes"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Project created successfully",
  "data": {
    "id": "project-uuid-new",
    "userId": "user-uuid",
    "name": "New Project",
    "summary": "Project description",
    "status": "Planning",
    "progress": 0,
    "stack": "Flutter, Firebase",
    "deadline": "2026-08-15",
    "team": "2 members",
    "tags": ["Mobile", "Firebase"],
    "notes": "Project notes",
    "createdAt": "2026-07-03T20:15:00Z",
    "updatedAt": "2026-07-03T20:15:00Z"
  }
}
```

---

### 4. **Update Project (Authenticated)**
**Endpoint:** `PUT /api/v1/projects/{projectId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "name": "Updated Project Name",
  "summary": "Updated description",
  "status": "In Progress",
  "progress": 0.5,
  "stack": "Flutter, Firebase, Redux",
  "deadline": "2026-08-20",
  "team": "3 members",
  "tags": ["Mobile", "Firebase", "State Management"],
  "notes": "Updated notes"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Project updated successfully",
  "data": {
    "id": "project-uuid-1",
    "userId": "user-uuid",
    "name": "Updated Project Name",
    "summary": "Updated description",
    "status": "In Progress",
    "progress": 0.5,
    "stack": "Flutter, Firebase, Redux",
    "deadline": "2026-08-20",
    "team": "3 members",
    "tags": ["Mobile", "Firebase", "State Management"],
    "notes": "Updated notes",
    "updatedAt": "2026-07-03T20:20:00Z"
  }
}
```

---

### 5. **Delete Project (Authenticated)**
**Endpoint:** `DELETE /api/v1/projects/{projectId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Project deleted successfully"
}
```

---

## ✅ Tasks APIs

### 1. **Get All Tasks (Authenticated)**
**Endpoint:** `GET /api/v1/tasks`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
```
?page=1&limit=20&priority=High&status=In Progress&search=System&sort=-dueDate
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "tasks": [
      {
        "id": "task-uuid-1",
        "userId": "user-uuid",
        "title": "System design revision",
        "description": "Review scalability patterns and design a notification service",
        "priority": "High",
        "status": "In Progress",
        "progress": 0.6,
        "dueDate": "2026-07-10",
        "category": "Learning",
        "createdAt": "2026-06-20T10:00:00Z",
        "updatedAt": "2026-07-03T14:30:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 12,
      "totalPages": 1
    }
  }
}
```

---

### 2. **Get Task Detail (Authenticated)**
**Endpoint:** `GET /api/v1/tasks/{taskId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "task-uuid-1",
    "userId": "user-uuid",
    "title": "System design revision",
    "description": "Review scalability patterns and design a notification service",
    "priority": "High",
    "status": "In Progress",
    "progress": 0.6,
    "dueDate": "2026-07-10",
    "category": "Learning",
    "subtasks": [
      {
        "id": "subtask-1",
        "title": "Review scaling patterns",
        "completed": true
      }
    ],
    "createdAt": "2026-06-20T10:00:00Z",
    "updatedAt": "2026-07-03T14:30:00Z"
  }
}
```

---

### 3. **Create Task (Authenticated)**
**Endpoint:** `POST /api/v1/tasks`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "title": "New Task",
  "description": "Task description",
  "priority": "Medium",
  "status": "Pending",
  "progress": 0,
  "dueDate": "2026-07-15",
  "category": "Learning"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Task created successfully",
  "data": {
    "id": "task-uuid-new",
    "userId": "user-uuid",
    "title": "New Task",
    "description": "Task description",
    "priority": "Medium",
    "status": "Pending",
    "progress": 0,
    "dueDate": "2026-07-15",
    "category": "Learning",
    "createdAt": "2026-07-03T20:30:00Z",
    "updatedAt": "2026-07-03T20:30:00Z"
  }
}
```

---

### 4. **Update Task (Authenticated)**
**Endpoint:** `PUT /api/v1/tasks/{taskId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "title": "Updated Task",
  "description": "Updated description",
  "priority": "High",
  "status": "In Progress",
  "progress": 0.75,
  "dueDate": "2026-07-12",
  "category": "Learning"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Task updated successfully",
  "data": {
    "id": "task-uuid-1",
    "userId": "user-uuid",
    "title": "Updated Task",
    "description": "Updated description",
    "priority": "High",
    "status": "In Progress",
    "progress": 0.75,
    "dueDate": "2026-07-12",
    "category": "Learning",
    "updatedAt": "2026-07-03T20:35:00Z"
  }
}
```

---

### 5. **Delete Task (Authenticated)**
**Endpoint:** `DELETE /api/v1/tasks/{taskId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Task deleted successfully"
}
```

---

## 📝 Notes APIs

### 1. **Get All Notes (Authenticated)**
**Endpoint:** `GET /api/v1/notes`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
```
?page=1&limit=20&category=Career&search=interview&pinned=true&sort=-updatedAt
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "notes": [
      {
        "id": "note-uuid-1",
        "userId": "user-uuid",
        "title": "Interview reflection",
        "body": "Focus on communication and calm pacing.",
        "category": "Career",
        "pinned": true,
        "updatedAt": "2026-07-03T10:30:00Z",
        "createdAt": "2026-06-15T09:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 8,
      "totalPages": 1
    }
  }
}
```

---

### 2. **Get Note Detail (Authenticated)**
**Endpoint:** `GET /api/v1/notes/{noteId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "note-uuid-1",
    "userId": "user-uuid",
    "title": "Interview reflection",
    "body": "Focus on communication and calm pacing. Bring a short story that proves impact.",
    "category": "Career",
    "pinned": true,
    "decisions": [],
    "updatedAt": "2026-07-03T10:30:00Z",
    "createdAt": "2026-06-15T09:00:00Z"
  }
}
```

---

### 3. **Create Note (Authenticated)**
**Endpoint:** `POST /api/v1/notes`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "title": "New Note",
  "body": "Note content here (max 280 chars)",
  "category": "Learning",
  "pinned": false
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Note created successfully",
  "data": {
    "id": "note-uuid-new",
    "userId": "user-uuid",
    "title": "New Note",
    "body": "Note content here (max 280 chars)",
    "category": "Learning",
    "pinned": false,
    "createdAt": "2026-07-03T21:00:00Z",
    "updatedAt": "2026-07-03T21:00:00Z"
  }
}
```

---

### 4. **Update Note (Authenticated)**
**Endpoint:** `PUT /api/v1/notes/{noteId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "title": "Updated Note",
  "body": "Updated content",
  "category": "Planning",
  "pinned": true
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Note updated successfully",
  "data": {
    "id": "note-uuid-1",
    "userId": "user-uuid",
    "title": "Updated Note",
    "body": "Updated content",
    "category": "Planning",
    "pinned": true,
    "updatedAt": "2026-07-03T21:05:00Z"
  }
}
```

---

### 5. **Delete Note (Authenticated)**
**Endpoint:** `DELETE /api/v1/notes/{noteId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Note deleted successfully"
}
```

---

## 📚 Learning APIs

### 1. **Get Learning Resources (Authenticated)**
**Endpoint:** `GET /api/v1/learning/resources`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
```
?category=Flutter&difficulty=Intermediate&sort=popularity
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "resources": [
      {
        "id": "resource-uuid-1",
        "title": "Flutter Performance Optimization",
        "category": "Flutter",
        "difficulty": "Intermediate",
        "description": "Learn how to optimize Flutter apps",
        "url": "https://example.com/flutter-perf",
        "type": "article",
        "duration": "45 minutes",
        "rating": 4.8,
        "completed": false
      }
    ]
  }
}
```

---

### 2. **Get Learning Roadmap (Authenticated)**
**Endpoint:** `GET /api/v1/learning/roadmap`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "roadmap-uuid-1",
    "userId": "user-uuid",
    "title": "Flutter Development Mastery",
    "description": "Complete guide to becoming a Flutter expert",
    "stages": [
      {
        "id": "stage-1",
        "title": "Fundamentals",
        "description": "Basic Flutter concepts",
        "progress": 1.0,
        "resources": [
          {
            "id": "resource-uuid-1",
            "title": "Flutter Basics",
            "completed": true
          }
        ]
      }
    ],
    "overallProgress": 0.45
  }
}
```

---

## 🎯 Interview APIs

### 1. **Get Interview Questions (Authenticated)**
**Endpoint:** `GET /api/v1/interview/questions`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
```
?category=System Design&difficulty=Hard&limit=10&sort=-rating
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "questions": [
      {
        "id": "question-uuid-1",
        "title": "Design a URL Shortener",
        "category": "System Design",
        "difficulty": "Hard",
        "description": "How would you design a URL shortening service?",
        "topics": ["Scalability", "Databases", "API Design"],
        "rating": 4.7,
        "attempts": 2,
        "lastAttempted": "2026-07-01T15:30:00Z"
      }
    ],
    "pagination": {
      "total": 45,
      "page": 1,
      "limit": 10
    }
  }
}
```

---

### 2. **Get Question Details (Authenticated)**
**Endpoint:** `GET /api/v1/interview/questions/{questionId}`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "question-uuid-1",
    "title": "Design a URL Shortener",
    "category": "System Design",
    "difficulty": "Hard",
    "description": "How would you design a URL shortening service?",
    "topics": ["Scalability", "Databases", "API Design"],
    "hints": [
      "Think about hash functions",
      "Consider database schema"
    ],
    "solutions": [
      {
        "id": "solution-1",
        "type": "video",
        "url": "https://example.com/solution-video",
        "duration": "12 minutes"
      }
    ],
    "rating": 4.7,
    "userRating": 5,
    "attempts": 2,
    "notes": "User's practice notes here"
  }
}
```

---

## 👤 User Profile APIs

### 1. **Get User Profile (Authenticated)**
**Endpoint:** `GET /api/v1/users/profile`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "userId": "user-uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "profileImage": "https://example.com/profile.jpg",
    "bio": "Software developer interested in Flutter and system design",
    "joinedDate": "2026-06-01T10:00:00Z",
    "stats": {
      "projectsCount": 5,
      "tasksCount": 12,
      "notesCount": 8,
      "learningStreak": 15
    }
  }
}
```

---

### 2. **Update User Profile (Authenticated)**
**Endpoint:** `PUT /api/v1/users/profile`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "name": "John Doe Updated",
  "bio": "Updated bio",
  "profileImage": "https://example.com/new-profile.jpg"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "userId": "user-uuid",
    "email": "user@example.com",
    "name": "John Doe Updated",
    "bio": "Updated bio",
    "profileImage": "https://example.com/new-profile.jpg",
    "updatedAt": "2026-07-03T21:30:00Z"
  }
}
```

---

## 🗄️ Database Schema

### User Schema
```typescript
interface User {
  _id: ObjectId;
  email: string;
  name: string;
  passwordHash: string;
  profileImage?: string;
  bio?: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt?: Date;
}
```

### Projects Schema
```typescript
interface Project {
  _id: ObjectId;
  userId: ObjectId;
  name: string;
  summary: string;
  status: string;
  progress: number;
  stack: string;
  deadline: Date;
  team: string;
  tags: string[];
  notes: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt?: Date;
}
```

### Tasks Schema
```typescript
interface Task {
  _id: ObjectId;
  userId: ObjectId;
  title: string;
  description: string;
  priority: string;
  status: string;
  progress: number;
  dueDate: Date;
  category: string;
  subtasks?: Array<{
    id: string;
    title: string;
    completed: boolean;
  }>;
  createdAt: Date;
  updatedAt: Date;
  deletedAt?: Date;
}
```

### Notes Schema
```typescript
interface Note {
  _id: ObjectId;
  userId: ObjectId;
  title: string;
  body: string;
  category: string;
  pinned: boolean;
  decisions?: any[];
  createdAt: Date;
  updatedAt: Date;
  deletedAt?: Date;
}
```

### Learning Resources Schema
```typescript
interface LearningResource {
  _id: ObjectId;
  userId: ObjectId;
  title: string;
  category: string;
  difficulty: string;
  description: string;
  url: string;
  type: string;
  duration: string;
  rating: number;
  completed: boolean;
  createdAt: Date;
  updatedAt: Date;
}
```

### Interview Questions Schema
```typescript
interface InterviewQuestion {
  _id: ObjectId;
  title: string;
  category: string;
  difficulty: string;
  description: string;
  topics: string[];
  rating: number;
  hints?: string[];
  solutions?: Array<{
    id: string;
    type: string;
    url: string;
    duration: string;
  }>;
  createdAt: Date;
  updatedAt: Date;
}
```

### User Interview Progress Schema
```typescript
interface UserInterviewProgress {
  _id: ObjectId;
  userId: ObjectId;
  questionId: ObjectId;
  attempts: number;
  userRating?: number;
  notes?: string;
  lastAttempted?: Date;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 🔌 Integration Guidelines

### 1. **Authentication Flow**
1. User registers → `POST /api/v1/auth/register`
2. User logs in → `POST /api/v1/auth/login`
3. Store `accessToken` and `refreshToken` securely (Flutter Secure Storage)
4. Add `Authorization: Bearer {accessToken}` header to all authenticated requests
5. On token expiry → `POST /api/v1/auth/refresh-token`

### 2. **CRUD Operations**
- **Create:** `POST /api/v1/[resource]`
- **Read:** `GET /api/v1/[resource]` or `GET /api/v1/[resource]/{id}`
- **Update:** `PUT /api/v1/[resource]/{id}`
- **Delete:** `DELETE /api/v1/[resource]/{id}`

### 3. **Error Handling**
All endpoints should return consistent error responses:

```json
{
  "success": false,
  "message": "Error message here",
  "errors": {
    "field": "Field-specific error"
  }
}
```

### 4. **Status Codes**
- `200` - Success (GET, PUT, DELETE)
- `201` - Created (POST)
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `409` - Conflict
- `500` - Server Error

### 5. **Pagination**
For list endpoints, implement pagination:
```json
"pagination": {
  "page": 1,
  "limit": 20,
  "total": 100,
  "totalPages": 5
}
```

### 6. **Filtering & Sorting**
- **Filters:** `?status=In Progress&priority=High`
- **Search:** `?search=keyword`
- **Sort:** `?sort=deadline` or `?sort=-createdAt` (- for descending)

---

## 🛡️ Security Requirements

1. **JWT Tokens**
   - Access token expiry: 1 hour
   - Refresh token expiry: 30 days
   - Use secure signing algorithm (HS256 minimum, RS256 recommended)

2. **Password Security**
   - Minimum 8 characters
   - Hash using bcrypt or scrypt
   - Salt rounds: 10+

3. **Rate Limiting**
   - Auth endpoints: 5 requests per minute per IP
   - API endpoints: 100 requests per minute per user

4. **HTTPS**
   - All API endpoints must use HTTPS
   - Enable HSTS headers

5. **CORS**
   - Configure appropriate CORS headers
   - Allow Flutter app domain

---

## 📦 Dependencies & Tech Stack

### Core Stack
- **Runtime:** Node.js (v18+)
- **Language:** TypeScript
- **Framework:** Express.js
- **Database:** MongoDB with Mongoose ODM
- **Authentication:** JWT with bcrypt
- **Caching:** Redis (optional, for performance)

### npm Dependencies
```json
{
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.x.x",
    "jsonwebtoken": "^9.x.x",
    "bcryptjs": "^2.4.3",
    "dotenv": "^16.x.x",
    "cors": "^2.8.5",
    "express-validator": "^7.x.x",
    "helmet": "^7.x.x",
    "express-rate-limit": "^6.x.x"
  },
  "devDependencies": {
    "typescript": "^5.x.x",
    "@types/node": "^20.x.x",
    "@types/express": "^4.17.x",
    "ts-node": "^10.x.x",
    "tsx": "^3.x.x",
    "nodemon": "^3.x.x"
  }
}
```

---

## 🚀 Deployment Checklist

- [ ] Environment variables configured (.env)
- [ ] Database migrations applied
- [ ] CORS enabled for Flutter app
- [ ] JWT tokens configured
- [ ] Rate limiting enabled
- [ ] Error logging setup
- [ ] Health check endpoint created
- [ ] API documentation (Swagger/OpenAPI)
- [ ] Backup strategy implemented
- [ ] Monitoring & alerts configured

---

## 📞 API Support

### Health Check
**Endpoint:** `GET /api/v1/health`

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2026-07-03T22:00:00Z",
  "version": "1.0.0"
}
```

### API Documentation
- Swagger UI: `GET /api/docs` (via swagger-ui-express)
- API Docs: `GET /api/v1/docs`

---

## 🔄 Versioning

Current API Version: `v1`

For future breaking changes, use:
- `/api/v2/...` for new major versions
- Maintain backward compatibility for at least 1 version

---

**Last Updated:** 2026-07-03  
**Status:** ✅ Ready for Backend Implementation