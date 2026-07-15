import { Router } from "express";
import {
  createProjectController,
  getAllProjectsController,
  getProjectByIdController,
  updateProjectController,
  deleteProjectController,
} from "./projects.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";

const router = Router();

// All routes protected with authMiddleware to ensure user is authenticated
router.post("/createProject", authMiddleware, createProjectController);
router.get("/getAllProjects", authMiddleware, getAllProjectsController);
router.get("/:id", authMiddleware, getProjectByIdController);
router.put("/:id", authMiddleware, updateProjectController);
router.delete("/:id", authMiddleware, deleteProjectController);

export default router;
