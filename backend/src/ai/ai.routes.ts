import { Router } from "express";
import { sendMessage, getMessage } from "./ai.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";

const router = Router();

//chats
router.post("/sendChats", authMiddleware, sendMessage);
router.get("/getChats", authMiddleware, getMessage);

//resume
// router.post("/aiResumeReview", authMiddleware, aiReviewResume);
export default router;
