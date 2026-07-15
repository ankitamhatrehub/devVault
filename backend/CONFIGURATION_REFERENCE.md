# Backend Configuration - Quick Reference

## Final tsconfig.json

This is the optimized configuration for Node.js v24 with ESM and TypeScript.

```json
{
  "compilerOptions": {
    // File Layout - Enable source and output directories
    "rootDir": "./src",
    "outDir": "./dist",

    // Environment Settings for Node.js ESM
    "module": "ESNext",
    "moduleResolution": "Node",
    "target": "ES2022",
    "lib": ["ES2022"],
    "types": ["node"],

    // ESM Import Resolution and Interop
    "resolveJsonModule": true,
    "allowJs": true,
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,

    // Output Options
    "sourceMap": true,
    "declaration": true,
    "declarationMap": true,
    "removeComments": true,

    // TypeScript Strictness
    "strict": true,
    "noUnusedLocals": false,
    "noUnusedParameters": false,
    "noImplicitAny": false,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,

    // Module Syntax
    "isolatedModules": true,
    "allowImportingTsExtensions": false
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"],
  "ts-node": {
    "esm": true,
    "experimentalEsm": true
  }
}
```

### Key Configuration Explanations

**Module and Resolution:**
```json
"module": "ESNext",           // Outputs modern ESM syntax
"moduleResolution": "Node"    // Uses Node.js module resolution algorithm
```
These settings ensure TypeScript compiles to ESM modules that Node.js can properly resolve.

**Interoperability:**
```json
"allowSyntheticDefaultImports": true,  // Allows: import dotenv from "dotenv"
"esModuleInterop": true                // Handles CommonJS/ESM bridge
```
These allow you to use CommonJS-style imports with ESM modules, essential for libraries like Express and Mongoose.

**Flexibility:**
```json
"noUnusedLocals": false,       // Express middleware has unused params
"noUnusedParameters": false,   // Pattern: (req, res, next)
```
Express middleware patterns use unused parameters (e.g., `_req` in middleware that only needs `res`).

---

## Final package.json

```json
{
  "name": "dev_vault",
  "version": "1.0.0",
  "description": "Developer career tracking app backend",
  "license": "ISC",
  "author": "Ankita Mhatre",
  "type": "module",
  "main": "dist/app.js",
  "scripts": {
    "dev": "tsx watch src/app.ts",
    "build": "tsc",
    "start": "node dist/app.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "bcryptjs": "^2.4.3",
    "cloudinary": "^2.10.0",
    "cors": "^2.8.5",
    "dotenv": "^16.0.3",
    "express": "^4.18.2",
    "express-rate-limit": "^6.0.0",
    "express-validator": "^7.0.0",
    "helmet": "^7.0.0",
    "jsonwebtoken": "^9.0.0",
    "mongoose": "^7.0.0",
    "multer": "^2.2.0",
    "winston": "^3.19.0"
  },
  "devDependencies": {
    "@types/bcryptjs": "^2.4.2",
    "@types/cors": "^2.8.13",
    "@types/express": "^4.17.17",
    "@types/jsonwebtoken": "^9.0.2",
    "@types/logger": "^0.0.5",
    "@types/multer": "^2.2.0",
    "@types/node": "^20.0.0",
    "nodemon": "^3.0.1",
    "ts-node": "^10.9.1",
    "tsx": "^3.12.0",
    "typescript": "^5.0.0"
  }
}
```

### Key Explanations

**ESM Entry Point:**
```json
"type": "module",      // Enables ESM globally for .js files
"main": "dist/app.js"  // Entry point for production
```

**Scripts:**
```json
"dev": "tsx watch src/app.ts"   // Development with tsx (TypeScript runner)
"build": "tsc"                   // Compile TypeScript to JavaScript
"start": "node dist/app.js"      // Run compiled ESM modules
```

---

## Sample Import Patterns

### Pattern 1: Local File Imports (Must have .js)

**File: src/app.ts**
```typescript
// ✅ CORRECT - With .js extension
import { connectDB } from "./config/db.js";
import router from "./routes.js";

// ❌ WRONG - Without .js extension (will fail at runtime)
import { connectDB } from "./config/db";
import router from "./routes";
```

**Compiled to: dist/app.js**
```javascript
import { connectDB } from "./config/db.js";  // ✅ .js preserved
import router from "./routes.js";            // ✅ .js preserved
```

### Pattern 2: Third-Party Packages (No .js needed)

**File: src/app.ts**
```typescript
import express from "express";              // ✅ CORRECT
import dotenv from "dotenv";                // ❌ WRONG (use named import)
import { config as loadEnv } from "dotenv"; // ✅ CORRECT
import path from "path";                    // ✅ CORRECT
```

**Compiled to: dist/app.js**
```javascript
import express from "express";
import { config as loadEnv } from "dotenv";
import path from "path";
```

### Pattern 3: Named Exports from Local Files

**File: src/config/logger.ts**
```typescript
export const logger = winston.createLogger({
  level: "info",
  format: combine(timestamp({ format: "YYYY-MM-DD HH:mm:ss" }), myFormat),
  transports: [new winston.transports.Console()],
});
```

