// MongoDB connection configuration
import mongoose from "mongoose";
import dotenv from "dotenv";
import path from "path";

// Load environment variables from .env file (from project root)
dotenv.config({ path: path.resolve(".env") });

// Connect to MongoDB
export const connectDB = async () => {
  try {
    const mongoUrl = process.env.MONGODB_URL;

    if (!mongoUrl) {
      throw new Error("MONGODB_URL environment variable is not set");
    }

    await mongoose.connect(mongoUrl);
    console.log("✅ MongoDB Connected Successfully");
  } catch (error) {
    console.error("❌ MongoDB Connection Failed:", error);
    process.exit(1);
  }
};
