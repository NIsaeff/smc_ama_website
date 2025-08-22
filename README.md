# SMC AMA Website

A modern web application for the American Marketing Association chapter at Saint Mary's College of California.

## Tech Stack

- **Frontend**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS
- **Backend**: Express.js + TypeScript
- **Data**: CSV files (transitioning to database later)
- **Icons**: Lucide React
- **Deployment**: Home server with Nginx + PM2

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
├── deploy.sh              # Automated deployment script
├── server-setup.md        # Home server deployment guide
└── dist/                  # Production build output
```

## API Endpoints

- `GET /api/events` - Get all events
- `GET /api/blog-posts` - Get all blog posts
- `GET /api/health` - Health check

## Deployment

### Home Server (Recommended)

For production deployment on a home server:

1. **One-command deployment**:
```bash
git clone https://github.com/NIsaeff/smc_ama_website.git
cd smc_ama_website
sudo ./deploy.sh production
```

2. **The script automatically handles**:
   - System updates and package installation
   - Nginx configuration with SSL
   - PM2 process management
   - Firewall setup
   - Auto-restart on boot

3. **Easy updates**:
```bash
sudo /var/www/smc-ama-website/update.sh
```

See [server-setup.md](./server-setup.md) for detailed deployment instructions.

### Local Development

1. Build the application:
```bash
npm run build
```

2. Start production server:
```bash
npm start
```

The application will serve both the frontend and API from the same server in production mode.

## Server Management

### Monitoring
```bash
pm2 status              # Check app status
pm2 logs smc-ama-website # View logs
pm2 monit               # Real-time monitoring
```

### Updates
```bash
# After pushing changes to GitHub
sudo /var/www/smc-ama-website/update.sh
```

### Nginx
```bash
sudo nginx -t           # Test configuration
sudo systemctl reload nginx # Reload configuration
```
