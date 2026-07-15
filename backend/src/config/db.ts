// MongoDB connection configuration
import mongoose from "mongoose";
import { config as loadEnv } from "dotenv";
import path from "path";
import { logger } from "../config/logger.js";
// Load environment variables from .env file (from project root)
loadEnv({ path: path.resolve(".env") });

// Connect to MongoDB
export const connectDB = async () => {
  try {
    const mongoUrl = process.env.MONGODB_URL;

    if (!mongoUrl) {
      throw new Error("MONGODB_URL environment variable is not set");
    }

    await mongoose.connect(mongoUrl);
    logger.info("✅ MongoDB Connected Successfully");
  } catch (error) {
    logger.error("❌ MongoDB Connection Failed:", error);
    process.exit(1);
  }
};
