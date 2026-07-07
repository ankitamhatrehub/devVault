import { Request, Response } from "express";
import { logger } from "../config/logger";
import {
  createNoteService,
  getAllNotesService,
  getNoteByIdService,
  updateNoteService,
  deleteNoteService,
} from "./notes.service";

export const createNoteController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { title, body, category, pinned } = req.body;

    logger.info("Create note request from user => " + userId);

    const note = await createNoteService(userId, {
      title,
      body,
      category,
      pinned,
    });

    logger.info("Note created successfully");
    return res.status(201).json({
      success: true,
      message: "Note created successfully",
      data: note,
    });
  } catch (error) {
    logger.error("Create note error => " + error);
    return res.status(500).json({
      success: false,
      message: "Note creation failed",
      data: error,
    });
  }
};

export const getAllNotesController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;

    logger.info("Get all notes request from user => " + userId);

    const notes = await getAllNotesService(userId);

    logger.info("All notes fetched successfully");
    return res.status(200).json({
      success: true,
      message: "Notes fetched successfully",
      data: notes,
    });
  } catch (error) {
    logger.error("Get all notes error => " + error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch notes",
      data: error,
    });
  }
};

export const getNoteByIdController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;

    // Validate id exists before querying
    if (!id) {
      logger.error("Note id is missing");
      return res.status(400).json({
        success: false,
        message: "Note id is required",
      });
    }

    logger.info("Get note request for => " + id);

    const note = await getNoteByIdService(id, userId);

    if (!note) {
      logger.error("Note not found => " + id);
      return res.status(404).json({
        success: false,
        message: "Note not found",
      });
    }

    logger.info("Note fetched successfully");
    return res.status(200).json({
      success: true,
      message: "Note fetched successfully",
      data: note,
    });
  } catch (error) {
    logger.error("Get note error => " + error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch note",
      data: error,
    });
  }
};

export const updateNoteController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;
    const { title, body, category, pinned, decisions } = req.body;

    // Validate id exists before querying
    if (!id) {
      logger.error("Note id is missing");
      return res.status(400).json({
        success: false,
        message: "Note id is required",
      });
    }

    logger.info("Update note request for => " + id);

    const note = await updateNoteService(id, userId, {
      title,
      body,
      category,
      pinned,
    });

    if (!note) {
      logger.error("Note not found for update => " + id);
      return res.status(404).json({
        success: false,
        message: "Note not found",
      });
    }

    logger.info("Note updated successfully");
    return res.status(200).json({
      success: true,
      message: "Note updated successfully",
      data: note,
    });
  } catch (error) {
    logger.error("Update note error => " + error);
    return res.status(500).json({
      success: false,
      message: "Note update failed",
      data: error,
    });
  }
};

export const deleteNoteController = async (req: Request, res: Response) => {
  try {
    const userId = (req as any).user.userId;
    const { id } = req.params;

    // Validate id exists before querying
    if (!id) {
      logger.error("Note id is missing");
      return res.status(400).json({
        success: false,
        message: "Note id is required",
      });
    }

    logger.info("Delete note request for => " + id);

    const note = await deleteNoteService(id, userId);

    if (!note) {
      logger.error("Note not found for deletion => " + id);
      return res.status(404).json({
        success: false,
        message: "Note not found",
      });
    }

    logger.info("Note deleted successfully");
    return res.status(200).json({
      success: true,
      message: "Note deleted successfully",
      data: note,
    });
  } catch (error) {
    logger.error("Delete note error => " + error);
    return res.status(500).json({
      success: false,
      message: "Note deletion failed",
      data: error,
    });
  }
};
