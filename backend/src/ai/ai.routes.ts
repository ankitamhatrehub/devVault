import { Router } from "express";
import { sendMessage, getMessage } from "./ai.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";

const router = Router();

router.post("/sendChats", authMiddleware, sendMessage);
router.get("/getChats", authMiddleware, getMessage);
export default router;
