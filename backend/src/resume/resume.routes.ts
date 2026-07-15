import { Router } from "express";
import { authMiddleware } from "../middleware/auth.middleware";
import {
  getResumeController,
  updateResumeController,
  downloadResumeController,
  deleteResumeController,
} from "../resume/resume.controller";

const router = Router();

router.get("/getResume", authMiddleware, getResumeController);
router.put("/updateResume", authMiddleware, updateResumeController);
router.get("/downloadResume", authMiddleware, downloadResumeController);
router.delete("/deleteResume", authMiddleware, deleteResumeController);

export default router;