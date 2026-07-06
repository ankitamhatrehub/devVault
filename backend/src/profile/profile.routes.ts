

import { Router } from "express";
import { getProfileController, updateProfileController,changePasword } from "./profile.controller";
import { authMiddleware } from "../middleware/auth.middleware";
const router = Router();

router.get("/getProfile", authMiddleware, getProfileController);
router.put("/editProfile", authMiddleware, updateProfileController);
router.put("/change-password", authMiddleware, changePasword);
export default router;