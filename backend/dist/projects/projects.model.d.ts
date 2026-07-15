import mongoose from "mongoose";
declare const ProjectsModel: mongoose.Model<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    status: string;
    progress: number;
    deletedAt: Date;
    projectName: string;
    summary: string;
    primaryStack: string;
    deadline: string;
    teamSize: string;
    projectNotes: string;
    focusTags: string[];
}, {}, {}, {}, mongoose.Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    status: string;
    progress: number;
    deletedAt: Date;
    projectName: string;
    summary: string;
    primaryStack: string;
    deadline: string;
    teamSize: string;
    projectNotes: string;
    focusTags: string[];
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    status: string;
    progress: number;
    deletedAt: Date;
    projectName: string;
    summary: string;
    primaryStack: string;
    deadline: string;
    teamSize: string;
    projectNotes: string;
    focusTags: string[];
} & {
    _id: mongoose.Types.ObjectId;
}, mongoose.Schema<any, mongoose.Model<any, any, any, any, any, any>, {}, {}, {}, {}, {
    timestamps: true;
}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    status: string;
    progress: number;
    deletedAt: Date;
    projectName: string;
    summary: string;
    primaryStack: string;
    deadline: string;
    teamSize: string;
    projectNotes: string;
    focusTags: string[];
}, mongoose.Document<unknown, {}, mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    status: string;
    progress: number;
    deletedAt: Date;
    projectName: string;
    summary: string;
    primaryStack: string;
    deadline: string;
    teamSize: string;
    projectNotes: string;
    focusTags: string[];
}>> & mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    status: string;
    progress: number;
    deletedAt: Date;
    projectName: string;
    summary: string;
    primaryStack: string;
    deadline: string;
    teamSize: string;
    projectNotes: string;
    focusTags: string[];
}> & {
    _id: mongoose.Types.ObjectId;
}>>;
export default ProjectsModel;
//# sourceMappingURL=projects.model.d.ts.map