import NotesModel from "./notes.model";
import { logger } from "../config/logger";

export const createNoteService = async (
  userId: string,
  noteData: {
    title: string;
    body: string;
    category: string;
    pinned?: boolean;
  
  },
) => {
  try {
    logger.info("Creating note for user => " + userId);
    const note = await NotesModel.create({
      userId,
      ...noteData,
    });
    logger.info("Note created successfully => " + note._id);
    return note;
  } catch (error) {
    logger.error("Note creation failed => " + error);
    throw Error("Note creation failed in service");
  }
};

export const getAllNotesService = async (userId: string) => {
  try {
    logger.info("Fetching all notes for user => " + userId);
    // Filter deletedAt: null to exclude soft-deleted notes
    const notes = await NotesModel.find({ userId, deletedAt: null }).sort({
      createdAt: -1,
    });
    logger.info("Notes fetched successfully, total => " + notes.length);
    return notes;
  } catch (error) {
    logger.error("Failed to fetch notes => " + error);
    throw Error("Failed to fetch notes in service");
  }
};

export const getNoteByIdService = async (noteId: string, userId: string) => {
  try {
    logger.info("Fetching note => " + noteId);
    // Ensure note belongs to user and is not deleted
    const note = await NotesModel.findOne({
      _id: noteId,
      userId,
      deletedAt: null,
    });
    if (!note) {
      logger.error("Note not found => " + noteId);
      return null;
    }
    logger.info("Note fetched successfully");
    return note;
  } catch (error) {
    logger.error("Failed to fetch note => " + error);
    throw Error("Failed to fetch note in service");
  }
};

export const updateNoteService = async (
  noteId: string,
  userId: string,
  updateData: {
    title?: string;
    body?: string;
    category?: string;
    pinned?: boolean;
    
  },
) => {
  try {
    logger.info("Updating note => " + noteId + " for user => " + userId);
    // Using findOneAndUpdate with new: true to return updated document
    const note = await NotesModel.findOneAndUpdate(
      { _id: noteId, userId, deletedAt: null },
      updateData,
      { new: true },
    );
    if (!note) {
      logger.error("Note not found for update => " + noteId);
      return null;
    }
    logger.info("Note updated successfully => " + noteId);
    return note;
  } catch (error) {
    logger.error("Failed to update note => " + error);
    throw Error("Failed to update note in service");
  }
};

export const deleteNoteService = async (noteId: string, userId: string) => {
  try {
    logger.info("Deleting note => " + noteId + " for user => " + userId);
    // Soft delete: setting deletedAt instead of removing from DB
    const note = await NotesModel.findOneAndDelete(
      { _id: noteId, userId, deletedAt: null },
      { deletedAt: new Date() },
    );
    if (!note) {
      logger.error("Note not found for deletion => " + noteId);
      return null;
    }
    logger.info("Note deleted successfully => " + noteId);
    return note;
  } catch (error) {
    logger.error("Failed to delete note => " + error);
    throw Error("Failed to delete note in service");
  }
};
