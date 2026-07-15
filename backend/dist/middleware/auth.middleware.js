import jwt from "jsonwebtoken";
import { logger } from "../config/logger.js";
export const authMiddleware = (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        logger.info("authHeader is => " + authHeader);
        logger.info("request header is " + req.headers);
        logger.info(JSON.stringify(req.headers, null, 2));
        if (!authHeader) {
            return res.status(401).json({
                success: false,
                message: "Authorization header is missing",
            });
        }
        if (!authHeader.startsWith("Bearer ")) {
            return res.status(401).json({
                success: false,
                message: "Invalid authorization format",
            });
        }
        const token = authHeader.split(" ")[1];
        if (!token) {
            return res.status(401).json({
                success: false,
                message: "Token not found in authorization header",
            });
        }
        logger.info("token is " + token);
        logger.info("jwt secret is " + process.env.JWT_SECRET);
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        logger.info(decoded);
        req.user = decoded;
        next();
    }
    catch (error) {
        return res.status(401).json({
            success: false,
            message: "Invalid or expired token",
        });
    }
};
//# sourceMappingURL=auth.middleware.js.map