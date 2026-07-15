export declare const createLearningService: (userId: string, learningData: {
    title: string;
    des: string;
    category: string;
    status: string;
    priority: string;
    startDate: string;
    targetDate: string;
    steps?: {
        title: string;
        isCompleted?: boolean;
    }[];
}) => Promise<import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
} & {
    _id: import("mongoose").Types.ObjectId;
}>;
export declare const getAllLearningsService: (userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
} & {
    _id: import("mongoose").Types.ObjectId;
})[]>;
export declare const getLearningByIdService: (learningId: string, userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
export declare const updateLearningService: (learningId: string, userId: string, updateData: {
    title?: string;
    des?: string;
    category?: string;
    status?: string;
    priority?: string;
    startDate?: string;
    targetDate?: string;
    steps?: {
        title: string;
        isCompleted?: boolean;
    }[];
}) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
export declare const deleteLearningService: (learningId: string, userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    priority: string;
    status: string;
    category: string;
    deletedAt: Date;
    des: string;
    startDate: string;
    targetDate: string;
    steps: import("mongoose").Types.DocumentArray<{
        title: string;
        isCompleted: boolean;
    }>;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
//# sourceMappingURL=learning.service.d.ts.map