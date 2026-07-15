import { upload, uploadToCloudinary } from "../middleware/upload.middleware";
import ResumeSchema from "../resume/resume.model";
import { logger } from "../config/logger";
export const uploadResumeController = async (req, res) => {
    try {
        if (!req.file) {
            logger.warn("uploadResumeController: No file uploaded");
            return res.status(400).json({
                success: false,
                message: "No file uploaded",
                data: null,
            });
        }
        const userId = req.user?.userId;
        if (!userId) {
            logger.warn("uploadResumeController: userId not found");
            return res.status(401).json({
                success: false,
                message: "Unauthorized - User ID not found",
                data: null,
            });
        }
        logger.info(`uploadResumeController: Uploading resume for user ${userId}`);
        const cloudinaryResult = await uploadToCloudinary(req.file.buffer, "devvault_resumes");
        logger.info(`uploadResumeController: File uploaded to Cloudinary: ${cloudinaryResult.public_id}`);
        const existingResume = await ResumeSchema.findOne({ userId });
        if (existingResume) {
            await ResumeSchema.findByIdAndDelete(existingResume._id);
            logger.info(`uploadResumeController: Deleted old resume for user ${userId}`);
        }
        const newResume = new ResumeSchema({
            userId,
            fileName: req.file.originalname,
            fileUrl: cloudinaryResult.secure_url,
            fileSize: `${(req.file.size / (1024 * 1024)).toFixed(2)} MB`,
            publicId: cloudinaryResult.public_id,
        });
        const savedResume = await newResume.save();
        logger.info(`uploadResumeController: Resume saved successfully for user ${userId}`);
        return res.status(200).json({
            success: true,
            message: "Resume uploaded successfully",
            data: savedResume,
        });
    }
    catch (error) {
        logger.error(`uploadResumeController: Error - ${error instanceof Error ? error.message : String(error)}`);
        return res.status(500).json({
            success: false,
            message: error instanceof Error ? error.message : "Upload failed",
            data: null,
        });
    }
};
export { upload };
//# sourceMappingURL=resume.upload.controller.js.map