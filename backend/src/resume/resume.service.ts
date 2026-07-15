import ResumeSchema from "../resume/resume.model";
import { logger } from "../config/logger";
export const getResumeService = async (userId: string) => {
  try {
    const user = await ResumeSchema.findById({ userId }).sort({
      createdAt: -1,
    });
    logger.info("this is the user resume");
    return user;
  } catch (error) {
    throw Error("the error from service of get resume data " + error);
  }
};
export const updateResumeService = async (userId: string) => {};
export const deleteResumeService = async (userId: string) => {};
export const downloadResumeService = async (userId: string) => {};
