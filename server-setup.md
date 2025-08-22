# Home Server Setup Guide

## Quick Deployment

### 1. On your ThinkPad server:
```bash
# Clone the repository
git clone https://github.com/NIsaeff/smc_ama_website.git
cd smc_ama_website

# Edit domain in deploy script (optional)
nano deploy.sh  # Change DOMAIN="your-domain.com" to your actual domain

# Run deployment script
sudo ./deploy.sh production
```

### 2. That's it! 🎉

The script handles everything:
- ✅ System updates
- ✅ Nginx + PM2 + Node.js installation
- ✅ App deployment and configuration
- ✅ SSL certificate (if domain configured)
- ✅ Firewall setup
- ✅ Auto-restart on boot

## Manual Commands

### Application Management
```bash
# Check status
pm2 status

# View logs
pm2 logs smc-ama-website

# Restart app
pm2 restart smc-ama-website

# Monitor dashboard
pm2 monit
```

### Updates
```bash
# Quick update (after pushing to GitHub)
sudo /var/www/smc-ama-website/update.sh

# Or manual update
cd /var/www/smc-ama-website
sudo -u ama-app git pull origin main
sudo -u ama-app npm install
sudo -u ama-app npm run build
sudo -u ama-app pm2 restart smc-ama-website
```

### Nginx Management
```bash
# Test configuration
sudo nginx -t

# Reload configuration
sudo systemctl reload nginx

# Check status
sudo systemctl status nginx
```

### SSL Certificate (if using domain)
```bash
# Renew certificate
sudo certbot renew

# Check certificate status
sudo certbot certificates
```

## Network Setup

### Port Forwarding (on your router)
- **Port 80** → ThinkPad IP:80 (HTTP)
- **Port 443** → ThinkPad IP:443 (HTTPS)

### Dynamic DNS (if no static IP)
Consider services like:
- No-IP
- DuckDNS
- Cloudflare Dynamic DNS

### Local Testing
- **Local access**: `http://thinkpad-ip:3001`
- **Through Nginx**: `http://thinkpad-ip`

## File Locations
- **App**: `/var/www/smc-ama-website/`
- **Logs**: `/var/www/smc-ama-website/logs/`
- **Nginx config**: `/etc/nginx/sites-available/smc-ama-website`
- **SSL certs**: `/etc/letsencrypt/live/your-domain/`

## Monitoring
```bash
# System resources
htop

# Disk space
df -h

# PM2 dashboard
pm2 monit

# Nginx access logs
sudo tail -f /var/log/nginx/access.log
```