# DevVault Frontend - README

## 📱 App Overview

**DevVault** is a comprehensive Flutter multi-platform application designed to help developers track and manage their career journey. The app integrates tools for project management, learning progress tracking, task organization, interview preparation, and note-taking in a single, unified workspace.

### Target Users
- Software developers wanting to track their career growth
- Tech professionals managing multiple projects
- Learners documenting their learning journey
- Interview candidates preparing for interviews

---

## ✨ Key Features

### 1. **Dashboard** 📊
- Quick overview of career progress
- Learning streak counter
- Active projects count
- Today's focus card with progress tracking
- Quick action buttons (Write note, Practice interview)
- Recent projects preview
- Today's tasks preview
- **Navigation Route:** `/dashboard`

### 2. **Projects Management** 🚀
- **CRUD Operations:** Create, Read, Update, Delete projects
- **Project Properties:**
  - Name, Summary, Status
  - Technology Stack
  - Team Members Count
  - Deadline Date
  - Progress Percentage (0-100%)
  - Tags for categorization
  - Project Notes
- **Features:**
  - Search and filter projects
  - View detailed project information
  - Edit project details
  - Delete with undo option
  - Success notifications
  - Loading skeletons
- **Navigation Route:** `/projects`

### 3. **Tasks Management** ✅
- **CRUD Operations:** Create, Read, Update, Delete tasks
- **Task Properties:**
  - Title, Description
  - Priority (High/Medium/Low) - Color coded
  - Status (Pending/In Progress/Completed)
  - Due Date
  - Category (Learning/Project/Interview/Personal)
  - Progress Percentage
  - Created timestamp
- **Features:**
  - Search and filter tasks
  - Priority-based color coding
  - Progress tracking with slider
  - Dirty state tracking (unsaved changes warning)
  - Success messages on save
  - Loading states with skeleton screens
- **Navigation Route:** `/tasks`

### 4. **Notes** 📝
- **CRUD Operations:** Create, Read, Update, Delete notes
- **Note Properties:**
  - Title, Content (max 280 characters)
  - Category (Career/Learning/Planning)
  - Pin/Unpin functionality
  - Last updated timestamp
  - Decisions section (coming soon)
- **Features:**
  - Search notes by title, content, or category
  - Pin important notes
  - Archive instead of delete
  - Undo archive option
  - Success notifications
- **Navigation Route:** `/notes`

### 5. **Learning Roadmap** 📚
- Learning resource links and materials
- Learning progress visualization
- Resource categories
- Coming Soon Features:
  - Completion tracking
  - Progress milestones
- **Navigation Route:** `/learning`

### 6. **Interview Questions** 🎯
- Interview prep questions database
- Question categories
- Difficulty levels
- Practice tracking
- Coming Soon Features:
  - Video solutions
  - Community solutions
- **Navigation Route:** `/interview-questions`

### 7. **Profile** 👤
- User information display
- Account settings (Coming soon)
- Change password (Coming soon)
- Logout functionality
- **Navigation Route:** `/profile`

### 8. **Authentication** 🔐
- **Screens:**
  - Login Screen
  - Sign Up Screen
  - Forgot Password Screen
  - OTP Verification
  - Reset Password Screen
  - Change Password Screen
  - Auth Success Screen
- **Features:**
  - Email & password authentication
  - Form validation
  - OTP verification
  - Password reset flow
  - PopScope for proper back button handling
