import { Request, Response } from "express";
import { logger } from "../config/logger.js";
import {
  createTaskService,
  getAllTasksService,
  getTaskByIdService,
  updateTaskService,
  deleteTaskService,
} from "./tasks.service.js";

export const createTaskController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { title, description, priority, status, dueDate, category, progress } = req.body;

    logger.info("Create task request from user => " + userId);

    const task = await createTaskService(userId, {
      title,
      description,
      priority,
      status,
      dueDate,
      category,
      progress,
    });

    logger.info("Task created successfully");
    return res.status(201).json({
      success: true,
      message: "Task created successfully",
      data: task,
    });
  } catch (error) {
    logger.error("Create task error => " + error);
    return res.status(500).json({
      success: false,
      message: "Task creation failed",
      data: error,
    });
  }
};

export const getAllTasksController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;

    logger.info("Get all tasks request from user => " + userId);

    const tasks = await getAllTasksService(userId);

    logger.info("All tasks fetched successfully");
    return res.status(200).json({
      success: true,
      message: "Tasks fetched successfully",
      data: tasks,
    });
  } catch (error) {
    logger.error("Get all tasks error => " + error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch tasks",
      data: error,
    });
  }
};

export const getTaskByIdController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;

    // Validate id exists before querying
    if (!id) {
      logger.error("Task id is missing");
      return res.status(400).json({
        success: false,
        message: "Task id is required",
      });
    }

    logger.info("Get task request for => " + id);

    const task = await getTaskByIdService(id, userId);

    if (!task) {
      logger.error("Task not found => " + id);
      return res.status(404).json({
        success: false,
        message: "Task not found",
      });
    }

    logger.info("Task fetched successfully");
    return res.status(200).json({
      success: true,
      message: "Task fetched successfully",
      data: task,
    });
  } catch (error) {
    logger.error("Get task error => " + error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch task",
      data: error,
    });
  }
};

export const updateTaskController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;
    const { title, description, priority, status, dueDate, category, progress } = req.body;

    // Validate id exists before querying
    if (!id) {
      logger.error("Task id is missing");
      return res.status(400).json({
        success: false,
        message: "Task id is required",
      });
    }

    logger.info("Update task request for => " + id);

    const task = await updateTaskService(id, userId, {
      title,
      description,
      priority,
      status,
      dueDate,
      category,
      progress,
    });

    if (!task) {
      logger.error("Task not found for update => " + id);
      return res.status(404).json({
        success: false,
        message: "Task not found",
      });
    }

    logger.info("Task updated successfully");
    return res.status(200).json({
      success: true,
      message: "Task updated successfully",
      data: task,
    });
  } catch (error) {
    logger.error("Update task error => " + error);
    return res.status(500).json({
      success: false,
      message: "Task update failed",
      data: error,
    });
  }
};

export const deleteTaskController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;

    // Validate id exists before querying
    if (!id) {
      logger.error("Task id is missing");
      return res.status(400).json({
        success: false,
        message: "Task id is required",
      });
    }

    logger.info("Delete task request for => " + id);

    const task = await deleteTaskService(id, userId);

    if (!task) {
      logger.error("Task not found for deletion => " + id);
      return res.status(404).json({
        success: false,
        message: "Task not found",
      });
    }

    logger.info("Task deleted successfully");
    return res.status(200).json({
      success: true,
      message: "Task deleted successfully",
      data: task,
    });
  } catch (error) {
    logger.error("Delete task error => " + error);
    return res.status(500).json({
      success: false,
      message: "Task deletion failed",
      data: error,
    });
  }
};
