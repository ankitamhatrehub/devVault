import { Router } from "express";
import { getDashboardController } from "./dashboard.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";

const router = Router();

// Dashboard endpoint protected with authMiddleware
router.get("/", authMiddleware, getDashboardController);

export default router;
