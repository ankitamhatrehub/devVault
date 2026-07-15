export declare const getprofileService: (userId: string) => Promise<(import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    email: string;
    password: string;
    name?: string | undefined;
    bio?: string | undefined;
    designation?: string | undefined;
    experience?: string | undefined;
    currentComapny?: string | undefined;
    location?: string | undefined;
    avatar?: {
        url: string;
        publicId: string;
    } | undefined;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    email: string;
    password: string;
    name?: string | undefined;
    bio?: string | undefined;
    designation?: string | undefined;
    experience?: string | undefined;
    currentComapny?: string | undefined;
    location?: string | undefined;
    avatar?: {
        url: string;
        publicId: string;
    } | undefined;
} & {
    _id: import("mongoose").Types.ObjectId;
}) | null>;
export declare const updateprofileService: (userId: string, updateData: {
    name: string;
    email: string;
    bio?: string;
    designation: string;
    experience: string;
    currentComapny?: string;
    location: string;
}) => Promise<import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    email: string;
    password: string;
    name?: string | undefined;
    bio?: string | undefined;
    designation?: string | undefined;
    experience?: string | undefined;
    currentComapny?: string | undefined;
    location?: string | undefined;
    avatar?: {
        url: string;
        publicId: string;
    } | undefined;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    email: string;
    password: string;
    name?: string | undefined;
    bio?: string | undefined;
    designation?: string | undefined;
    experience?: string | undefined;
    currentComapny?: string | undefined;
    location?: string | undefined;
    avatar?: {
        url: string;
        publicId: string;
    } | undefined;
} & {
    _id: import("mongoose").Types.ObjectId;
}>;
export declare const changePasswordProfile: (userId: string) => Promise<void>;
//# sourceMappingURL=profile.service.d.ts.map