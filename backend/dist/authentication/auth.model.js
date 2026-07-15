import mongoose from "mongoose";
const AuthSchema = new mongoose.Schema({
    name: {
        type: String,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        trim: true,
    },
    password: {
        type: String,
        required: true,
        trim: true,
    },
    bio: {
        type: String,
        trim: true,
    },
    designation: {
        type: String,
        trim: true,
    },
    experience: {
        type: String,
        trim: true,
    },
    currentComapny: {
        type: String,
        trim: true,
    },
    location: {
        type: String,
        trim: true,
    },
    avatar: {
        url: {
            type: String,
            default: "",
        },
        publicId: {
            type: String,
            default: "",
        },
    },
}, {
    timestamps: true,
});
const schema = mongoose.model("user", AuthSchema);
export default schema;
//# sourceMappingURL=auth.model.js.map