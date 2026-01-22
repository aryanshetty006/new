# Cybersecurity Network Lab

A Docker Compose-based cybersecurity learning environment with target and scanner containers, plus an optional web-based terminal interface.

## 📋 Overview

This lab provides:
- **Target Container**: A vulnerable target running nginx with exposed services
- **Scanner Container**: Kali Linux-based scanner with comprehensive security tools
- **Web Terminal (Optional)**: ttyd-based web terminal for accessing the scanner via browser

## 🏗️ Architecture

```
┌─────────────────┐         ┌─────────────────┐
│  Target Container│         │ Scanner Container│
│  (nginx:alpine)  │◄────────┤  (Kali Linux)   │
│  Port: 8080      │ Bridge  │  Tools: nmap,   │
│  Port: 9999      │ Network │  netcat, ss, etc│
└─────────────────┘         └─────────────────┘
                                      │
                                      │
                            ┌─────────────────┐
                            │  Web Terminal   │
                            │  (ttyd)         │
                            │  Port: 7681     │
                            └─────────────────┘
```

## 🚀 Quick Start

### Basic Lab Setup (Target + Scanner)

```bash
# Start the lab
docker-compose up -d

# Access the scanner container
docker exec -it cybersecurity-scanner bash

# From inside the scanner, scan the target
nmap -sS target
ss -tuln
nc target 80
```

### Web Terminal Setup (Optional)

```bash
# Start the web terminal
docker-compose -f kalittyd.compose.local.yml up -d

# Access via browser
# Open http://localhost:7681/ttyd
```

## 📦 Components

### 1. Target Container (`cybersecurity-target`)

- **Image**: `nginx:alpine`
- **Exposed Ports**:
  - `8080:80` - HTTP web server
  - Internal port `9999` - Netcat listener
- **Services**:
  - Nginx web server
  - Netcat listener on port 9999

**Access from host**: `http://localhost:8080`

### 2. Scanner Container (`cybersecurity-scanner`)

- **Image**: Custom Kali Linux build
- **Tools Included**:
  - Network scanning: `nmap`, `netcat`, `tcpdump`, `tshark`
  - Web testing: `nikto`, `whatweb`, `wafw00f`, `sslscan`
  - Debugging: `gdb`, `strace`, `ltrace`, `radare2`
  - Python tools: `scapy`, `pwntools`, `volatility3`, `binwalk`
  - GDB enhancements: PEDA, GEF
  - And many more...

**Access**: `docker exec -it cybersecurity-scanner bash`

**Default credentials**: `kali:kali`

### 3. Web Terminal (`kali-ttyd-local`)

- **Service**: ttyd web terminal
- **Port**: `7681`
- **Access**: Browser-based terminal at `http://localhost:7681/ttyd`
- **Features**:
  - Full terminal access via web browser
  - Proper key handling (backspace, arrow keys)
  - Persistent sessions

## 🛠️ Usage Examples

### Network Scanning

```bash
# From scanner container
nmap -sS -p- target              # TCP SYN scan all ports
nmap -sV target                  # Version detection
nmap -sC -sV -p 80,443 target   # Default scripts + version
```

### Service Enumeration

```bash
# Check open ports
ss -tuln

# Test HTTP service
curl http://target:80
wget http://target:80

# Test netcat listener
nc target 9999
```

### Web Application Testing

```bash
# Web vulnerability scanning
nikto -h http://target:80
whatweb http://target:80
sslscan target:443
```

### Packet Analysis

```bash
# Capture packets
tcpdump -i any -w capture.pcap host target

# Analyze with tshark
tshark -r capture.pcap
```

## 📁 File Structure

```
new/
├── docker-compose.yml              # Basic lab setup (target + scanner)
├── kalittyd.compose.local.yml      # Web terminal setup
├── Dockerfile.scanner              # Kali Linux scanner image
├── entry_point.sh                  # ttyd entrypoint script
└── README.md                       # This file
```

## 🔧 Configuration

### Environment Variables (ttyd)

- `HOST_PORT`: Port for ttyd (default: 7681)
- `TZ`: Timezone (default: UTC)
- `APP_ENV`: Environment (default: development)
- `APP_DEBUG`: Debug mode (default: true)

### Network Configuration

Both containers use the default bridge network, allowing them to communicate using container names as hostnames:
- Target hostname: `target`
- Scanner hostname: `cybersecurity-scanner`

## 🐛 Troubleshooting

### Port Already in Use

If you see "Port already in use" error:
```bash
# Check what's using the port
lsof -i :7681

# Stop the container and try again
docker-compose -f kalittyd.compose.local.yml down
```

### Container Build Issues

```bash
# Rebuild without cache
docker-compose build --no-cache

# For ttyd service
docker-compose -f kalittyd.compose.local.yml build --no-cache
```

### Permission Issues

The scanner container runs as `kali` user by default. For ttyd, it runs as root to allow user switching.

### Network Connectivity

```bash
# Test connectivity between containers
docker exec cybersecurity-scanner ping target

# Check network configuration
docker network inspect intro-to-cybersecurity_default
```

## 🔒 Security Notes

⚠️ **This is a learning environment, not for production use!**

- Default passwords are used (`kali:kali`)
- Containers have elevated capabilities (NET_RAW, NET_ADMIN)
- Services are exposed to the host network
- No security hardening applied

## 📚 Learning Resources

### Network Scanning
- `man nmap` - Comprehensive nmap manual
- Practice different scan types: `-sS`, `-sT`, `-sU`, `-sN`

### Service Enumeration
- Learn to identify services: `nmap -sV`
- Use service-specific tools: `nikto`, `sslscan`

### Packet Analysis
- Capture traffic: `tcpdump`, `tshark`
- Analyze protocols: HTTP, TCP, UDP

## 🧹 Cleanup

```bash
# Stop and remove containers
docker-compose down

# Stop and remove ttyd container
docker-compose -f kalittyd.compose.local.yml down

# Remove images
docker rmi kali-ttyd:latest

# Remove volumes (if any)
docker volume prune
```

## 📝 Notes

- The target container runs nginx and netcat for basic service exposure
- The scanner container includes a comprehensive set of security tools
- The web terminal provides convenient browser-based access
- All containers communicate via Docker bridge network
- Container names can be used as hostnames for inter-container communication

## 🤝 Contributing

Feel free to extend this lab with:
- Additional vulnerable services
- More security tools
- Automated attack scenarios
- Defensive tools and monitoring

## 📄 License

This is a learning resource for cybersecurity education.
