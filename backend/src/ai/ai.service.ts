import { GoogleGenAI } from "@google/genai";
import { logger } from "../config/logger.js";
import ChatModel from "./ai.model.js";
import { v4 as uuid } from "uuid";
import aiModel from "./ai.model.js";
import axios from "axios";
import pdfParse from "pdf-parse";
import fs from "fs";
import dotenv from "dotenv";
import ResumeModel from "../resume/resume.model.js";

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

//ai resume review service

// export const aiReviewResumeService = async (userId: string) => {
//   try {
//     logger.info("=========== Resume Review ===========");

//     const user = await ResumeModel.findById(userId);

//     if (!user) {
//       throw new Error("User not found");
//     }

//     if (!user.fileUrl) {
//       throw new Error("Resume not uploaded");
//     }

//     logger.info("Downloading Resume...");
//     logger.info(user.fileUrl);

//     // Download PDF
//     const response = await axios.get(user.fileUrl, {
//       responseType: "arraybuffer",
//     });

//     // Extract Text
//     const pdfData = await pdfParse(response.data);

//     const resumeText = pdfData.text;

//     logger.info("Resume Extracted Successfully");

//     const prompt = `
// You are a Senior Technical Recruiter.

// Review the following resume.

// Return ONLY valid JSON.

// {
//   "atsScore":0,
//   "strengths":[],
//   "weaknesses":[],
//   "missingSkills":[],
//   "suggestions":[]
// }

// Resume:

// ${resumeText}
// `;

//     logger.info("Sending Resume To Gemini...");

//     const geminiResponse = await ai.models.generateContent({
//       model: "gemini-2.5-flash",
//       contents: prompt,
//     });

//     const answer = geminiResponse.text ?? "";

//     logger.info("Resume Review Completed");

//     return JSON.parse(answer);
//   } catch (error: any) {
//     logger.error(error);

//     throw new Error("Failed to review resume");
//   }
// };
