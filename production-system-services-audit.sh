#!/bin/bash

# Output file
OUTPUT_FILE="production_system_audit_$(date +%Y%m%d_%H%M%S).txt"

# Function to check if a service exists and get its status
check_service() {
  local service=$1
  echo "=== Checking $service ===" >>"$OUTPUT_FILE"
  if systemctl list-unit-files | grep -q "$service"; then
    echo "Service exists:" >>"$OUTPUT_FILE"
    systemctl status "$service" 2>&1 >>"$OUTPUT_FILE"
    echo "Service enabled status:" >>"$OUTPUT_FILE"
    systemctl is-enabled "$service" 2>&1 >>"$OUTPUT_FILE"
  else
    echo "Service not found" >>"$OUTPUT_FILE"
  fi
  echo "-------------------" >>"$OUTPUT_FILE"
}

# Function to check port usage
check_ports() {
  echo "=== Open Ports and Associated Services ===" >>"$OUTPUT_FILE"
  netstat -tulpn 2>/dev/null || ss -tulpn >>"$OUTPUT_FILE"
  echo "-------------------" >>"$OUTPUT_FILE"
}

# Function to check installed security tools
check_security_tools() {
  echo "=== Security Tools Check ===" >>"$OUTPUT_FILE"
  security_tools=("selinux" "apparmor" "fail2ban" "aide" "auditd" "tripwire" "rkhunter")

  for tool in "${security_tools[@]}"; do
    echo "Checking $tool:" >>"$OUTPUT_FILE"
    if command -v "$tool" &>/dev/null; then
      echo "Installed: Yes" >>"$OUTPUT_FILE"
      case $tool in
      "selinux")
        sestatus 2>&1 >>"$OUTPUT_FILE"
        ;;
      "apparmor")
        aa-status 2>&1 >>"$OUTPUT_FILE"
        ;;
      "fail2ban")
        fail2ban-client status 2>&1 >>"$OUTPUT_FILE"
        ;;
      *)
        echo "Version: $($tool --version 2>&1)" >>"$OUTPUT_FILE"
        ;;
      esac
    else
      echo "Installed: No" >>"$OUTPUT_FILE"
    fi
    echo "-------------------" >>"$OUTPUT_FILE"
  done
}

# Main execution starts here
echo "=== System Audit Report - $(date) ===" >"$OUTPUT_FILE"
echo "Hostname: $(hostname)" >>"$OUTPUT_FILE"
echo "-------------------" >>"$OUTPUT_FILE"

# System Information
echo "=== System Information ===" >>"$OUTPUT_FILE"
uname -a >>"$OUTPUT_FILE"
cat /etc/os-release >>"$OUTPUT_FILE"
echo "-------------------" >>"$OUTPUT_FILE"

# Resource Usage
echo "=== Resource Usage ===" >>"$OUTPUT_FILE"
echo "CPU Usage:" >>"$OUTPUT_FILE"
top -bn1 | head -n 5 >>"$OUTPUT_FILE"
echo "Memory Usage:" >>"$OUTPUT_FILE"
free -h >>"$OUTPUT_FILE"
echo "Disk Usage:" >>"$OUTPUT_FILE"
df -h >>"$OUTPUT_FILE"
echo "-------------------" >>"$OUTPUT_FILE"

# Check common production services
production_services=(
  # Web Servers
  "nginx"
  "httpd"
  "apache2"
  "tomcat"

  # Databases
  "mysqld"
  "postgresql"
  "mongodb"
  "redis"
  "cassandra"

  # Message Brokers
  "rabbitmq-server"
  "kafka"
  "activemq"

  # Load Balancers
  "haproxy"

  # Monitoring
  "prometheus"
  "grafana-server"
  "node_exporter"
  "elasticsearch"
  "kibana"
  "logstash"
  "filebeat"
  "telegraf"
  "zabbix-agent"
  "nagios"

  # Caching
  "varnish"
  "memcached"

  # Configuration Management
  "puppet"
  "chef-client"
  "salt-minion"
  "ansible"

  # Container Services
  "docker"
  "containerd"
  "kubelet"

  # CI/CD
  "jenkins"
  "gitlab-runner"

  # Version Control
  "gitlab-runsvdir"

  # Backup Services
  "bacula"
  "rsnapshot"
)

echo "=== Checking Production Services ===" >>"$OUTPUT_FILE"
for service in "${production_services[@]}"; do
  check_service "$service"
done

# Check Docker containers if Docker is running
if command -v docker &>/dev/null; then
  echo "=== Docker Containers ===" >>"$OUTPUT_FILE"
  docker ps -a 2>&1 >>"$OUTPUT_FILE"
  echo "Docker Images:" >>"$OUTPUT_FILE"
  docker images 2>&1 >>"$OUTPUT_FILE"
  echo "-------------------" >>"$OUTPUT_FILE"
fi

# Check Kubernetes if present
if command -v kubectl &>/dev/null; then
  echo "=== Kubernetes Status ===" >>"$OUTPUT_FILE"
  kubectl get nodes 2>&1 >>"$OUTPUT_FILE"
  kubectl get pods --all-namespaces 2>&1 >>"$OUTPUT_FILE"
  echo "-------------------" >>"$OUTPUT_FILE"
fi

# Check security tools
check_security_tools

# Check network ports
check_ports

# Check for cron jobs
echo "=== Cron Jobs ===" >>"$OUTPUT_FILE"
for user in $(cut -d: -f1 /etc/passwd); do
  echo "Cron jobs for $user:" >>"$OUTPUT_FILE"
  crontab -l -u "$user" 2>&1 >>"$OUTPUT_FILE"
done
echo "System-wide cron jobs:" >>"$OUTPUT_FILE"
ls -l /etc/cron* 2>&1 >>"$OUTPUT_FILE"
echo "-------------------" >>"$OUTPUT_FILE"

# Check SSL certificates
echo "=== SSL Certificates ===" >>"$OUTPUT_FILE"
for cert in $(find /etc/ssl/certs -type f -name "*.pem"); do
  echo "Certificate: $cert" >>"$OUTPUT_FILE"
  openssl x509 -in "$cert" -text -noout 2>&1 >>"$OUTPUT_FILE"
done
echo "-------------------" >>"$OUTPUT_FILE"

# Network Information
echo "=== Network Information ===" >>"$OUTPUT_FILE"
ip addr show >>"$OUTPUT_FILE"
echo "-------------------" >>"$OUTPUT_FILE"

# System Limits
echo "=== System Limits ===" >>"$OUTPUT_FILE"
ulimit -a >>"$OUTPUT_FILE"
echo "-------------------" >>"$OUTPUT_FILE"

echo "Audit completed. Results saved to $OUTPUT_FILE"
