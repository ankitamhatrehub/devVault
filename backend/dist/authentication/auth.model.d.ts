import mongoose from "mongoose";
declare const schema: mongoose.Model<{
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
}, {}, {}, {}, mongoose.Document<unknown, {}, {
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
    _id: mongoose.Types.ObjectId;
}, mongoose.Schema<any, mongoose.Model<any, any, any, any, any, any>, {}, {}, {}, {}, {
    timestamps: true;
}, {
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
}, mongoose.Document<unknown, {}, mongoose.FlatRecord<{
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
}>> & mongoose.FlatRecord<{
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
    _id: mongoose.Types.ObjectId;
}>>;
export default schema;
//# sourceMappingURL=auth.model.d.ts.map