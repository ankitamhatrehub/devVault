import express from "express";
import { uploadToCloudinary } from "../middleware/upload.middleware.js";
import AuthSchema from "../authentication/auth.model.js";
import { logger } from "../config/logger.js";
const router = express.Router();
export const uploadProfileImageController = async (req, res) => {
    try {
        logger.info("file name  is this => " + req.file);
        if (!req.file) {
            return res
                .status(400)
                .json({ success: false, message: "No file uploaded" });
        }
        logger.info("file name  is this => " + req.file);
        const result = await uploadToCloudinary(req.file.buffer, "devvault_profiles");
        logger.info("result  is this => " + result);
        const userId = req.user?.userId;
        logger.info("userId is this => " + userId);
        const updatedUser = await AuthSchema.findByIdAndUpdate(userId, {
            avatar: {
                url: result.secure_url,
                publicId: result.public_id,
            },
        }, { new: true }).select("-password");
        logger.info("updated user is this => " + updatedUser);
        return res.status(200).json({
            success: true,
            message: "File uploaded successfully!",
            data: updatedUser,
        });
    }
    catch (error) {
        logger.info("error is this => " + error);
        console.error("Cloudinary Upload Error:", error);
        const errorMessage = error instanceof Error ? error.message : "An unexpected error occurred";
        return res.status(500).json({
            success: false,
            message: "Upload failed",
            error: errorMessage,
        });
    }
};
export default router;
//# sourceMappingURL=image.upload.controller.js.map