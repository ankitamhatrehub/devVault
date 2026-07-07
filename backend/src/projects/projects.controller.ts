import { Request, Response } from "express";
import { logger } from "../config/logger";
import {
  createProjectService,
  getAllProjectsService,
  getProjectByIdService,
  updateProjectService,
  deleteProjectService,
} from "./projects.service";

export const createProjectController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { projectName, summary, primaryStack, status, deadline, teamSize, projectNotes, focusTags, progress } = req.body;

    logger.info("Create project request from user => " + userId);

    const project = await createProjectService(userId, {
      projectName,
      summary,
      primaryStack,
      status,
      deadline,
      teamSize,
      projectNotes,
      focusTags,
      progress,
    });

    logger.info("Project created successfully");
    return res.status(201).json({
      success: true,
      message: "Project created successfully",
      data: project,
    });
  } catch (error) {
    logger.error("Create project error => " + error);
    return res.status(500).json({
      success: false,
      message: "Project creation failed",
      data: error,
    });
  }
};

export const getAllProjectsController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;

    logger.info("Get all projects request from user => " + userId);

    const projects = await getAllProjectsService(userId);

    logger.info("All projects fetched successfully");
    return res.status(200).json({
      success: true,
      message: "Projects fetched successfully",
      data: projects,
    });
  } catch (error) {
    logger.error("Get all projects error => " + error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch projects",
      data: error,
    });
  }
};

export const getProjectByIdController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;

    // Validate id exists before querying
    if (!id) {
      logger.error("Project id is missing");
      return res.status(400).json({
        success: false,
        message: "Project id is required",
      });
    }

    logger.info("Get project request for => " + id);

    const project = await getProjectByIdService(id, userId);

    if (!project) {
      logger.error("Project not found => " + id);
      return res.status(404).json({
        success: false,
        message: "Project not found",
      });
    }

    logger.info("Project fetched successfully");
    return res.status(200).json({
      success: true,
      message: "Project fetched successfully",
      data: project,
    });
  } catch (error) {
    logger.error("Get project error => " + error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch project",
      data: error,
    });
  }
};

export const updateProjectController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;
    const { projectName, summary, primaryStack, status, deadline, teamSize, projectNotes, focusTags, progress } = req.body;

    // Validate id exists before querying
    if (!id) {
      logger.error("Project id is missing");
      return res.status(400).json({
        success: false,
        message: "Project id is required",
      });
    }

    logger.info("Update project request for => " + id);

    const project = await updateProjectService(id, userId, {
      projectName,
      summary,
      primaryStack,
      status,
      deadline,
      teamSize,
      projectNotes,
      focusTags,
      progress,
    });

    if (!project) {
      logger.error("Project not found for update => " + id);
      return res.status(404).json({
        success: false,
        message: "Project not found",
      });
    }

    logger.info("Project updated successfully");
    return res.status(200).json({
      success: true,
      message: "Project updated successfully",
      data: project,
    });
  } catch (error) {
    logger.error("Update project error => " + error);
    return res.status(500).json({
      success: false,
      message: "Project update failed",
      data: error,
    });
  }
};

export const deleteProjectController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;

    // Validate id exists before querying
    if (!id) {
      logger.error("Project id is missing");
      return res.status(400).json({
        success: false,
        message: "Project id is required",
      });
    }

    logger.info("Delete project request for => " + id);

    const project = await deleteProjectService(id, userId);

    if (!project) {
      logger.error("Project not found for deletion => " + id);
      return res.status(404).json({
        success: false,
        message: "Project not found",
      });
    }

    logger.info("Project deleted successfully");
    return res.status(200).json({
      success: true,
      message: "Project deleted successfully",
      data: project,
    });
  } catch (error) {
    logger.error("Delete project error => " + error);
    return res.status(500).json({
      success: false,
      message: "Project deletion failed",
      data: error,
    });
  }
};
