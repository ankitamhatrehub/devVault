// Import Express framework and the specific types for HTTP Requests and Responses
import express, { Request, Response } from "express";
// Import our upload configurations and the Cloudinary helper from our middleware file
import { upload, uploadToCloudinary } from "../middleware/upload.middleware";
import AuthSchema from "../authentication/auth.model";
import { logger } from "../config/logger";
// Create a new Express Router instance to handle our API endpoints
const router = express.Router();

// Define a POST route at /upload. 'upload.single("file")' intercepts the incoming file first
export const uploadProfileImageController = async (req: Request, res: Response) => {
    try {
         logger.info("file name  is this => " + req.file);
        // IMPORTANT CHECK: If Multer did not find a file in the request, stop immediately
        if (!req.file) {
            // Return a 400 Bad Request status code and tell the frontend what went wrong
            return res
                .status(400)
                .json({ success: false, message: "No file uploaded" });
        }

         logger.info("file name  is this => " + req.file);
        // IMPORTANT STEP: Send the raw file data (buffer) from RAM to a specific folder on Cloudinary
        const result = await uploadToCloudinary(
            req.file.buffer,
            "devvault_profiles",
        );
        logger.info("result  is this => " + result);
        // 2. Update MongoDB using the user's ID (e.g., from your auth middleware)
        const userId = (req as any).user?.userId; // Replace with how you get your logged-in user ID
logger.info("userId is this => " + userId);
        const updatedUser = await AuthSchema.findByIdAndUpdate(
            userId,
            {
                avatar: {
                    url: result.secure_url,
                    publicId: result.public_id,
                },
            },
            { new: true }, // Returns the updated user data from MongoDB
        ).select("-password"); // Hide the password from the response data
        // SUCCESS: Cloudinary finished uploading! Send a 200 OK status back to the frontend
        logger.info("updated user is this => " + updatedUser);
        return res.status(200).json({
            success: true,
            message: "File uploaded successfully!",
            // Send back the secure URL (https) so the frontend can display the image
            data: updatedUser,
        });
    } catch (error) {
        logger.info("error is this => " + error);
        // Log the actual backend error inside your server terminal for debugging
        console.error("Cloudinary Upload Error:", error);

        // TYPE-GUARD: Check if the 'error' object is a standard JavaScript error instance
        const errorMessage =
            error instanceof Error ? error.message : "An unexpected error occurred";

        // FAILURE: Send a 500 Internal Server Error back to the client along with the error message
        return res.status(500).json({
            success: false,
            message: "Upload failed",
            error: errorMessage,
        });
    }
}


// Export the router so we can connect it to our main app server file (like app.ts or server.ts)
export default router;
