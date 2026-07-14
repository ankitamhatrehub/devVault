import { Router } from "express";
import { upload } from "../middleware/upload.middleware";
import {
  getProfileController,
  updateProfileController,
  changePasword,
} from "./profile.controller";
import { uploadProfileImageController } from "../imageUpload/image.upload.controller";
import { authMiddleware } from "../middleware/auth.middleware";
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
