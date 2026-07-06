// Import Express framework for creating web server
import express from "express";
import dotenv from "dotenv";
import path from "path";

// Load environment variables from .env (from project root)
dotenv.config({ path: path.resolve(".env") });

// Import database connection
import { connectDB } from "./config/db";

// Import API routes - centralized routing configuration
import router from "./routes";

// Create Express application instance
const app = express();

// Define the port where the server will listen (from .env or default to 3000)
const PORT = process.env.PORT || 3000;

// Connect to MongoDB before starting server
connectDB();

// ========== MIDDLEWARE SETUP ==========

// Middleware: Parse incoming JSON request bodies and limits
app.use(express.json({ limit: "10mb" }));

// Middleware: Parse URL-encoded data from forms
app.use(express.urlencoded({ extended: true, limit: "10mb" }));

// TODO: Install cors and helmet packages for production security
// npm install cors helmet @types/cors
// Uncomment below lines once installed:
/*
import cors from "cors";
app.use(cors({
  origin: process.env.CORS_ORIGIN || "*",
  credentials: true,
}));

import helmet from "helmet";
app.use(helmet());
*/

// ========== ROUTES ==========

// Routes: Mount all API routes under /api prefix
// Example: POST /api/auth/register, GET /api/projects, etc.
app.use("/api", router);

// Health check endpoint for monitoring server status
app.get("/health", (_req, res) => {
  res.status(200).json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    version: "1.0.0",
  });
});

// ========== ERROR HANDLING ==========

// Error handling middleware for catching and processing errors
app.use(
  (
    err: any,
    _req: express.Request,
    res: express.Response,
    _next: express.NextFunction,
  ) => {
    console.error("Error:", err);
    res.status(err.status || 500).json({
      success: false,
      message: err.message || "Internal Server Error",
      errors: err.errors || {},
    });
  },
);

// 404 Not Found handler
app.use((_req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found",
  });
});

// ========== START SERVER ==========

// Start the Express server and listen on the defined PORT
app.listen(PORT, () => {
  console.log(`✅ Server is running on http://localhost:${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`📝 API Documentation: http://localhost:${PORT}/api/docs`);
});

// Export the Express app for testing or module usage
export default app;
