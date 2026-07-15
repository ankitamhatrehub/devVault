import { Router } from "express";
import { getDashboardController } from "./dashboard.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";
const router = Router();
router.get("/", authMiddleware, getDashboardController);
export default router;
//# sourceMappingURL=dashboard.route.js.map