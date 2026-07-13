// Import the Request type from Express to check incoming HTTP requests
import { Request } from "express";
// Import multer for file handling and FileFilterCallback for type safety
import multer, { FileFilterCallback } from "multer";
// Import our pre-configured Cloudinary connection from the config folder
import cloudinary from "../config/cloudinary";


// Tell Multer to store files in RAM temporary memory, not on the hard drive
const storage = multer.memoryStorage();



// Create a function to filter out unwanted files based on their type
const fileFilter = (
  // The request object is not used here, so we name it with an underscore
  _req: Request,
  // The file object contains information like name, size, and mime type
  file: Express.Multer.File,
  // The callback function tells Multer if the file is accepted or rejected
  cb: FileFilterCallback,
) => {
  // Check if the file format starts with the word "image/" or "video/"
  if (
    file.mimetype.startsWith("image/") ||
    file.mimetype.startsWith("video/")
  ) {
    // Accept the file by sending 'null' for error and 'true' for success
    cb(null, true);
  } else {
    // Reject the file by sending 'null' for error and 'false' for success
    cb(null, false);
    // Send back a clear Error object explaining why the file was rejected
    cb(new Error("Invalid file type. Only images and videos are supported!"));
  }
};

// Combine storage, filters, and size rules into one exportable middleware tool
export const upload = multer({
  // Use our RAM-based temporary storage configuration
  storage,
  // Use our function that only allows images and videos
  fileFilter,
  // Set a strict size limit of 5 Megabytes (calculated in bytes)
  limits: { fileSize: 5 * 1024 * 1024 },
});

// Create an asynchronous helper function to send the raw file data to Cloudinary
export const uploadToCloudinary = (
  // Parameter 1: The raw file data stored as a Node.js Buffer
  fileBuffer: Buffer,
  // Parameter 2: The folder name in Cloudinary, defaults to "devvault_uploads"
  folderName: string = "devvault_uploads",
  // Tell TypeScript this function returns a Promise that resolves with any data type
): Promise<any> => {
  // Return a new Promise to handle the asynchronous network request safely
  return new Promise((resolve, reject) => {
    // Initialize Cloudinary's upload stream and pass the target folder configuration
    const uploadStream = cloudinary.uploader.upload_stream(
      { folder: folderName },
      // This callback function runs when Cloudinary responds to our request
      (error, result) => {
        // If an error happens during the upload, reject the promise immediately
        if (error) return reject(error);
        // If successful, resolve the promise and return the image data object
        resolve(result);
      },
    );
    // Take the raw file buffer from RAM and feed it into the upload stream to finish
    uploadStream.end(fileBuffer);
  });
};
