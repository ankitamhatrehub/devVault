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
  },
  {
    timestamps: true,
  },
);
const schema = mongoose.model("user", AuthSchema);
export default schema;
