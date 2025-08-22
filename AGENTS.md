# Agent Guidelines for SMC Marketing Website

## Project Structure
- Full-stack TypeScript application with Vite + React frontend and Express backend
- Frontend: `src/` with components, services, types directories
- Backend: `server/` with Express API endpoints
- Data: CSV files in `data/` directory (events.csv, blog-posts.csv)

## Build/Test Commands
- `npm run dev` - Start both frontend (port 3000) and backend (port 3001)
- `npm run build` - Build for production (outputs to dist/)
- `npm run lint` - Run ESLint for code quality
- `npm start` - Start production server
- `npm run dev:frontend` - Frontend only development
- `npm run dev:backend` - Backend only development

## Code Style Guidelines

### Frontend Structure
- React 18 + TypeScript with functional components and hooks
- React Router for client-side routing
- Tailwind CSS for styling with dark theme (slate-900 + red accents)
- Type-safe API calls using custom service layer in `src/services/api.ts`

### Backend Structure
- Express.js + TypeScript server on port 3001
- CSV data parsing with csv-parser library
- CORS enabled for development, static file serving for production
- RESTful API endpoints: `/api/events`, `/api/blog-posts`, `/api/health`

### Data Management
- CSV files store events and blog posts with typed interfaces
- API layer abstracts data access from components
- Error handling and loading states in frontend

### TypeScript Types
- Centralized type definitions in `src/types/index.ts`
- Interfaces for Event and BlogPost entities
- Type-safe API responses and component props

## Key Patterns
- Consistent red brand color (#ef4444, red-600) throughout
- Mobile-first responsive design with Tailwind breakpoints
- Loading and error states for all async operations
- Component separation: HomePage handles all sections
- API proxy configuration in Vite for development