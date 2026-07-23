import { GoogleGenAI } from "@google/genai";
import { logger } from "../config/logger.js";
import ChatModel from "./ai.model.js";
import { v4 as uuid } from "uuid";
import aiModel from "./ai.model.js";

const ai = new GoogleGenAI({
  apiKey: process.env.GEMINI_API_KEY!,
});

export const generateResponseService = async (
  userId: string,
  message: string,
) => {
  if (!message) {
    throw new Error("Message is required");
  }

  try {
    logger.info("========== User Message ==========");
    logger.info(message);

    // Save User Message
    await ChatModel.create({
      messageId: uuid(),
      userId,
      role: "user",
      message,
    });
    const response = await ai.models.generateContent({
      model: "gemini-3.6-flash",
      contents: message,
    });

    const answer = response.text ?? "";

    logger.info("========== AI Response ==========");
    logger.info(answer);

    // Save AI Response
    await ChatModel.create({
      messageId: uuid(),
      userId,
      role: "assistant",
      message: answer,
    });

    return {
      answer,
    };
  } catch (error: any) {
    logger.error("========== Gemini Error ==========");
    logger.error(error);

    throw new Error("Failed to generate AI response");
  }
};

export const getAiMsgService = async (userId: string) => {
  try {
    const userData = await ChatModel.find({ userId }).sort({
      createdAt: -1,
    });
    return userData;
  } catch (error: any) {
    logger.error("========== Gemini Error ==========");
    logger.error(error);

    throw new Error("Failed to get AI messages");
  }
};
