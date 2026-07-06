// ========== ROUTES CONFIGURATION ==========
// Central routing file that aggregates all API route handlers
// All routes are prefixed with /api from app.ts

import { Router } from "express";
import auth from "../src/authentication/auth.routes";
import profile from "../src/profile/profile.routes";
// import tasks from "../src/tasks/tasks.routes";
// import notes from "../src/notes/notes.routes";
// import projects from "../src/projects/projects.routes";
// import interview from "../src/interview/interview.routes";
// import learning from "../src/learning/learning.routes";
// Create a new Express router instance for handling API routes
const router = Router();

// ========== ROUTE IMPORTS ==========
// Import route modules from respective feature folders
// These will be uncommented as each module is created

// import authRoutes from "./authentication/auth.routes";
// import projectRoutes from "./projects/project.routes";
// import taskRoutes from "./tasks/task.routes";
// import noteRoutes from "./notes/note.routes";
// import learningRoutes from "./learning/learning.routes";
// import interviewRoutes from "./interview/interview.routes";
// import userRoutes from "./users/user.routes";

// ========== API VERSION 1 ROUTES ==========

// Prefix: /api/v1 (add /v1 to all routes below for versioning)
const apiV1 = Router();

// Auth Routes: POST /api/v1/auth/register, /api/v1/auth/login, etc.
// apiV1.use("/auth", authRoutes);

// Project Routes: GET /api/v1/projects, POST /api/v1/projects, etc.
// apiV1.use("/projects", projectRoutes);

// Task Routes: GET /api/v1/tasks, POST /api/v1/tasks, etc.
// apiV1.use("/tasks", taskRoutes);

// Note Routes: GET /api/v1/notes, POST /api/v1/notes, etc.
// apiV1.use("/notes", noteRoutes);

// Learning Routes: GET /api/v1/learning/resources, /api/v1/learning/roadmap, etc.
// apiV1.use("/learning", learningRoutes);

// Interview Routes: GET /api/v1/interview/questions, etc.
// apiV1.use("/interview", interviewRoutes);

// User Routes: GET /api/v1/users/profile, PUT /api/v1/users/profile, etc.
// apiV1.use("/users", userRoutes);

// Mount all v1 routes under /v1 prefix
router.use("/auth", auth);
// router.use("/interview", interview);
// router.use("/learning", learning);
// router.use("/tasks", tasks);
// router.use("/notes", notes);
// router.use("/projects", projects);
router.use("/profile", profile);

// ========== EXPORTS ==========

// Export the router for use in app.ts
export default router;
