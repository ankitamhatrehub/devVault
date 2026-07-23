// ========== ROUTES CONFIGURATION ==========
// Central routing file that aggregates all API route handlers
// All routes are prefixed with /api from app.ts

import { Router } from "express";
import auth from "./authentication/auth.routes.js";
import profile from "./profile/profile.routes.js";
import tasks from "./tasks/tasks.routes.js";
import notes from "./notes/notes.routes.js";
import projects from "./projects/projects.routes.js";
// import interview from "./interview/interview.routes.js";
import learning from "./learning/learning.routes.js";
import dashboard from "./dashboard/dashboard.route.js";
import resume from "./resume/resume.routes.js";
import aiRoutes from "./ai/ai.routes.js";
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


router.use("/ai", aiRoutes);
// ========== EXPORTS ==========

// Export the router for use in app.ts
export default router;
