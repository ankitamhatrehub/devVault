import express from "express";
import { config as loadEnv } from "dotenv";
import path from "path";
loadEnv({ path: path.resolve(".env") });
import { connectDB } from "./config/db.js";
import router from "./routes.js";
const app = express();
const PORT = process.env.PORT || 3000;
connectDB();
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));
import cors from "cors";
app.use(cors({
    origin: process.env.CORS_ORIGIN || "*",
    credentials: true,
}));
app.use("/api", router);
app.get("/health", (_req, res) => {
    res.status(200).json({
        status: "healthy",
        timestamp: new Date().toISOString(),
        version: "1.0.0",
    });
});
app.use((err, _req, res, _next) => {
    console.error("Error:", err);
    res.status(err.status || 500).json({
        success: false,
        message: err.message || "Internal Server Error",
        errors: err.errors || {},
    });
});
app.use((_req, res) => {
    res.status(404).json({
        success: false,
        message: "Route not found",
    });
});
app.listen(PORT, () => {
    console.log(`✅ Server is running on http://localhost:${PORT}`);
    console.log(`📊 Health check: http://localhost:${PORT}/health`);
    console.log(`📝 API Documentation: http://localhost:${PORT}/api/docs`);
});
export default app;
//# sourceMappingURL=app.js.map