#!/bin/bash

# SMC AMA Website Deployment Script for Home Server
# Usage: ./deploy.sh [production|development]

MODE=${1:-production}
APP_NAME="smc-ama-website"
APP_USER="ama-app"
APP_DIR="/var/www/$APP_NAME"
DOMAIN="your-domain.com"  # Change this to your domain

echo "🚀 Deploying SMC AMA Website in $MODE mode..."

# Update system packages
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "🔧 Installing required packages..."
sudo apt install -y nginx nodejs npm git certbot python3-certbot-nginx

# Install PM2 globally
echo "📊 Installing PM2..."
sudo npm install -g pm2

# Create app user if doesn't exist
if ! id "$APP_USER" &>/dev/null; then
    echo "👤 Creating app user: $APP_USER"
    sudo adduser --system --group --home $APP_DIR $APP_USER
fi

# Create app directory
echo "📁 Setting up application directory..."
sudo mkdir -p $APP_DIR
sudo chown $APP_USER:$APP_USER $APP_DIR

# Clone/update repository
if [ -d "$APP_DIR/.git" ]; then
    echo "🔄 Updating existing repository..."
    sudo -u $APP_USER git -C $APP_DIR pull origin main
else
    echo "📥 Cloning repository..."
    sudo -u $APP_USER git clone https://github.com/NIsaeff/smc_ama_website.git $APP_DIR
fi

# Install dependencies and build
echo "🏗️  Installing dependencies and building..."
cd $APP_DIR
sudo -u $APP_USER npm install
sudo -u $APP_USER npm run build

# Setup PM2 ecosystem file
echo "⚙️  Setting up PM2 configuration..."
sudo -u $APP_USER tee $APP_DIR/ecosystem.config.js > /dev/null <<EOF
module.exports = {
  apps: [{
    name: '$APP_NAME',
    script: './server/index.js',
    cwd: '$APP_DIR',
    env: {
      NODE_ENV: '$MODE',
      PORT: 3001
    },
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true
  }]
};
EOF

# Create logs directory
sudo -u $APP_USER mkdir -p $APP_DIR/logs

# Start/restart application with PM2
echo "🔄 Starting application with PM2..."
sudo -u $APP_USER pm2 start $APP_DIR/ecosystem.config.js
sudo -u $APP_USER pm2 save

# Setup PM2 startup
sudo -u $APP_USER pm2 startup | grep -E '^sudo' | sudo bash

# Configure Nginx
echo "🌐 Configuring Nginx..."
sudo tee /etc/nginx/sites-available/$APP_NAME > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Static file caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        proxy_pass http://localhost:3001;
        proxy_set_header Host \$host;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Health check endpoint
    location /api/health {
        proxy_pass http://localhost:3001;
        access_log off;
    }
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
echo "🧪 Testing Nginx configuration..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx configuration is valid"
    sudo systemctl reload nginx
    sudo systemctl enable nginx
else
    echo "❌ Nginx configuration error!"
    exit 1
fi

# Setup SSL if domain is configured and not localhost
if [ "$DOMAIN" != "your-domain.com" ] && [ "$DOMAIN" != "localhost" ]; then
    echo "🔒 Setting up SSL certificate..."
    sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN
fi

# Setup firewall
echo "🔥 Configuring firewall..."
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

# Create update script
echo "📝 Creating update script..."
sudo tee $APP_DIR/update.sh > /dev/null <<EOF
#!/bin/bash
echo "🔄 Updating SMC AMA Website..."
cd $APP_DIR
sudo -u $APP_USER git pull origin main
sudo -u $APP_USER npm install
sudo -u $APP_USER npm run build
sudo -u $APP_USER pm2 restart $APP_NAME
echo "✅ Update complete!"
EOF

sudo chmod +x $APP_DIR/update.sh

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "📋 Summary:"
echo "   App URL: http://$DOMAIN (or your server IP)"
echo "   App Directory: $APP_DIR"
echo "   PM2 Status: pm2 status"
echo "   Logs: pm2 logs $APP_NAME"
echo "   Update: $APP_DIR/update.sh"
echo ""
echo "🔧 Next steps:"
echo "   1. Update DOMAIN variable in this script"
echo "   2. Point your domain to this server's IP"
echo "   3. Run script again for SSL setup"
echo "   4. Monitor with: pm2 monit"
echo ""