import mongoose from "mongoose";
const StepSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        trim: true,
    },
    isCompleted: {
        type: Boolean,
        default: false,
    },
});
const LearningSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "user",
        required: true,
    },
    title: {
        type: String,
        required: true,
        trim: true,
    },
    des: {
        type: String,
        required: true,
    },
    category: {
        type: String,
        required: true,
        trim: true,
    },
    status: {
        type: String,
        required: true,
        trim: true,
    },
    priority: {
        type: String,
        required: true,
        trim: true,
    },
    startDate: {
        type: String,
        required: true,
    },
    targetDate: {
        type: String,
        required: true,
    },
    steps: {
        type: [StepSchema],
        default: [],
    },
    deletedAt: {
        type: Date,
        default: null,
    },
}, {
    timestamps: true,
});
const LearningModel = mongoose.model("learning", LearningSchema);
export default LearningModel;
//# sourceMappingURL=learning.model.js.map