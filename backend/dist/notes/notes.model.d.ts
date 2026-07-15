import mongoose from "mongoose";
declare const NotesModel: mongoose.Model<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}, {}, {}, {}, mongoose.Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
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
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}, mongoose.Document<unknown, {}, mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}>> & mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}> & {
    _id: mongoose.Types.ObjectId;
}>>;
export default NotesModel;
//# sourceMappingURL=notes.model.d.ts.map