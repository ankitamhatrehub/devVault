import LearningModel from "./learning.model.js";
import { logger } from "../config/logger.js";

export const createLearningService = async (
  userId: string,
  learningData: { title: string; des: string; category: string; status: string; priority: string; startDate: string; targetDate: string; steps?: { title: string; isCompleted?: boolean }[] }
) => {
  try {
    logger.info("Creating learning roadmap for user => " + userId);
    const learning = await LearningModel.create({
      userId,
      ...learningData,
    });
    logger.info("Learning roadmap created successfully => " + learning._id);
    return learning;
  } catch (error) {
    logger.error("Learning roadmap creation failed => " + error);
    throw Error("Learning roadmap creation failed in service");
  }
};

export const getAllLearningsService = async (userId: string) => {
  try {
    logger.info("Fetching all learning roadmaps for user => " + userId);
    // Filter deletedAt: null to exclude soft-deleted roadmaps
    const learnings = await LearningModel.find({ userId, deletedAt: null }).sort({ createdAt: -1 });
    logger.info("Learning roadmaps fetched successfully, total => " + learnings.length);
    return learnings;
  } catch (error) {
    logger.error("Failed to fetch learning roadmaps => " + error);
    throw Error("Failed to fetch learning roadmaps in service");
  }
};

export const getLearningByIdService = async (learningId: string, userId: string) => {
  try {
    logger.info("Fetching learning roadmap => " + learningId);
    // Ensure roadmap belongs to user and is not deleted
    const learning = await LearningModel.findOne({ _id: learningId, userId, deletedAt: null });
    if (!learning) {
      logger.error("Learning roadmap not found => " + learningId);
      return null;
    }
    logger.info("Learning roadmap fetched successfully");
    return learning;
  } catch (error) {
    logger.error("Failed to fetch learning roadmap => " + error);
    throw Error("Failed to fetch learning roadmap in service");
  }
};

export const updateLearningService = async (
  learningId: string,
  userId: string,
  updateData: { title?: string; des?: string; category?: string; status?: string; priority?: string; startDate?: string; targetDate?: string; steps?: { title: string; isCompleted?: boolean }[] }
) => {
  try {
    logger.info("Updating learning roadmap => " + learningId + " for user => " + userId);
    // Using findOneAndUpdate with new: true to return updated document
    const learning = await LearningModel.findOneAndUpdate(
      { _id: learningId, userId, deletedAt: null },
      updateData,
      { new: true }
    );
    if (!learning) {
      logger.error("Learning roadmap not found for update => " + learningId);
      return null;
    }
    logger.info("Learning roadmap updated successfully => " + learningId);
    return learning;
  } catch (error) {
    logger.error("Failed to update learning roadmap => " + error);
    throw Error("Failed to update learning roadmap in service");
  }
};

export const deleteLearningService = async (learningId: string, userId: string) => {
  try {
    logger.info("Deleting learning roadmap => " + learningId + " for user => " + userId);
    // Soft delete: setting deletedAt instead of removing from DB
    const learning = await LearningModel.findOneAndUpdate(
      { _id: learningId, userId, deletedAt: null },
      { deletedAt: new Date() },
      { new: true }
    );
    if (!learning) {
      logger.error("Learning roadmap not found for deletion => " + learningId);
      return null;
    }
    logger.info("Learning roadmap deleted successfully => " + learningId);
    return learning;
  } catch (error) {
    logger.error("Failed to delete learning roadmap => " + error);
    throw Error("Failed to delete learning roadmap in service");
  }
};
