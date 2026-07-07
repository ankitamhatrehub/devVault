import { Router } from "express";
import { getDashboardController } from "./dashboard.controller";
import { authMiddleware } from "../middleware/auth.middleware";

const router = Router();

// Dashboard endpoint protected with authMiddleware
router.get("/", authMiddleware, getDashboardController);

export default router;
