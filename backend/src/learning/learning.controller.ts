import { Request, Response } from "express";
import { logger } from "../config/logger.js";
import {
  createLearningService,
  getAllLearningsService,
  getLearningByIdService,
  updateLearningService,
  deleteLearningService,
} from "./learning.service.js";

export const createLearningController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { title, des, category, status, priority, startDate, targetDate, steps } = req.body;

    logger.info("Create learning roadmap request from user => " + userId);

    const learning = await createLearningService(userId, {
      title,
      des,
      category,
      status,
      priority,
      startDate,
      targetDate,
      steps,
    });

    logger.info("Learning roadmap created successfully");
    return res.status(201).json({
      success: true,
      message: "Learning roadmap created successfully",
      data: learning,
    });
  } catch (error) {
    logger.error("Create learning roadmap error => " + error);
    return res.status(500).json({
      success: false,
      message: "Learning roadmap creation failed",
      data: error,
    });
  }
};

export const getAllLearningsController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;

    logger.info("Get all learning roadmaps request from user => " + userId);

    const learnings = await getAllLearningsService(userId);

    logger.info("All learning roadmaps fetched successfully");
    return res.status(200).json({
      success: true,
      message: "Learning roadmaps fetched successfully",
      data: learnings,
    });
  } catch (error) {
    logger.error("Get all learning roadmaps error => " + error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch learning roadmaps",
      data: error,
    });
  }
};

export const getLearningByIdController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;

    // Validate id exists before querying
    if (!id) {
      logger.error("Learning roadmap id is missing");
      return res.status(400).json({
        success: false,
        message: "Learning roadmap id is required",
      });
    }

    logger.info("Get learning roadmap request for => " + id);

    const learning = await getLearningByIdService(id, userId);

    if (!learning) {
      logger.error("Learning roadmap not found => " + id);
      return res.status(404).json({
        success: false,
        message: "Learning roadmap not found",
      });
    }

    logger.info("Learning roadmap fetched successfully");
    return res.status(200).json({
      success: true,
      message: "Learning roadmap fetched successfully",
      data: learning,
    });
  } catch (error) {
    logger.error("Get learning roadmap error => " + error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch learning roadmap",
      data: error,
    });
  }
};

export const updateLearningController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;
    const { title, des, category, status, priority, startDate, targetDate, steps } = req.body;

    // Validate id exists before querying
    if (!id) {
      logger.error("Learning roadmap id is missing");
      return res.status(400).json({
        success: false,
        message: "Learning roadmap id is required",
      });
    }

    logger.info("Update learning roadmap request for => " + id);

    const learning = await updateLearningService(id, userId, {
      title,
      des,
      category,
      status,
      priority,
      startDate,
      targetDate,
      steps,
    });

    if (!learning) {
      logger.error("Learning roadmap not found for update => " + id);
      return res.status(404).json({
        success: false,
        message: "Learning roadmap not found",
      });
    }

    logger.info("Learning roadmap updated successfully");
    return res.status(200).json({
      success: true,
      message: "Learning roadmap updated successfully",
      data: learning,
    });
  } catch (error) {
    logger.error("Update learning roadmap error => " + error);
    return res.status(500).json({
      success: false,
      message: "Learning roadmap update failed",
      data: error,
    });
  }
};

export const deleteLearningController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;

    // Validate id exists before querying
    if (!id) {
      logger.error("Learning roadmap id is missing");
      return res.status(400).json({
        success: false,
        message: "Learning roadmap id is required",
      });
    }

    logger.info("Delete learning roadmap request for => " + id);

    const learning = await deleteLearningService(id, userId);

    if (!learning) {
      logger.error("Learning roadmap not found for deletion => " + id);
      return res.status(404).json({
        success: false,
        message: "Learning roadmap not found",
      });
    }

    logger.info("Learning roadmap deleted successfully");
    return res.status(200).json({
      success: true,
      message: "Learning roadmap deleted successfully",
      data: learning,
    });
  } catch (error) {
    logger.error("Delete learning roadmap error => " + error);
    return res.status(500).json({
      success: false,
      message: "Learning roadmap deletion failed",
      data: error,
    });
  }
};
