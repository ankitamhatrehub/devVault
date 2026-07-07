import mongoose from "mongoose";

const ProjectsSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "user",
      required: true,
    },
    projectName: {
      type: String,
      required: true,
      trim: true,
    },
    summary: {
      type: String,
      required: true,
    },
    primaryStack: {
      type: String,
      required: true,
      trim: true,
    },
    status: {
      type: String,
      required: true,
      trim: true,
    },
    deadline: {
      type: String,
      required: true,
    },
    teamSize: {
      type: String,
      required: true,
      trim: true,
    },
    projectNotes: {
      type: String,
      required: true,
    },
    // Using array to store multiple tech tags or focus areas
    focusTags: {
      type: [String],
      default: [],
    },
    progress: {
      type: Number,
      default: 0,
    },
    // Using soft delete with deletedAt to preserve data for audit trails
    deletedAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

const ProjectsModel = mongoose.model("projects", ProjectsSchema);
export default ProjectsModel;
