import mongoose from "mongoose";
declare const TasksModel: mongoose.Model<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
}, {}, {}, {}, mongoose.Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
} & {
    _id: mongoose.Types.ObjectId;
}, mongoose.Schema<any, mongoose.Model<any, any, any, any, any, any>, {}, {}, {}, {}, {
    timestamps: true;
}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
}, mongoose.Document<unknown, {}, mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
}>> & mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
}> & {
    _id: mongoose.Types.ObjectId;
}>>;
export default TasksModel;
//# sourceMappingURL=tasks.model.d.ts.map