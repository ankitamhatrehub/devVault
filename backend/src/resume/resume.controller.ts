import { Request, Response } from "express";
import { logger } from "../config/logger.js";
import {
  getResumeService,
  updateResumeService,
  deleteResumeService,
  downloadResumeService,
} from "./resume.service.js";

//get resume controller
export const getResumeController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.userId;

    if (!userId) {
      logger.warn("getResumeController: userId not found in request");
      return res.status(401).json({
        success: false,
        message: "Unauthorized - User ID not found",
        data: null,
      });
    }

    logger.info(`getResumeController: User ${userId} requesting resume`);

    const resume = await getResumeService(userId);

    logger.info(`getResumeController: Resume fetched successfully for user ${userId}`);
    return res.status(200).json({
      success: true,
      message: "Resume fetched successfully",
      data: resume,
    });
  } catch (error) {
    logger.error(
      `getResumeController: Exception occurred - ${error instanceof Error ? error.message : String(error)}`
    );
    return res.status(500).json({
      success: false,
      message: error instanceof Error ? error.message : "Failed to fetch resume",
      data: null,
    });
  }
};

// update resume controller
export const updateResumeController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.userId;

    if (!userId) {
      logger.warn("updateResumeController: userId not found in request");
      return res.status(401).json({
        success: false,
        message: "Unauthorized - User ID not found",
        data: null,
      });
    }

    const { fileName, fileUrl, fileSize, publicId } = req.body;

    // Validate required fields
    if (!fileName || !fileUrl || !fileSize || !publicId) {
      logger.warn(
        `updateResumeController: Missing required fields for user ${userId}`,
      );
      return res.status(400).json({
        success: false,
        message:
          "Missing required fields - fileName, fileUrl, fileSize, publicId",
        data: null,
      });
    }

    logger.info(
      `updateResumeController: Attempting to update resume for user ${userId}`,
    );

    const { success, data, error } = await updateResumeService(userId, {
      fileName,
      fileUrl,
      fileSize,
      publicId,
    });

    if (!success) {
      logger.error(
        `updateResumeController: Failed to update resume for user ${userId} - ${error}`,
      );
      return res.status(400).json({
        success: false,
        message: error || "Failed to update resume",
        data: null,
      });
    }

    logger.info(
      `updateResumeController: Resume updated successfully for user ${userId}`,
    );
    return res.status(200).json({
      success: true,
      message: "Resume updated successfully",
      data: data,
    });
  } catch (error) {
    logger.error(
      `updateResumeController: Exception occurred - ${error instanceof Error ? error.message : String(error)}`,
    );
    return res.status(500).json({
      success: false,
      message: "Internal server error while updating resume",
      data: null,
    });
  }
};

// delete resume controller
export const deleteResumeController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.userId;

    if (!userId) {
      logger.warn("deleteResumeController: userId not found in request");
      return res.status(401).json({
        success: false,
        message: "Unauthorized - User ID not found",
        data: null,
      });
    }

    logger.info(
      `deleteResumeController: Attempting to delete resume for user ${userId}`,
    );

    const { success, error } = await deleteResumeService(userId);

    if (!success) {
      logger.error(
        `deleteResumeController: Failed to delete resume for user ${userId} - ${error}`,
      );
      return res.status(400).json({
        success: false,
        message: error || "Failed to delete resume",
        data: null,
      });
    }

    logger.info(
      `deleteResumeController: Resume deleted successfully for user ${userId}`,
    );
    return res.status(200).json({
      success: true,
      message: "Resume deleted successfully",
      data: null,
    });
  } catch (error) {
    logger.error(
      `deleteResumeController: Exception occurred - ${error instanceof Error ? error.message : String(error)}`,
    );
    return res.status(500).json({
      success: false,
      message: "Internal server error while deleting resume",
      data: null,
    });
  }
};

// download resume controller - returns file bytes, not just URL
export const downloadResumeController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user?.userId;

    if (!userId) {
      logger.warn("downloadResumeController: userId not found in request");
      return res.status(401).json({
        success: false,
        message: "Unauthorized - User ID not found",
        data: null,
      });
    }

    logger.info(
      `downloadResumeController: Attempting to download resume for user ${userId}`,
    );

    const { success, data, error } = await downloadResumeService(userId);

    if (!success || !data) {
      logger.error(
        `downloadResumeController: Failed to retrieve resume for user ${userId} - ${error}`,
      );
      return res.status(404).json({
        success: false,
        message: error || "Resume not found",
        data: null,
      });
    }

    // Fetch the actual file from Cloudinary URL
    let fileUrl = data.fileUrl;
    logger.info(`downloadResumeController: [1/3] Fetching file from URL: ${fileUrl}`);

    // Add download parameter to Cloudinary URL if not already present
    if (!fileUrl.includes('?dl=1') && !fileUrl.includes('dl=1')) {
      fileUrl = fileUrl + '?dl=1';
      logger.info(`downloadResumeController: Modified URL with dl=1 parameter: ${fileUrl}`);
    }

    let fileResponse;
    try {
      // Add headers to Cloudinary request
      const fetchOptions = {
        method: 'GET',
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Accept': '*/*',
        },
      };

      logger.info(`downloadResumeController: Fetching with options...`);

      fileResponse = await fetch(fileUrl, fetchOptions);
      logger.info(`downloadResumeController: [2/3] Response received - Status: ${fileResponse.status}`);
      logger.info(`downloadResumeController: Content-Type: ${fileResponse.headers.get('content-type')}`);
      logger.info(`downloadResumeController: Content-Length: ${fileResponse.headers.get('content-length')}`);
    } catch (fetchError) {
      logger.error(`downloadResumeController: Fetch error - ${fetchError instanceof Error ? fetchError.message : String(fetchError)}`);
      return res.status(500).json({
        success: false,
        message: `Failed to connect to storage: ${fetchError instanceof Error ? fetchError.message : 'Unknown error'}`,
        data: null,
      });
    }

    if (!fileResponse.ok) {
      const errorText = await fileResponse.text();
      logger.error(
        `downloadResumeController: Failed to fetch file from Cloudinary - Status: ${fileResponse.status}`,
      );
      logger.error(`downloadResumeController: Cloudinary response: ${errorText}`);
      return res.status(500).json({
        success: false,
        message: `Failed to download file from storage (Status: ${fileResponse.status})`,
        data: null,
      });
    }

    const fileBuffer = await fileResponse.arrayBuffer();
    const buffer = Buffer.from(fileBuffer);

    logger.info(
      `downloadResumeController: [3/3] Successfully fetched file, size: ${buffer.length} bytes`,
    );

    // Return file with proper headers
    res.setHeader("Content-Type", "application/pdf");
    res.setHeader(
      "Content-Disposition",
      `attachment; filename="${data.fileName}"`,
    );
    res.setHeader("Content-Length", buffer.length);

    return res.send(buffer);
  } catch (error) {
    logger.error(
      `downloadResumeController: Exception occurred - ${error instanceof Error ? error.message : String(error)}`,
    );
    return res.status(500).json({
      success: false,
      message: "Internal server error while downloading resume",
      data: null,
    });
  }
};
