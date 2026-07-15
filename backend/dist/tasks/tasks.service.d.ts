export declare const createTaskService: (userId: string, taskData: {
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress?: number;
}) => Promise<import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
} & {
    _id: import("mongoose").Types.ObjectId;
}>;
export declare const getAllTasksService: (userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
} & {
    _id: import("mongoose").Types.ObjectId;
})[]>;
export declare const getTaskByIdService: (taskId: string, userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
export declare const updateTaskService: (taskId: string, userId: string, updateData: {
    title?: string;
    description?: string;
    priority?: string;
    status?: string;
    dueDate?: string;
    category?: string;
    progress?: number;
}) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
export declare const deleteTaskService: (taskId: string, userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
    title: string;
    description: string;
    priority: string;
    status: string;
    dueDate: string;
    category: string;
    progress: number;
    deletedAt: Date;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
//# sourceMappingURL=tasks.service.d.ts.map