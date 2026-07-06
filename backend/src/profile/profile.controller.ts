import { Request, Response } from "express";
import logger from "logger";
import {
  getprofileService,
  updateprofileService,
  changePasswordProfile,
} from "./profile.service";

export const getProfileController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user._id;
    const user = await getprofileService(userId);
    if (!user) {
      // logger.("User not found");
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }
    return res.status(200).json({
      success: true,
      message: "profile details fetch successfully",
      data: {
        id: user._id,
        name: user.name,
        email: user.email,
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
    const userId = (req as any).user._id;
    const { name, email } = req.body;
    const userUpdate = await updateprofileService(userId, { name, email });
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
