import ProjectsModel from "./projects.model.js";
import { logger } from "../config/logger.js";
export const createProjectService = async (userId, projectData) => {
    try {
        logger.info("Creating project for user => " + userId);
        const project = await ProjectsModel.create({
            userId,
            ...projectData,
        });
        logger.info("Project created successfully => " + project._id);
        return project;
    }
    catch (error) {
        logger.error("Project creation failed => " + error);
        throw Error("Project creation failed in service");
    }
};
export const getAllProjectsService = async (userId) => {
    try {
        logger.info("Fetching all projects for user => " + userId);
        const projects = await ProjectsModel.find({ userId, deletedAt: null }).sort({ createdAt: -1 });
        logger.info("Projects fetched successfully, total => " + projects.length);
        return projects;
    }
    catch (error) {
        logger.error("Failed to fetch projects => " + error);
        throw Error("Failed to fetch projects in service");
    }
};
export const getProjectByIdService = async (projectId, userId) => {
    try {
        logger.info("Fetching project => " + projectId);
        const project = await ProjectsModel.findOne({ _id: projectId, userId, deletedAt: null });
        if (!project) {
            logger.error("Project not found => " + projectId);
            return null;
        }
        logger.info("Project fetched successfully");
        return project;
    }
    catch (error) {
        logger.error("Failed to fetch project => " + error);
        throw Error("Failed to fetch project in service");
    }
};
export const updateProjectService = async (projectId, userId, updateData) => {
    try {
        logger.info("Updating project => " + projectId + " for user => " + userId);
        const project = await ProjectsModel.findOneAndUpdate({ _id: projectId, userId, deletedAt: null }, updateData, { new: true });
        if (!project) {
            logger.error("Project not found for update => " + projectId);
            return null;
        }
        logger.info("Project updated successfully => " + projectId);
        return project;
    }
    catch (error) {
        logger.error("Failed to update project => " + error);
        throw Error("Failed to update project in service");
    }
};
export const deleteProjectService = async (projectId, userId) => {
    try {
        logger.info("Deleting project => " + projectId + " for user => " + userId);
        const project = await ProjectsModel.findOneAndUpdate({ _id: projectId, userId, deletedAt: null }, { deletedAt: new Date() }, { new: true });
        if (!project) {
            logger.error("Project not found for deletion => " + projectId);
            return null;
        }
        logger.info("Project deleted successfully => " + projectId);
        return project;
    }
    catch (error) {
        logger.error("Failed to delete project => " + error);
        throw Error("Failed to delete project in service");
    }
};
//# sourceMappingURL=projects.service.js.map