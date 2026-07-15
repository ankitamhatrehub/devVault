import { Router } from "express";
import {
  createNoteController,
  getAllNotesController,
  getNoteByIdController,
  updateNoteController,
  deleteNoteController,
} from "./notes.controller.js";
import { authMiddleware } from "../middleware/auth.middleware.js";

const router = Router();

// All routes protected with authMiddleware to ensure user is authenticated
router.post("/createNote", authMiddleware, createNoteController);
router.get("/getAllNotes", authMiddleware, getAllNotesController);
router.get("/:id", authMiddleware, getNoteByIdController);
router.put("/:id", authMiddleware, updateNoteController);
router.delete("/:id", authMiddleware, deleteNoteController);

export default router;
