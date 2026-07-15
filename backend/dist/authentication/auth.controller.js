import { registerService, loginService } from "./auth.service.js";
export const registerController = async (req, res) => {
    try {
        const { name, email, password, confirmPassword } = req.body;
        const { user } = await registerService(name, email, password, confirmPassword);
        res.status(201).json({
            success: true,
            message: "User registered successfully",
            data: {
                user,
            },
        });
    }
    catch (error) {
        console.error("Registration error:", error);
        res.status(400).json({
            success: false,
            message: error.message || "Registration failed",
            data: {},
        });
    }
};
export const loginController = async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            console.log("Please fill the complete form");
            return res.status(400).json({
                message: "Please fill the complete form",
                success: false,
            });
        }
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            console.log("Please fill the proper email");
            return res.status(400).json({
                message: "Please fill the proper email",
                success: false,
            });
        }
        const { user, token } = await loginService(email, password);
        res.status(201).json({
            success: true,
            message: "User LoggedIn successfully",
            data: {
                user,
                accessToken: token,
            },
        });
    }
    catch (error) {
        console.error("Login error:", error);
        res.status(400).json({
            success: false,
            message: error.message || "Login failed",
            data: {},
        });
    }
};
//# sourceMappingURL=auth.controller.js.map