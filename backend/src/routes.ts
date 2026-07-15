// ========== ROUTES CONFIGURATION ==========
// Central routing file that aggregates all API route handlers
// All routes are prefixed with /api from app.ts

import { Router } from "express";
import auth from "../src/authentication/auth.routes.js";
import profile from "../src/profile/profile.routes.js";
import tasks from "../src/tasks/tasks.routes.js";
import notes from "../src/notes/notes.routes.js";
import projects from "../src/projects/projects.routes.js";
// import interview from "../src/interview/interview.routes.js";
import learning from "../src/learning/learning.routes.js";
import dashboard from "../src/dashboard/dashboard.route.js";
import resume from "../src/resume/resume.routes.js";
// Create a new Express router instance for handling API routes
const router = Router();

router.use("/auth", auth);
// router.use("/interview", interview);
router.use("/learning", learning);
router.use("/tasks", tasks);
router.use("/notes", notes);
router.use("/projects", projects);
router.use("/profile", profile);
router.use("/dashboard", dashboard);
router.use("/resume", resume);
// ========== EXPORTS ==========

// Export the router for use in app.ts
export default router;
