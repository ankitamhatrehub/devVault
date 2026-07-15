import AuthSchema from "../authentication/auth.model";
import { logger } from "../config/logger";
export const getprofileService = async (userId: string) => {
  const user = await AuthSchema.findById(userId).select("-password");
  return user;
};
export const updateprofileService = async (
  userId: string,
  updateData: {
    name: string;
    email: string;
    bio?: string;
    designation: string;
    experience: string;
    currentComapny?: string;
    location: string;
  },
) => {
  try {
    logger.info(`updateprofileService: Updating user ${userId}`);
    logger.info(`Update data:`, updateData);

    const userIdService = await AuthSchema.findByIdAndUpdate(
      userId,
      updateData,
      { new: true },
    ).select("-password");

    if (!userIdService) {
      logger.warn(`updateprofileService: User not found ${userId}`);
      throw Error("User not found");
    }

    logger.info(`updateprofileService: User updated successfully`);
    return userIdService;
  } catch (error) {
    logger.error(`updateprofileService error: ${error}`);
    throw Error(`Profile update failed: ${error instanceof Error ? error.message : String(error)}`);
  }
};
export const changePasswordProfile = async (userId: string) => {};
