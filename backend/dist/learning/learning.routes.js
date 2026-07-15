import { Router } from "express";
import { createLearningController, getAllLearningsController, getLearningByIdController, updateLearningController, deleteLearningController, } from "./learning.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";
const router = Router();
router.post("/createLearning", authMiddleware, createLearningController);
router.get("/getAllLearnings", authMiddleware, getAllLearningsController);
router.get("/:id", authMiddleware, getLearningByIdController);
router.put("/:id", authMiddleware, updateLearningController);
router.delete("/:id", authMiddleware, deleteLearningController);
export default router;
//# sourceMappingURL=learning.routes.js.map