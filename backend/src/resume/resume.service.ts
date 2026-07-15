import ResumeSchema from "../resume/resume.model";
import { logger } from "../config/logger";
export const getResumeService = async (userId: string) => {
  try {
    logger.info(`getResumeService: Fetching resume for user ${userId}`);

    const resume = await ResumeSchema.findOne({ userId }).sort({
      createdAt: -1,
    });

    if (!resume) {
      logger.warn(`getResumeService: No resume found for user ${userId}`);
      throw new Error(`No resume found for user ${userId}`);
    }

    logger.info(
      `getResumeService: Resume fetched successfully for user ${userId}`,
    );
    return resume;
  } catch (error) {
    logger.error(
      `getResumeService: Error fetching resume for user ${userId} - ${error instanceof Error ? error.message : String(error)}`,
    );
    throw Error(
      `Failed to fetch resume: ${error instanceof Error ? error.message : String(error)}`,
    );
  }
};
interface UpdateResumePayload {
  fileName: string;
  fileUrl: string;
  fileSize: string;
  publicId: string;
}

interface ServiceResponse<Data = any> {
  success: boolean;
  data?: Data;
  error?: string;
}

export const updateResumeService = async (
  userId: string,
  payload: UpdateResumePayload,
): Promise<ServiceResponse> => {
  try {
    logger.info(`updateResumeService: Starting update for user ${userId}`);

    const existingResume = await ResumeSchema.findOne({ userId });

    if (!existingResume) {
      logger.warn(
        `updateResumeService: No existing resume found for user ${userId}`,
      );
      return {
        success: false,
        error: "Resume not found for this user",
      };
    }

    const updatedResume = await ResumeSchema.findByIdAndUpdate(
      existingResume._id,
      {
        fileName: payload.fileName,
        fileUrl: payload.fileUrl,
        fileSize: payload.fileSize,
        publicId: payload.publicId,
      },
      { new: true, runValidators: true },
    );

    logger.info(
      `updateResumeService: Resume updated successfully for user ${userId}`,
    );
    return {
      success: true,
      data: updatedResume,
    };
  } catch (error) {
    logger.error(
      `updateResumeService: Error updating resume for user ${userId} - ${error instanceof Error ? error.message : String(error)}`,
    );
    return {
      success: false,
      error: `Failed to update resume: ${error instanceof Error ? error.message : "Unknown error"}`,
    };
  }
};

export const deleteResumeService = async (
  userId: string,
): Promise<ServiceResponse> => {
  try {
    logger.info(`deleteResumeService: Starting delete for user ${userId}`);

    const resume = await ResumeSchema.findOne({ userId });

    if (!resume) {
      logger.warn(`deleteResumeService: No resume found for user ${userId}`);
      return {
        success: false,
        error: "Resume not found for this user",
      };
    }

    await ResumeSchema.findByIdAndDelete(resume._id);

    logger.info(
      `deleteResumeService: Resume deleted successfully for user ${userId}`,
    );
    return {
      success: true,
    };
  } catch (error) {
    logger.error(
      `deleteResumeService: Error deleting resume for user ${userId} - ${error instanceof Error ? error.message : String(error)}`,
    );
    return {
      success: false,
      error: `Failed to delete resume: ${error instanceof Error ? error.message : "Unknown error"}`,
    };
  }
};

export const downloadResumeService = async (
  userId: string,
): Promise<ServiceResponse> => {
  try {
    logger.info(`downloadResumeService: Starting retrieval for user ${userId}`);

    const resume = await ResumeSchema.findOne({ userId });

    if (!resume) {
      logger.warn(`downloadResumeService: No resume found for user ${userId}`);
      return {
        success: false,
        error: "Resume not found for this user",
      };
    }

    logger.info(
      `downloadResumeService: Resume retrieved successfully for user ${userId}`,
    );
    return {
      success: true,
      data: resume,
    };
  } catch (error) {
    logger.error(
      `downloadResumeService: Error retrieving resume for user ${userId} - ${error instanceof Error ? error.message : String(error)}`,
    );
    return {
      success: false,
      error: `Failed to retrieve resume: ${error instanceof Error ? error.message : "Unknown error"}`,
    };
  }
};
