import AuthSchema from "../authentication/auth.model";

export const getprofileService = async (userId: string) => {
  const user = await AuthSchema.findById(userId).select("-password");
  return user;
};
export const updateprofileService = async (
  userId: string,
  updateData: { name: string; email: string },
) => {
  try {
    const userIdService = await AuthSchema.findByIdAndUpdate(
      userId,
      updateData,
      { new: true },
    ).select("-password");
    return userIdService;
  } catch (error) {
    throw Error("profile api has data or service related issue");
  }
};
export const changePasswordProfile = async (userId: string) => {};
