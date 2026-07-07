import ProjectsModel from "../projects/projects.model";
import TasksModel from "../tasks/tasks.model";
import LearningModel from "../learning/learning.model";
import { logger } from "../config/logger";

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

export const getDashboardService = async (userId: string): Promise<DashboardResponse> => {
  try {
    logger.info("Dashboard API called for user => " + userId);

    // Get today's date in YYYY-MM-DD format for task filtering
    const today = new Date().toISOString().split("T")[0];

    // Use Promise.all for parallel queries to improve performance
    const [totalProjects, activeProjects, completedTasks, pendingTasks, learningCount, todayFocusTask, oldestPendingTask, recentProjects, recentTasks] = await Promise.all([
      // Count total projects (excluding soft-deleted)
      ProjectsModel.countDocuments({ userId, deletedAt: null }),

      // Count active projects only
      ProjectsModel.countDocuments({ userId, status: "Active", deletedAt: null }),

      // Count completed tasks (assuming status = "Completed" or "Done")
      TasksModel.countDocuments({ userId, status: "Completed", deletedAt: null }),

      // Count pending tasks (assuming status = "Pending" or "In Progress")
      TasksModel.countDocuments({ userId, status: "Pending", deletedAt: null }),

      // Count total learning roadmaps
      LearningModel.countDocuments({ userId, deletedAt: null }),

      // Find today's pending task by dueDate
      TasksModel.findOne({ userId, dueDate: today, status: "Pending", deletedAt: null }).sort({ createdAt: -1 }).limit(1),

      // Find oldest pending task if today's task doesn't exist
      TasksModel.findOne({ userId, status: "Pending", deletedAt: null }).sort({ createdAt: 1 }).limit(1),

      // Fetch latest 5 projects
      ProjectsModel.find({ userId, deletedAt: null })
        .select("projectName summary status deadline progress createdAt")
        .sort({ createdAt: -1 })
        .limit(5),

      // Fetch latest 5 tasks
      TasksModel.find({ userId, deletedAt: null })
        .select("title description status priority dueDate progress createdAt")
        .sort({ createdAt: -1 })
        .limit(5),
    ]);

    // Determine today's focus: today's task or oldest pending task
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
  } catch (error) {
    logger.error("Dashboard fetch failed => " + error);
    throw Error("Failed to fetch dashboard data");
  }
};
