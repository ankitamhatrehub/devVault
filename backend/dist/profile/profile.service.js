import AuthSchema from "../authentication/auth.model.js";
import { logger } from "../config/logger.js";
export const getprofileService = async (userId) => {
    const user = await AuthSchema.findById(userId).select("-password");
    return user;
};
export const updateprofileService = async (userId, updateData) => {
    try {
        logger.info(`updateprofileService: Updating user ${userId}`);
        logger.info(`Update data:`, updateData);
        const userIdService = await AuthSchema.findByIdAndUpdate(userId, updateData, { new: true }).select("-password");
        if (!userIdService) {
            logger.warn(`updateprofileService: User not found ${userId}`);
            throw Error("User not found");
        }
        logger.info(`updateprofileService: User updated successfully`);
        return userIdService;
    }
    catch (error) {
        logger.error(`updateprofileService error: ${error}`);
        throw Error(`Profile update failed: ${error instanceof Error ? error.message : String(error)}`);
    }
};
export const changePasswordProfile = async (userId) => { };
//# sourceMappingURL=profile.service.js.map