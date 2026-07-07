import TasksModel from "./tasks.model";
import { logger } from "../config/logger";

export const createTaskService = async (
  userId: string,
  taskData: { title: string; description: string; priority: string; status: string; dueDate: string; category: string; progress?: number }
) => {
  try {
    logger.info("Creating task for user => " + userId);
    const task = await TasksModel.create({
      userId,
      ...taskData,
    });
    logger.info("Task created successfully => " + task._id);
    return task;
  } catch (error) {
    logger.error("Task creation failed => " + error);
    throw Error("Task creation failed in service");
  }
};

export const getAllTasksService = async (userId: string) => {
  try {
    logger.info("Fetching all tasks for user => " + userId);
    // Filter deletedAt: null to exclude soft-deleted tasks
    const tasks = await TasksModel.find({ userId, deletedAt: null }).sort({ createdAt: -1 });
    logger.info("Tasks fetched successfully, total => " + tasks.length);
    return tasks;
  } catch (error) {
    logger.error("Failed to fetch tasks => " + error);
    throw Error("Failed to fetch tasks in service");
  }
};

export const getTaskByIdService = async (taskId: string, userId: string) => {
  try {
    logger.info("Fetching task => " + taskId);
    // Ensure task belongs to user and is not deleted
    const task = await TasksModel.findOne({ _id: taskId, userId, deletedAt: null });
    if (!task) {
      logger.error("Task not found => " + taskId);
      return null;
    }
    logger.info("Task fetched successfully");
    return task;
  } catch (error) {
    logger.error("Failed to fetch task => " + error);
    throw Error("Failed to fetch task in service");
  }
};

export const updateTaskService = async (
  taskId: string,
  userId: string,
  updateData: { title?: string; description?: string; priority?: string; status?: string; dueDate?: string; category?: string; progress?: number }
) => {
  try {
    logger.info("Updating task => " + taskId + " for user => " + userId);
    // Using findOneAndUpdate with new: true to return updated document
    const task = await TasksModel.findOneAndUpdate(
      { _id: taskId, userId, deletedAt: null },
      updateData,
      { new: true }
    );
    if (!task) {
      logger.error("Task not found for update => " + taskId);
      return null;
    }
    logger.info("Task updated successfully => " + taskId);
    return task;
  } catch (error) {
    logger.error("Failed to update task => " + error);
    throw Error("Failed to update task in service");
  }
};

export const deleteTaskService = async (taskId: string, userId: string) => {
  try {
    logger.info("Deleting task => " + taskId + " for user => " + userId);
    // Soft delete: setting deletedAt instead of removing from DB
    const task = await TasksModel.findOneAndUpdate(
      { _id: taskId, userId, deletedAt: null },
      { deletedAt: new Date() },
      { new: true }
    );
    if (!task) {
      logger.error("Task not found for deletion => " + taskId);
      return null;
    }
    logger.info("Task deleted successfully => " + taskId);
    return task;
  } catch (error) {
    logger.error("Failed to delete task => " + error);
    throw Error("Failed to delete task in service");
  }
};
