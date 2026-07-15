export declare const registerService: (name: string, email: string, password: string, confirmPassword: string) => Promise<{
    user: {
        userId: import("mongoose").Types.ObjectId;
        name: string | undefined;
        email: string;
        createdAt: NativeDate;
    };
}>;
export declare const loginService: (email: string, password: string) => Promise<{
    user: {
        userId: import("mongoose").Types.ObjectId;
        name: string | undefined;
        email: string;
        createdAt: NativeDate;
    };
    token: string;
}>;
//# sourceMappingURL=auth.service.d.ts.map