**Using in: src/config/db.ts**
```typescript
import { logger } from "../config/logger.js";  // ✅ .js extension required
```

---

## Directory Structure

```
backend/
├── src/
│   ├── app.ts                    # Main entry point
│   ├── routes.ts                 # Route aggregation
│   ├── config/
│   │   ├── db.ts                 # MongoDB connection
│   │   ├── cloudinary.ts         # Image upload config
│   │   └── logger.ts             # Winston logging
│   ├── middleware/
│   │   ├── auth.middleware.ts    # JWT verification
│   │   ├── upload.middleware.ts  # Multer file upload
│   │   └── error.middleware.ts   # Error handling
│   ├── authentication/
│   ├── tasks/
│   ├── notes/
│   ├── learning/
│   ├── projects/
│   ├── profile/
│   ├── resume/
│   ├── dashboard/
│   └── imageUpload/
│
├── dist/                          # Compiled output (generated by tsc)
│   ├── app.js                    # Compiled main entry point
│   ├── app.js.map                # Source map for debugging
│   ├── routes.js
│   └── ... (all compiled files with .js extensions)
│
├── node_modules/                 # Dependencies (npm install)
├── package.json                  # Project metadata and dependencies
├── package-lock.json             # Dependency lock file
├── tsconfig.json                 # TypeScript configuration (shown above)
├── .env                          # Environment variables (not in git)
├── .env.example                  # Example environment variables
├── ESM_REFACTORING_GUIDE.md      # Detailed technical documentation
├── REFACTORING_SUMMARY.md        # Deployment guide and checklist
└── CONFIGURATION_REFERENCE.md    # This file
```

---

## Environment Variables (.env)

**Required for development and production:**

```bash
# Database Connection
MONGODB_URL=mongodb+srv://username:password@cluster.mongodb.net/devvault

# Server Configuration
PORT=3000
NODE_ENV=development

# Cloudinary (Image Upload Service)
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret

# Authentication
JWT_SECRET=your_super_secret_jwt_key_min_32_chars

# CORS Configuration (if frontend on different domain)
CORS_ORIGIN=http://localhost:3001

# Optional: Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

**For Render deployment, set these in the Render dashboard:**
1. Go to Web Service settings
2. Environment tab
3. Add each variable
4. Keep sensitive values private

---

## Build Process

### Step 1: Development
```bash
# Install dependencies
npm install

# Run in development mode (auto-reload)
npm run dev

# TypeScript runs via tsx, watches for changes
# http://localhost:3000
```

### Step 2: Build for Production
```bash
# Compile TypeScript to JavaScript
npm run build

# Output in dist/ folder with .js extensions
# Type definitions (.d.ts) generated
# Source maps (.js.map) generated for debugging
```

### Step 3: Run Production Build
```bash
# Run compiled JavaScript
npm start

# Starts from dist/app.js
# Server listens on PORT (default 3000)
```

---

## Verification Commands

### Check TypeScript Configuration
```bash
# Verify tsconfig.json is valid
npx tsc --version
npx tsc --noEmit  # Dry run - checks for errors without emitting

# Show resolved configuration
npx tsc --showConfig
```

### Check for Missing .js Extensions
```bash
# Find any local imports without .js extension
grep -r "from ['\"]\./" backend/src --include="*.ts" | grep -v "\.js"

# Should return empty result (no matches)
```

### Verify Build Output
```bash
# Check compiled files have .js extensions
ls -la backend/dist/*.js

# Check a specific file
cat backend/dist/app.js | grep "from"

# Should show: import { ... } from "./config/db.js"
```

### Test Runtime
```bash
# Build
npm run build

# Run
npm start

# Should see:
# ✅ Server is running on http://localhost:3000
# ✅ MongoDB Connected Successfully (if DB configured)
```

---

## Troubleshooting Quick Reference

| Error | Cause | Solution |
|-------|-------|----------|
| `ERR_MODULE_NOT_FOUND` | Missing .js extension | Add .js to local imports |
| `ERR_UNKNOWN_FILE_EXTENSION` | Wrong module setting | Set `"module": "ESNext"` in tsconfig.json |
| Import resolution fails | Wrong moduleResolution | Set `"moduleResolution": "Node"` |
| "Cannot find module X" | Third-party not installed | Run `npm install X` |
| TypeScript compilation errors | Outdated tsconfig | Use the provided tsconfig.json |

---

## Node.js Version Compatibility

- **Required:** Node.js v24+ (as specified in your project)
- **Recommended:** Latest LTS or latest stable
- **Check installed version:** `node --version`

---

## Next Steps

1. **Local Testing:**
   ```bash
   npm run dev
   ```

2. **Build and Test:**
   ```bash
   npm run build
   npm start
   ```

3. **Deploy to Render:**
   - See REFACTORING_SUMMARY.md for step-by-step guide

4. **Monitor Production:**
   - Check Render logs for errors
   - Test API endpoints
   - Monitor performance

---

**All configuration is production-ready. No further changes to tsconfig.json or package.json should be needed.**
