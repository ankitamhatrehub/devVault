import { Request, Response } from "express";
import { logger } from "../config/logger";
import { getResumeService } from "./resume.service";

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

export const updateResumeController = async (req: Request, res: Response) => {};
export const deleteResumeController = async (req: Request, res: Response) => {};
export const downloadResumeController = async (
  req: Request,
  res: Response,
) => {};