- **Routes:**
  - `/login` - User login
  - `/signup` - New account creation
  - `/forgot-password` - Initiate password reset
  - `/otp-verification` - Verify OTP code
  - `/reset-password` - Set new password
  - `/change-password` - Change existing password

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── app_router.dart          # GoRouter navigation configuration
│   ├── theme/
│   │   └── app_theme.dart           # Material Design 3 theme, colors, spacing
│   └── widgets/
│       ├── widgets.dart             # Barrel export
│       ├── app_button.dart          # Reusable button component
│       ├── app_card.dart            # Reusable card component
│       ├── app_text_field.dart      # Reusable text field
│       └── coming_soon_badge.dart   # Coming soon feature badge
│
├── features/
│   ├── authentication/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_screen.dart           # Login screen wrapper
│   │       │   ├── (Signup, Forgot, OTP, etc.) # Screen wrappers
│   │       │   └── auth_success_screen.dart
│   │       └── widgets/
│   │           ├── auth_scaffold.dart          # Shared auth page scaffold
│   │           ├── auth_forms.dart             # All form implementations
│   │           └── widgets.dart                # Barrel export
│   │
│   ├── dashboard/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── dashboard_screen.dart       # Main dashboard (140 lines)
│   │       └── widgets/
│   │           ├── dashboard_widgets.dart      # MetricCard, GlassCard, etc.
│   │           └── (No separate export needed)
│   │
│   ├── projects/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── projects_screen.dart        # Main projects list (220 lines)
│   │       │   ├── project_detail_screen.dart  # Project details view
│   │       │   └── project_form_screen.dart    # Create/Edit form
│   │       └── widgets/
│   │           ├── project_tile.dart           # Reusable project card
│   │           ├── detail_widgets.dart         # DetailCard, InfoRow
│   │           ├── project_empty_and_loader.dart # Skeleton, empty state
│   │           └── widgets.dart                # Barrel export
│   │
│   ├── tasks/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── tasks_screen.dart           # Main tasks list (270 lines)
│   │       │   ├── task_detail_screen.dart     # Task details view
│   │       │   └── task_form_screen.dart       # Create/Edit form
│   │       └── widgets/
│   │           ├── task_tile.dart              # Reusable task card
│   │           ├── detail_widgets.dart         # DetailCard, InfoRow
│   │           ├── task_empty_and_loader.dart  # Skeleton, empty state
│   │           └── widgets.dart                # Barrel export
│   │
│   ├── notes/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── notes_screen.dart           # Main notes list (240 lines)
│   │       │   ├── note_detail_screen.dart     # Note details view
│   │       │   └── note_form_screen.dart       # Create/Edit form
│   │       └── widgets/
│   │           ├── note_tile.dart              # Reusable note card
│   │           ├── note_empty_and_loader.dart  # Skeleton, empty state
│   │           └── widgets.dart                # Barrel export
│   │
│   ├── learning_roadmap/
│   │   └── presentation/
│   │       └── pages/
│   │           └── learning_roadmap_screen.dart
│   │
│   ├── interview_questions/
│   │   └── presentation/
│   │       └── pages/
│   │           └── interview_questions_screen.dart
│   │
│   ├── profile/
│   │   └── presentation/
│   │       └── pages/
│   │           └── profile_screen.dart
│   │
│   └── main_shell/
│       └── presentation/
│           └── pages/
│               └── main_shell.dart             # Bottom navigation shell
│
└── main.dart                        # App entry point
```

---

## 🎨 Design System

### Colors (from app_theme.dart)
- **Primary:** Accent blue
- **Secondary:** Accent teal  
- **Success:** Green (for confirmations)
- **Warning:** Orange (for cautions)
- **Danger:** Red (for destructive actions)
- **Surface:** Light background
- **Border:** Light gray

### Spacing System
- `xs`: 4px
- `sm`: 8px
- `md`: 16px
- `lg`: 24px
- `xl`: 32px

### Border Radius
- `small`: 8px
- `medium`: 12px
- `large`: 16px
- `pill`: 999px (full rounded)

---

## 🔄 Navigation Architecture

### GoRouter Configuration
- **Tab Navigation:** `context.go()` - switches tabs
- **Screen Navigation:** `context.push()` - adds to stack (shows back button)
- **Back Navigation:** `context.pop()` - returns to previous screen

### Bottom Navigation Tabs
1. Dashboard `/dashboard`
2. Projects `/projects`
3. Learning `/learning`
4. Notes `/notes`
5. Profile `/profile`

---

## 📊 Data Models

### ProjectItem
```dart
{
  id: String,
  name: String,
  summary: String,
  status: String (Planning/In Progress/In Review/Completed),
  progress: double (0.0 - 1.0),
  stack: String (comma-separated tech),
  deadline: String (date),
  team: String,
  tags: List<String>,
  updatedAt: String,
  notes: String
}
```

### TaskItem
```dart
{
  id: String,
  title: String,
  description: String,
  priority: String (High/Medium/Low),
  progress: double (0.0 - 1.0),
  dueDate: String (date),
  status: String (Pending/In Progress/Completed),
  category: String (Learning/Project/Interview/Personal),
  createdAt: String
}
```

### NoteItem
```dart
{
  id: String,
  title: String,
  body: String,
  category: String (Career/Learning/Planning),
  updatedAt: String,
  pinned: bool
}
```

---

## ✨ Code Quality Metrics

### Line Count Reduction
| Component | Before | After | Reduction |
|-----------|--------|-------|-----------|
| Projects | 1191 | 220 | 82% |
| Tasks | 1019 | 270 | 73% |
| Notes | 763 | 240 | 69% |
| Dashboard | 504 | 140 | 72% |
| Login | 472 | 143 | 70% |
| **Total** | **3949** | **1013** | **74%** |

### Architecture Patterns
✅ Feature-based folder structure  
✅ Separation of concerns (screen/detail/form)  
✅ Reusable widget components  
✅ Barrel exports for clean imports  
✅ PopScope for modern back button handling  
✅ Material Design 3 compliance  
✅ Empty states & loading skeletons  
✅ Success notifications on CRUD operations  

---

## 🚀 Running the App

### Prerequisites
- Flutter SDK (latest)
- Dart SDK
- iOS: Xcode 12.0+
- Android: Android SDK 21+

### Installation
```bash
flutter pub get
flutter run
```

### Platform-Specific
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d web
```

---

## 📝 Known Limitations / Coming Soon

- ⏳ Timeline view
- ⏳ Attachments on projects/notes
- ⏳ Share functionality
- ⏳ Decisions section in notes
- ⏳ Settings screen
- ⏳ Video solutions for interview questions
- ⏳ Community solutions for questions

---

## 🔗 Integration Points

The frontend is ready to connect to backend APIs. See `BACKEND_README.md` for API specifications and data structure requirements.

### Currently Using
- Hardcoded sample data
- Local state management (StatefulWidget, setState)
- Navigator for modal navigation
- GoRouter for tab navigation

### Ready for Integration
- All CRUD operations have success message hooks
- Loading states prepared for async operations
- Error handling structure in place
- Form validation ready for API responses

---

## 📚 Additional Resources

- Flutter Documentation: https://flutter.dev
- GoRouter Package: https://pub.dev/packages/go_router
- Material Design 3: https://m3.material.io/

---

## 👨‍💻 Developer Notes

- **State Management:** Ready to migrate to BLoC/Riverpod when backend APIs are ready
- **Testing:** Unit tests for models, widget tests for components, integration tests for flows
- **Performance:** Using ListView.separated for efficient list rendering, skeleton loaders for perceived performance
- **Accessibility:** Material Design 3 follows WCAG guidelines

---

**Last Updated:** 2026-07-03  
**Status:** ✅ Feature Complete (Frontend Only)
