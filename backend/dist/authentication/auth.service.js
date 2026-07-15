import AuthSchema from "./auth.model.js";
import bcrypt from "bcryptjs";
import jsonWebToken from "jsonwebtoken";
import { logger } from "../config/logger.js";
export const registerService = async (name, email, password, confirmPassword) => {
    if (!name || !email || !password || !confirmPassword) {
        throw new Error("Please fill all details");
    }
    const isUserExist = await AuthSchema.findOne({ email });
    if (isUserExist) {
        throw new Error("User with this email already exists");
    }
    if (password !== confirmPassword) {
        throw new Error("Passwords do not match");
    }
    const pass = await bcrypt.hash(password, 10);
    const newUser = await AuthSchema.create({
        name,
        email,
        password: pass,
    });
    return {
        user: {
            userId: newUser._id,
            name: newUser.name,
            email: newUser.email,
            createdAt: newUser.createdAt,
        },
    };
};
export const loginService = async (email, password) => {
    if (!email || !password) {
        throw new Error("Please fill all details");
    }
    const user = await AuthSchema.findOne({ email });
    if (!user) {
        throw new Error("User not found");
    }
    const oldpass = await bcrypt.compare(password, user.password);
    if (!oldpass) {
        logger.error("Invalid email or password");
        throw new Error("Invalid email or password");
    }
    const token = await jsonWebToken.sign({
        userId: user._id,
    }, process.env.JWT_SECRET, {
        expiresIn: "15d",
    });
    return {
        user: {
            userId: user._id,
            name: user.name,
            email,
            createdAt: user.createdAt,
        },
        token,
    };
};
//# sourceMappingURL=auth.service.js.map