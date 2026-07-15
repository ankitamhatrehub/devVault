import multer from "multer";
import cloudinary from "../config/cloudinary.js";
const storage = multer.memoryStorage();
const fileFilter = (_req, file, cb) => {
    if (file.mimetype.startsWith("image/") ||
        file.mimetype === "application/pdf") {
        cb(null, true);
    }
    else {
        cb(null, false);
        cb(new Error("Invalid file type. Only images,  and PDFs are supported!"));
    }
};
export const upload = multer({
    storage,
    fileFilter,
    limits: { fileSize: 5 * 1024 * 1024 },
});
export const uploadToCloudinary = (fileBuffer, folderName = "devvault_uploads") => {
    return new Promise((resolve, reject) => {
        const uploadStream = cloudinary.uploader.upload_stream({ folder: folderName }, (error, result) => {
            if (error)
                return reject(error);
            resolve(result);
        });
        uploadStream.end(fileBuffer);
    });
};
//# sourceMappingURL=upload.middleware.js.map