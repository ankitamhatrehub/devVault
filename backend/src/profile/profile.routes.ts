import { Router } from "express";
import { upload } from "../middleware/upload.middleware.js";
import {
  getProfileController,
  updateProfileController,
  changePasword,
} from "./profile.controller.js";
import { uploadProfileImageController } from "../imageUpload/image.upload.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";
const router = Router();

router.get("/getProfile", authMiddleware, getProfileController);
router.put("/editProfile", authMiddleware, updateProfileController);
router.put("/change-password", authMiddleware, changePasword);
router.post(
  "/upload",
  authMiddleware,
  upload.single("file"),
  uploadProfileImageController,
);
export default router;
