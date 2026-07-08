import mongoose from "mongoose";
const AuthSchema = new mongoose.Schema(
  {
    name: {
      type: String,

      trim: true,
    },
    email: {
      type: String,
      required: true,
      trim: true,
    },
    password: {
      type: String,
      required: true,
      trim: true,
    },
    bio: {
      type: String,
      // required: true,
      trim: true,
    },
    designation: {
      type: String,
      // required: true,
      trim: true,
    },
    experience: {
      type: String,
      // required: true,
      trim: true,
    },
    currentComapny: {
      type: String,
      trim: true,
    },
    location: {
      type: String,
      // required: true,
      trim: true,
    },
  },
  {
    timestamps: true,
  },
);
const schema = mongoose.model("user", AuthSchema);
export default schema;
