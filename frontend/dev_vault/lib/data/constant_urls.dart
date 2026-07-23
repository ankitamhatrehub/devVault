const String baseUrl = "http://192.168.0.105:3000/api/";
// const String baseUrl = "https://devvault-mlld.onrender.com/api/";

//authentication urls
const String registerUrl = "${baseUrl}auth/register";
const String loginUrl = "${baseUrl}auth/login";

//profile urls
const String getProfileUrl = "${baseUrl}profile/getProfile";
const String editProfileUrl = "${baseUrl}profile/editProfile";
const String changePasswordUrl = "${baseUrl}profile/change-password";
const String uploadProfileImageUrl = "${baseUrl}profile/upload";

//projects urls
const String createProjectUrl = "${baseUrl}projects/createProject";
const String getAllProjectsUrl = "${baseUrl}projects/getAllProjects";
const String getProjectByIdUrl = "${baseUrl}projects/"; // Append project ID
const String updateProjectUrl = "${baseUrl}projects/"; // Append project ID
const String deleteProjectUrl = "${baseUrl}projects/"; // Append project ID

//notes urls
const String createNoteUrl = "${baseUrl}notes/createNote";
const String getAllNotesUrl = "${baseUrl}notes/getAllNotes";
const String getNoteByIdUrl = "${baseUrl}notes/"; // Append note ID
const String updateNoteUrl = "${baseUrl}notes/"; // Append note ID
const String deleteNoteUrl = "${baseUrl}notes/"; // Append note ID

//tasks urls
const String createTaskUrl = "${baseUrl}tasks/createTask";
const String getAllTasksUrl = "${baseUrl}tasks/getAllTasks";
const String getTaskByIdUrl = "${baseUrl}tasks/"; // Append task ID
const String updateTaskUrl = "${baseUrl}tasks/"; // Append task ID
const String deleteTaskUrl = "${baseUrl}tasks/"; // Append task ID

//dashboard url
const String getDashboardUrl = "${baseUrl}dashboard/";

//learning urls
const String createLearningUrl = "${baseUrl}learning/createLearning";
const String getAllLearningsUrl = "${baseUrl}learning/getAllLearnings";
const String getLearningByIdUrl = "${baseUrl}learning/"; // Append learning ID
const String updateLearningUrl = "${baseUrl}learning/"; // Append learning ID
const String deleteLearningUrl = "${baseUrl}learning/"; // Append learning ID

//resume urls
const String getResumeUrl = "${baseUrl}resume/getResume";
const String updateResumeUrl = "${baseUrl}resume/updateResume";
const String deleteResumeUrl = "${baseUrl}resume/deleteResume";
const String downloadResumeUrl = "${baseUrl}resume/downloadResume";
const String uploadResumeUrl = "${baseUrl}resume/uploadResume";


// ai  urls 
const String sendAiChatMsgUrl = "${baseUrl}ai/sendChats";
const String getAiChatMsgUrl = "${baseUrl}ai/getChats";
