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
    logger.info("User is this => " + userId);
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
        _id: user._id,
        id: user._id,
        name: user.name,
        email: user.email,
        password: user.password,
        bio: user.bio || "",
        designation: user.designation || "",
        experience: user.experience || "",
        currentComapny: user.currentComapny || "",
        location: user.location || "",
        avatar: user.avatar,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
    });
  } catch (error) {
    logger.error("getProfileController error: " + error);
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
    logger.info(`updateProfileController: Updating profile for user ${userId}`);

    const { name, email, bio, designation, experience, currentCompany, location } = req.body;

    // Log received data
    logger.info(`Received data - Name: ${name}, Email: ${email}, Bio: ${bio}`);
    logger.info(`Received data - Designation: ${designation}, Experience: ${experience}`);
    logger.info(`Received data - Company: ${currentCompany}, Location: ${location}`);

    // Update with currentComapny (backend field name - note the typo)
    const userUpdate = await updateprofileService(userId, {
      name,
      email,
      bio,
      designation,
      experience,
      currentComapny: currentCompany,  // Map to the backend field name
      location,
    });

    if (!userUpdate) {
      logger.error("updateProfileController: User not found");
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    logger.info(`updateProfileController: Profile updated successfully for user ${userId}`);

    // Return complete user data
    return res.status(200).json({
      success: true,
      message: "profile details updated successfully",
      data: {
        _id: userUpdate._id,
        id: userUpdate._id,
        name: userUpdate.name,
        email: userUpdate.email,
        password: userUpdate.password,
        bio: userUpdate.bio || "",
        designation: userUpdate.designation || "",
        experience: userUpdate.experience || "",
        currentComapny: userUpdate.currentComapny || "",
        location: userUpdate.location || "",
        avatar: userUpdate.avatar,
        createdAt: userUpdate.createdAt,
        updatedAt: userUpdate.updatedAt,
      },
    });
  } catch (error) {
    logger.error(`updateProfileController error: ${error}`);
    return res.status(500).json({
      success: false,
      message: "profile api has an issue",
      data: error,
    });
  }
};

export const changePasword = async (req: Request, res: Response) => {};
