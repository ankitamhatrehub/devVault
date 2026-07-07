import { Router } from "express";
import {
  createLearningController,
  getAllLearningsController,
  getLearningByIdController,
  updateLearningController,
  deleteLearningController,
} from "./learning.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();

// All routes protected with authMiddleware to ensure user is authenticated
router.post("/createLearning", authMiddleware, createLearningController);
router.get("/getAllLearnings", authMiddleware, getAllLearningsController);
router.get("/:id", authMiddleware, getLearningByIdController);
router.put("/:id", authMiddleware, updateLearningController);
router.delete("/:id", authMiddleware, deleteLearningController);

export default router;
