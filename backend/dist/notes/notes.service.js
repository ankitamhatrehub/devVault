import NotesModel from "./notes.model.js";
import { logger } from "../config/logger.js";
export const createNoteService = async (userId, noteData) => {
    try {
        logger.info("Creating note for user => " + userId);
        const note = await NotesModel.create({
            userId,
            ...noteData,
        });
        logger.info("Note created successfully => " + note._id);
        return note;
    }
    catch (error) {
        logger.error("Note creation failed => " + error);
        throw Error("Note creation failed in service");
    }
};
export const getAllNotesService = async (userId) => {
    try {
        logger.info("Fetching all notes for user => " + userId);
        const notes = await NotesModel.find({ userId, deletedAt: null }).sort({
            createdAt: -1,
        });
        logger.info("Notes fetched successfully, total => " + notes.length);
        return notes;
    }
    catch (error) {
        logger.error("Failed to fetch notes => " + error);
        throw Error("Failed to fetch notes in service");
    }
};
export const getNoteByIdService = async (noteId, userId) => {
    try {
        logger.info("Fetching note => " + noteId);
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
    }
    catch (error) {
        logger.error("Failed to fetch note => " + error);
        throw Error("Failed to fetch note in service");
    }
};
export const updateNoteService = async (noteId, userId, updateData) => {
    try {
        logger.info("Updating note => " + noteId + " for user => " + userId);
        const note = await NotesModel.findOneAndUpdate({ _id: noteId, userId, deletedAt: null }, updateData, { new: true });
        if (!note) {
            logger.error("Note not found for update => " + noteId);
            return null;
        }
        logger.info("Note updated successfully => " + noteId);
        return note;
    }
    catch (error) {
        logger.error("Failed to update note => " + error);
        throw Error("Failed to update note in service");
    }
};
export const deleteNoteService = async (noteId, userId) => {
    try {
        logger.info("Deleting note => " + noteId + " for user => " + userId);
        const note = await NotesModel.findOneAndDelete({ _id: noteId, userId, deletedAt: null }, { deletedAt: new Date() });
        if (!note) {
            logger.error("Note not found for deletion => " + noteId);
            return null;
        }
        logger.info("Note deleted successfully => " + noteId);
        return note;
    }
    catch (error) {
        logger.error("Failed to delete note => " + error);
        throw Error("Failed to delete note in service");
    }
};
//# sourceMappingURL=notes.service.js.map