import { Router } from "express";
import { registerController, loginController } from "./auth.controller.js";
const router = Router();
router.post("/register", registerController);
router.post("/login", loginController);
export default router;
//# sourceMappingURL=auth.routes.js.map