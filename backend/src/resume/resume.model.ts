import { timeStamp } from "console";
import mongoose from "mongoose";

export const ResumeSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "user",
      required: true,
    },
    fileName: {
      type: String,
      required: true,
      trim: true,
    },
    fileUrl: {
      type: String,
      required: true,
      trim: true,
    },
    fileSize: {
      type: String,
      required: true,
      trim: true,
    },
    publicId: {
      type: String,
      required: true,
      trim: true,
    },

    //        └─ Field: fileSize → type: String
    //    └─ Field: fileUrl → type: String
    //    └─ Field: publicId → type: String (for Cloudinary)
    //    └─ Don't forget: timestamps: true
  },
  {
    timestamps: true,
  },
);

 const ResumeModel = mongoose.model("/resume", ResumeSchema);
export default ResumeModel;