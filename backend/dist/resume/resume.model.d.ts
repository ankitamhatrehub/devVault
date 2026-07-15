import mongoose from "mongoose";
export declare const ResumeSchema: mongoose.Schema<any, mongoose.Model<any, any, any, any, any, any>, {}, {}, {}, {}, {
    timestamps: true;
}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: mongoose.Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
}, mongoose.Document<unknown, {}, mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: mongoose.Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
}>> & mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: mongoose.Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
}> & {
    _id: mongoose.Types.ObjectId;
}>;
declare const ResumeModel: mongoose.Model<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: mongoose.Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
}, {}, {}, {}, mongoose.Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: mongoose.Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: mongoose.Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
} & {
    _id: mongoose.Types.ObjectId;
}, mongoose.Schema<any, mongoose.Model<any, any, any, any, any, any>, {}, {}, {}, {}, {
    timestamps: true;
}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: mongoose.Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
}, mongoose.Document<unknown, {}, mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: mongoose.Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
}>> & mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: mongoose.Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
}> & {
    _id: mongoose.Types.ObjectId;
}>>;
export default ResumeModel;
//# sourceMappingURL=resume.model.d.ts.map