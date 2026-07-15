import { Router } from "express";
import { createTaskController, getAllTasksController, getTaskByIdController, updateTaskController, deleteTaskController, } from "./tasks.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";
const router = Router();
router.post("/createTask", authMiddleware, createTaskController);
router.get("/getAllTasks", authMiddleware, getAllTasksController);
router.get("/:id", authMiddleware, getTaskByIdController);
router.put("/:id", authMiddleware, updateTaskController);
router.delete("/:id", authMiddleware, deleteTaskController);
export default router;
//# sourceMappingURL=tasks.routes.js.map