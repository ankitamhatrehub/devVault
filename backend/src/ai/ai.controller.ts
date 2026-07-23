import { Request, Response } from "express";
import { generateResponseService, getAiMsgService } from "./ai.service.js";

export const sendMessage = async (req: Request, res: Response) => {
  try {
    console.log("user id===========================");
    const userId = (req as any).user?.userId;
    console.log("=========================== " + userId);
    const { message } = req.body;

    console.log("===========================");
    console.log("Incoming Request");
    console.log(message);

    if (!message) {
      return res.status(400).json({
        success: false,
        message: "Message is required",
      });
    }

    const answer = await generateResponseService(userId, message);

    return res.status(200).json({
      success: true,
      answer,
    });
  } catch (error) {
    console.log("Controller Error");

    console.log(error);

    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};
export const getMessage = async (req: Request, res: Response) => {
    try {
        console.log("user id===========================");
        const userId = (req as any).user?.userId;
        const getService = await getAiMsgService(userId);
         return res.status(201).json({
           success: true,
             message: "get ai messages successfully",
           data : getService
         });
      
    } catch (error) {
        console.log("Controller Error");

        console.log(error);

        return res.status(500).json({
            success: false,
            message: "get messages Internal Server Error",
        });
    }
}