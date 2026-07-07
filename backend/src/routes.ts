// ========== ROUTES CONFIGURATION ==========
// Central routing file that aggregates all API route handlers
// All routes are prefixed with /api from app.ts

import { Router } from "express";
import auth from "../src/authentication/auth.routes";
import profile from "../src/profile/profile.routes";
import tasks from "../src/tasks/tasks.routes";
import notes from "../src/notes/notes.routes";
import projects from "../src/projects/projects.routes";
// import interview from "../src/interview/interview.routes";
import learning from "../src/learning/learning.routes";
// Create a new Express router instance for handling API routes
const router = Router();

router.use("/auth", auth);
// router.use("/interview", interview);
router.use("/learning", learning);
router.use("/tasks", tasks);
router.use("/notes", notes);
router.use("/projects", projects);
router.use("/profile", profile);

// ========== EXPORTS ==========

// Export the router for use in app.ts
export default router;
