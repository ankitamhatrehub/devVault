export declare const createNoteService: (userId: string, noteData: {
    title: string;
    body: string;
    category: string;
    pinned?: boolean;
}) => Promise<import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
} & {
    _id: import("mongoose").Types.ObjectId;
}>;
export declare const getAllNotesService: (userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
} & {
    _id: import("mongoose").Types.ObjectId;
})[]>;
export declare const getNoteByIdService: (noteId: string, userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
export declare const updateNoteService: (noteId: string, userId: string, updateData: {
    title?: string;
    body?: string;
    category?: string;
    pinned?: boolean;
}) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
export declare const deleteNoteService: (noteId: string, userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    userId: import("mongoose").Types.ObjectId;
    title: string;
    category: string;
    deletedAt: Date;
    body: string;
    pinned: boolean;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
//# sourceMappingURL=notes.service.d.ts.map