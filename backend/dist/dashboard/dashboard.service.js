import ProjectsModel from "../projects/projects.model.js";
import TasksModel from "../tasks/tasks.model.js";
import LearningModel from "../learning/learning.model.js";
import { logger } from "../config/logger.js";
export const getDashboardService = async (userId) => {
    try {
        logger.info("Dashboard API called for user => " + userId);
        const today = new Date().toISOString().split("T")[0];
        const [totalProjects, activeProjects, completedTasks, pendingTasks, learningCount, todayFocusTask, oldestPendingTask, recentProjects, recentTasks] = await Promise.all([
            ProjectsModel.countDocuments({ userId, deletedAt: null }),
            ProjectsModel.countDocuments({ userId, status: "Active", deletedAt: null }),
            TasksModel.countDocuments({ userId, status: "Completed", deletedAt: null }),
            TasksModel.countDocuments({ userId, status: "Pending", deletedAt: null }),
            LearningModel.countDocuments({ userId, deletedAt: null }),
            TasksModel.findOne({ userId, dueDate: today, status: "Pending", deletedAt: null }).sort({ createdAt: -1 }).limit(1),
            TasksModel.findOne({ userId, status: "Pending", deletedAt: null }).sort({ createdAt: 1 }).limit(1),
            ProjectsModel.find({ userId, deletedAt: null })
                .select("projectName summary status deadline progress createdAt")
                .sort({ createdAt: -1 })
                .limit(5),
            TasksModel.find({ userId, deletedAt: null })
                .select("title description status priority dueDate progress createdAt")
                .sort({ createdAt: -1 })
                .limit(5),
        ]);
        const todayFocus = todayFocusTask || oldestPendingTask || null;
        logger.info("Dashboard fetched successfully for user => " + userId);
        return {
            totalProjects,
            activeProjects,
            completedTasks,
            pendingTasks,
            learningCount,
            todayFocus,
            recentProjects,
            recentTasks,
        };
    }
    catch (error) {
        logger.error("Dashboard fetch failed => " + error);
        throw Error("Failed to fetch dashboard data");
    }
};
//# sourceMappingURL=dashboard.service.js.map