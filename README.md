
# Dev Vault

> Dev Vault is a full-stack developer workspace combining a TypeScript/Node backend and a Flutter frontend app. This repository contains utilities, feature modules, and example services to help you build, run, and extend the platform.

## Contents

- `backend/` — Node + TypeScript backend (APIs, authentication, services).
- `frontend/dev_vault/` — Flutter application (mobile & desktop targets).

For more detailed, component-level README files, see `backend/BACKEND_README.md` and `frontend/FRONTEND_README.md`.

## Tech Stack

- Backend: Node.js, TypeScript, Express-style routing
- Frontend: Flutter (Dart)

## Prerequisites

- Node.js (LTS)
- npm or yarn
- Flutter SDK (stable)
- A database or external services as required by the backend (configure via environment variables)

## Quickstart

Backend (development):

```bash
cd backend
npm install
# Copy or create .env and configure DB/keys
# Run in development (adjust command per backend README)
npm run dev
```

Frontend (Flutter app):

```bash
cd frontend/dev_vault
flutter pub get
flutter run
```

## Project Structure (high level)

- `backend/src/` — API routes and feature modules (auth, notes, projects, tasks, interviews, learning, profile)
- `frontend/dev_vault/lib/` — Flutter app code and features

## Environment & Configuration

- Backend expects environment configuration (DB connection, JWT secrets, etc.). See `backend/BACKEND_README.md` and `backend/src/config` for details.
- Frontend secrets or API base URLs can be configured in the Flutter app per platform build settings.

## Testing

- Backend: follow the commands in `backend/BACKEND_README.md` (if tests exist).
- Frontend: run `flutter test` from `frontend/dev_vault`.

## Contributing

If you'd like to contribute:

1. Open an issue describing the change or feature request.
2. Create a branch for your work.
3. Add tests where applicable and keep changes focused.
4. Open a pull request for review.

## License

This repository does not include a license file. Add an appropriate `LICENSE` if you plan to publish or share the code.

---

If you want, I can update this README with exact run commands from `backend/package.json` and any `.env` examples — tell me and I'll extract them and refine the instructions.
# dev_vault

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
