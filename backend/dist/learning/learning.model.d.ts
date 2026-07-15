import mongoose from "mongoose";
declare const LearningModel: mongoose.Model<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: mongoose.Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}, {}, {}, {}, mongoose.Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: mongoose.Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: mongoose.Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
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
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: mongoose.Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}, mongoose.Document<unknown, {}, mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: mongoose.Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}>> & mongoose.FlatRecord<{
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: mongoose.Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: mongoose.Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}> & {
    _id: mongoose.Types.ObjectId;
}>>;
export default LearningModel;
//# sourceMappingURL=learning.model.d.ts.map