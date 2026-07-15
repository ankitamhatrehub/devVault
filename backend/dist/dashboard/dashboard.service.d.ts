interface DashboardResponse {
    totalProjects: number;
    activeProjects: number;
    completedTasks: number;
    pendingTasks: number;
    learningCount: number;
    todayFocus: any;
    recentProjects: any[];
    recentTasks: any[];
}
export declare const getDashboardService: (userId: string) => Promise<DashboardResponse>;
export {};
//# sourceMappingURL=dashboard.service.d.ts.map