import TasksModel from "./tasks.model.js";
import { logger } from "../config/logger.js";
export const createTaskService = async (userId, taskData) => {
    try {
        logger.info("Creating task for user => " + userId);
        const task = await TasksModel.create({
            userId,
            ...taskData,
        });
        logger.info("Task created successfully => " + task._id);
        return task;
    }
    catch (error) {
        logger.error("Task creation failed => " + error);
        throw Error("Task creation failed in service");
    }
};
export const getAllTasksService = async (userId) => {
    try {
        logger.info("Fetching all tasks for user => " + userId);
        const tasks = await TasksModel.find({ userId, deletedAt: null }).sort({ createdAt: -1 });
        logger.info("Tasks fetched successfully, total => " + tasks.length);
        return tasks;
    }
    catch (error) {
        logger.error("Failed to fetch tasks => " + error);
        throw Error("Failed to fetch tasks in service");
    }
};
export const getTaskByIdService = async (taskId, userId) => {
    try {
        logger.info("Fetching task => " + taskId);
        const task = await TasksModel.findOne({ _id: taskId, userId, deletedAt: null });
        if (!task) {
            logger.error("Task not found => " + taskId);
            return null;
        }
        logger.info("Task fetched successfully");
        return task;
    }
    catch (error) {
        logger.error("Failed to fetch task => " + error);
        throw Error("Failed to fetch task in service");
    }
};
export const updateTaskService = async (taskId, userId, updateData) => {
    try {
        logger.info("Updating task => " + taskId + " for user => " + userId);
        const task = await TasksModel.findOneAndUpdate({ _id: taskId, userId, deletedAt: null }, updateData, { new: true });
        if (!task) {
            logger.error("Task not found for update => " + taskId);
            return null;
        }
        logger.info("Task updated successfully => " + taskId);
        return task;
    }
    catch (error) {
        logger.error("Failed to update task => " + error);
        throw Error("Failed to update task in service");
    }
};
export const deleteTaskService = async (taskId, userId) => {
    try {
        logger.info("Deleting task => " + taskId + " for user => " + userId);
        const task = await TasksModel.findOneAndUpdate({ _id: taskId, userId, deletedAt: null }, { deletedAt: new Date() }, { new: true });
        if (!task) {
            logger.error("Task not found for deletion => " + taskId);
            return null;
        }
        logger.info("Task deleted successfully => " + taskId);
        return task;
    }
    catch (error) {
        logger.error("Failed to delete task => " + error);
        throw Error("Failed to delete task in service");
    }
};
//# sourceMappingURL=tasks.service.js.map