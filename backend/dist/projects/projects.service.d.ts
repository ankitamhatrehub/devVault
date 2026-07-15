export declare const createProjectService: (userId: string, projectData: {
    projectName: string;
    summary: string;
    primaryStack: string;
    status: string;
    deadline: string;
    teamSize: string;
    projectNotes: string;
    focusTags?: string[];
    progress?: number;
}) => Promise<import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
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
    _id: import("mongoose").Types.ObjectId;
}>;
export declare const getAllProjectsService: (userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
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
    _id: import("mongoose").Types.ObjectId;
})[]>;
export declare const getProjectByIdService: (projectId: string, userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
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
    _id: import("mongoose").Types.ObjectId;
}) | null>;
export declare const updateProjectService: (projectId: string, userId: string, updateData: {
    projectName?: string;
    summary?: string;
    primaryStack?: string;
    status?: string;
    deadline?: string;
    teamSize?: string;
    projectNotes?: string;
    focusTags?: string[];
    progress?: number;
}) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
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
    _id: import("mongoose").Types.ObjectId;
}) | null>;
export declare const deleteProjectService: (projectId: string, userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
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
    userId: import("mongoose").Types.ObjectId;
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
    _id: import("mongoose").Types.ObjectId;
}) | null>;
//# sourceMappingURL=projects.service.d.ts.map