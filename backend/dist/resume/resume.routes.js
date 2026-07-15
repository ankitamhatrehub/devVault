import { Router } from "express";
import { authMiddleware } from "../middleware/auth.middleware.js";
import { getResumeController, updateResumeController, downloadResumeController, deleteResumeController, } from "../resume/resume.controller.js";
import { uploadResumeController, upload } from "../resume/resume.upload.controller.js";
const router = Router();
router.get("/getResume", authMiddleware, getResumeController);
router.put("/updateResume", authMiddleware, updateResumeController);
router.get("/downloadResume", authMiddleware, downloadResumeController);
router.delete("/deleteResume", authMiddleware, deleteResumeController);
router.post("/uploadResume", authMiddleware, upload.single("file"), uploadResumeController);
export default router;
//# sourceMappingURL=resume.routes.js.map