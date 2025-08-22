# SMC AMA Website

A modern web application for the American Marketing Association chapter at Saint Mary's College of California.

## Tech Stack

- **Frontend**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS
- **Backend**: Express.js + TypeScript
- **Data**: CSV files (transitioning to database later)
- **Icons**: Lucide React

## Development

### Prerequisites

- Node.js 18+
- npm or yarn

### Getting Started

1. Install dependencies:
```bash
npm install
```

2. Start development servers (frontend + backend):
```bash
npm run dev
```

3. Frontend: http://localhost:3000
4. Backend API: http://localhost:3001

### Available Scripts

- `npm run dev` - Start both frontend and backend in development mode
- `npm run dev:frontend` - Start only frontend development server
- `npm run dev:backend` - Start only backend development server
- `npm run build` - Build for production
- `npm run lint` - Run ESLint
- `npm run preview` - Preview production build
- `npm start` - Start production server

## Project Structure

```
├── src/                    # Frontend source
│   ├── components/         # React components
│   ├── services/          # API service layer
│   ├── types/             # TypeScript type definitions
│   └── main.tsx           # Application entry point
├── server/                # Backend source
│   └── index.ts           # Express server
├── data/                  # CSV data files
│   ├── events.csv         # Events data
│   └── blog-posts.csv     # Blog posts data
└── dist/                  # Production build output
```

## API Endpoints

- `GET /api/events` - Get all events
- `GET /api/blog-posts` - Get all blog posts
- `GET /api/health` - Health check

## Deployment

1. Build the application:
```bash
npm run build
```

2. Start production server:
```bash
npm start
```

The application will serve both the frontend and API from the same server in production mode.
