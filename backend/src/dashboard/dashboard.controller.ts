import { Request, Response } from "express";
import { logger } from "../config/logger";
import { getDashboardService } from "./dashboard.service";

export const getDashboardController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;

    logger.info("Dashboard controller called for user => " + userId);

    const dashboardData = await getDashboardService(userId);

    logger.info("Dashboard controller returned successfully");

    return res.status(200).json({
      success: true,
      message: "Dashboard fetched successfully",
      data: dashboardData,
    });
  } catch (error) {
    logger.error("Dashboard controller error => " + error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch dashboard",
      data: error,
    });
  }
};
