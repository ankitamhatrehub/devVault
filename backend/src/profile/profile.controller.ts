import { Request, Response } from "express";
import { logger } from "../config/logger";
import {
  getprofileService,
  updateprofileService,
  changePasswordProfile,
} from "./profile.service";

export const getProfileController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    logger.info("User  is this => " + userId);
    const user = await getprofileService(userId);
    if (!user) {
      logger.error("User not found");
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }
    logger.info("profile details fetch successfully");
    return res.status(200).json({
      success: true,
      message: "profile details fetch successfully",
      data: {
        id: user._id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
      },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "profile api has an issue",
      data: error,
    });
  }
};

export const updateProfileController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { name, email,bio,designation,experience,currentCompany,location } = req.body;
    const userUpdate = await updateprofileService(userId, {
      name,
      email,
      bio,
      designation,
      experience,
      currentCompany,
      location,
    });
    logger.info("usser updated data => " + userUpdate);
    return res.status(200).json({
      success: true,
      message: "profile details updated successfully",
      data: userUpdate,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "profile api has an issue",
      data: error,
    });
  }
};

export const changePasword = async (req: Request, res: Response) => {};
