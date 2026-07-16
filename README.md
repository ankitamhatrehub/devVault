# Dev Vault

> Dev Vault is a full-stack developer workspace combining a TypeScript/Node backend and a Flutter frontend app. Build your portfolio, track tasks, manage projects, and organize your learning journey—all in one place.

## Contents

- `backend/` — Node + TypeScript backend (APIs, authentication, services)
- `frontend/dev_vault/` — Flutter application (mobile & desktop targets)

For detailed component documentation, see `backend/BACKEND_README.md` and `frontend/FRONTEND_README.md`.

## Features

### Core Features
- **Authentication** — JWT-based user authentication and session management
- **Resume Management** — Upload, download, and manage your resume with Cloudinary integration
- **Task Management** — Create, track, and manage tasks with priority and progress tracking
- **Project Tracking** — Build and manage your projects with status and deadlines
- **Learning Tracker** — Track your learning resources and progress
- **Interview Prep** — Prepare for interviews with dedicated tracking
- **Profile Management** — Manage your professional profile
- **Notes** — Create and organize notes for quick reference
- **Dashboard** — Overview of your activity, progress, and quick actions

### Recent Additions
- ✨ **Resume PDF Download** — Download your resume from Cloudinary with backend file proxying
- 🔒 **Enhanced Security** — Improved Cloudinary integration with proper authorization
- 📱 **Responsive UI** — Optimized icon sizes and responsive layouts

## Tech Stack

- **Backend**: Node.js, TypeScript, Express, MongoDB
- **Frontend**: Flutter (Dart), Provider for state management
- **Storage**: Cloudinary for file uploads
- **Database**: MongoDB

## Prerequisites

- Node.js (LTS)
- npm or yarn
- Flutter SDK (stable)
- MongoDB (local or cloud)
- Cloudinary account (for file uploads)

## Quickstart

### Backend Setup

```bash
cd backend
npm install

# Create .env file with required configuration
cat > .env << EOF
# Database
MONGO_URI=mongodb.....

# JWT
JWT_SECRET=your-jwt-secret-key-here.....
JWT_EXPIRE=30d....

# Cloudinary
CLOUDINARY_CLOUD_NAME=your-cloud-name...
CLOUDINARY_API_KEY=your-api-key...
CLOUDINARY_API_SECRET=your-api-secret..

# Server
PORT=3000
NODE_ENV=development
EOF

# Run development server
npm start
```

Server runs on `http://localhost:3000`

### Frontend Setup

```bash
cd frontend/dev_vault
flutter pub get

# Run on connected device/emulator
flutter run

# Build APK for Android
flutter build apk --release

# Build for web
flutter build web
```

### Cloudinary Configuration

1. **Create a Cloudinary account** at 
2. **Enable PDF delivery** in Security settings:
   - Go to Settings → Security
   - Check "Allow delivery of PDF and ZIP files"
   - Uncheck "Resource list" under Restricted image types
   - Save changes
3. **Configure in backend .env**:
   - Add `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`

## Project Structure

```
backend/src/
├── authentication/      # Auth controller, service, routes
├── resume/             # Resume upload/download API
├── tasks/              # Task management API
├── projects/           # Project tracking API
├── learning/           # Learning tracker API
├── interview/          # Interview prep API
├── notes/              # Notes API
├── profile/            # Profile management API
├── dashboard/          # Dashboard API
├── middleware/         # Auth, error handling, upload middleware
├── config/             # Database, Cloudinary, logger config
└── routes.ts           # Route aggregation

frontend/dev_vault/lib/
├── data/
│   ├── services/       # API service layer (ResumeService, TasksService, etc.)
│   ├── models/         # Data models
│   └── constant_urls.dart
├── features/
│   ├── resume/         # Resume upload/download UI
│   ├── tasks/          # Task management UI
│   ├── projects/       # Project tracking UI
│   └── ...
├── core/
│   ├── theme/          # App styling and theme
│   ├── config/         # Router configuration
│   └── widgets/        # Reusable widgets
└── main.dart
```

## Environment & Configuration

### Backend Configuration

Update `backend/.env` with:
- **MongoDB**: Connection URI
- **JWT**: Secret key and expiration
- **Cloudinary**: API credentials
- **Server**: Port and environment

### Frontend Configuration

Edit `frontend/dev_vault/lib/data/constant_urls.dart`:
```dart
const String baseUrl = "";
```

Update the base URL to match your backend server.

## Key APIs

### Resume Endpoints
- `GET /api/resume/getResume` — Get resume metadata
- `POST /api/resume/uploadResume` — Upload resume file
- `PUT /api/resume/updateResume` — Update resume info
- `DELETE /api/resume/deleteResume` — Delete resume
- `GET /api/resume/downloadResume` — Download resume file (proxied through backend)

### Authentication
- `POST /api/auth/register` — Register new user
- `POST /api/auth/login` — Login user
- `POST /api/auth/logout` — Logout user

### Other Features
- Tasks, Projects, Learning, Interviews, Notes, Profile APIs follow similar patterns

## Development Workflow

1. **Create a feature branch**: `git checkout -b feature/your-feature`
2. **Make changes** in `backend/src/` or `frontend/dev_vault/lib/`
3. **Backend**: Changes auto-compile with `npm start` (tsx watches files)
4. **Frontend**: Hot reload with `flutter run`
5. **Commit changes**: `git add . && git commit -m "meaningful message"`
6. **Push and create PR**: `git push origin feature/your-feature`

## Testing

### Backend
```bash
cd backend
npm test
```

### Frontend
```bash
cd frontend/dev_vault
flutter test
```

## Contributing

1. Create an issue describing your change or feature
2. Create a branch for your work: `git checkout -b feature/xyz`
3. Add tests where applicable
4. Keep changes focused and commit messages clear
5. Open a pull request for review

## License

This repository does not include a license file. Add an appropriate `LICENSE` if you plan to publish or share the code.
