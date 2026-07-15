import { Request, Response } from "express";
import { logger } from "../config/logger";
import {
  getResumeService,
  updateResumeService,
  deleteResumeService,
  downloadResumeService,
} from "./resume.service";

//get resume controller
export const getResumeController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    logger.info("this is the " + userId + " who want to see his resume");

    const service = await getResumeService(userId);
    return res.status(200).json({
      success: true,
      message: "Resume fetch successfully",
      data: service,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Something wrong in Resume fetching",
      data: error,
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

// download resume controller
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

    logger.info(
      `downloadResumeController: Resume retrieved successfully for user ${userId}`,
    );
    return res.status(200).json({
      success: true,
      message: "Resume retrieved successfully",
      data: data,
    });
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
