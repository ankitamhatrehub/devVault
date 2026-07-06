import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

export const authMiddleware = (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    // Step 1: Read Authorization header
    const authHeader = req.headers.authorization;

    // Step 2: Check if header exists
    if (!authHeader) {
      return res.status(401).json({
        success: false,
        message: "Authorization header is missing",
      });
    }

    // Step 3: Check Bearer format
    if (!authHeader.startsWith("Bearer ")) {
      return res.status(401).json({
        success: false,
        message: "Invalid authorization format",
      });
    }

    // Step 4: Extract the token
    const token = authHeader.split(" ")[1];
    // Step 4.5: Check if token exists (ADD THIS)
    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Token not found in authorization header",
      });
    }
    // Step 5: Verify the token
    const decoded = jwt.verify(token, process.env.JWT_SECRET!);

    // Step 6: Attach decoded user to request
    (req as any).user = decoded;

    // Step 7: Continue to the next middleware/controller
    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      message: "Invalid or expired token",
    });
  }
};




//how to use
// import { authMiddleware } from "../middleware/auth.middleware";
// // Apply to a single route
// router.get("/profile", authMiddleware, (req, res) => {
//   // Only authenticated users reach here
// });

// // OR apply to all routes in this router
// router.use(authMiddleware);
