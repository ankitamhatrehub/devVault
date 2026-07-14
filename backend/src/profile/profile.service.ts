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
    bio?: String;
    designation: String;
    experience: String;
    currentCompany?: String;
    location: String;

  },
  // name,
  // email,
  // bio,
  // designation,
  // experience,
  // currentCompany,
  // location,
) => {
  try {
    logger.info(
      "user id is => " +
        userId +
        "    and updated requested data " +
        updateData,
    );
    const userIdService = await AuthSchema.findByIdAndUpdate(
      userId,
      updateData,
      { new: true },
    ).select("-password");
    logger.info("usser updated data => " + updateData);
    return userIdService;
  } catch (error) {
    throw Error("profile api has data or service related issue");
  }
};
export const changePasswordProfile = async (userId: string) => {};
