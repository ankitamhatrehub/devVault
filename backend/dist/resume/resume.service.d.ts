export declare const getResumeService: (userId: string) => Promise<import("mongoose").Document<unknown, {}, {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: import("mongoose").Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
}> & {
    createdAt: NativeDate;
    updatedAt: NativeDate;
} & {
    publicId: string;
    userId: import("mongoose").Types.ObjectId;
    fileName: string;
    fileUrl: string;
    fileSize: string;
} & {
    _id: import("mongoose").Types.ObjectId;
}>;
interface UpdateResumePayload {
    fileName: string;
    fileUrl: string;
    fileSize: string;
    publicId: string;
}
interface ServiceResponse<Data = any> {
    success: boolean;
    data?: Data;
    error?: string;
}
export declare const updateResumeService: (userId: string, payload: UpdateResumePayload) => Promise<ServiceResponse>;
export declare const deleteResumeService: (userId: string) => Promise<ServiceResponse>;
export declare const downloadResumeService: (userId: string) => Promise<ServiceResponse>;
export {};
//# sourceMappingURL=resume.service.d.ts.map