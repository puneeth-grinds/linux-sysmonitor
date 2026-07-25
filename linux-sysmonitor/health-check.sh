#!/bin/bash 
# Script: health-check.sh
# Purpose: Collect system health data and write structured logs
# Usage: ./health-check.sh
# Output: logs/health-YYYY-MM-DD-HH-MM.log

set -uo pipefail
LOGFILE="logs/$(date +"%Y-%m-%d-%H-%M").log"
TARGET_HOST="${TARGET_HOST:-8.8.8.8}"

if [ -d logs ]; then
    :
else
    mkdir -p logs
fi 

write_log() {

    level="$1"
    message="$2"
    timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
    echo "$timestamp | $level | $message" >> "$LOGFILE"
}
write_log "INFO" "TEST MESSAGE" 

check_cpu() {
    CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
    TOTAL=100
    CPU_USAGE=$(awk "BEGIN{print $TOTAL - $CPU_IDLE}")
    int_CPU_USAGE=$(awk "BEGIN{print int($CPU_USAGE)}")

    if [ "$int_CPU_USAGE" -lt 70 ]; then 
        write_log "INFO" "CPU usage is $int_CPU_USAGE% — healthy"
    elif [[ "$int_CPU_USAGE"  -ge 70 && "$int_CPU_USAGE"  -lt 90 ]]; then
        write_log "WARNING" "CPU usage is $int_CPU_USAGE% — above threshold" 
    else
        write_log "CRITICAL" "CPU usage is $int_CPU_USAGE% — immediate attention"
    fi

}
check_cpu

check_memory() {
    USED_MEM=$(free | grep "Mem" | awk '{print $3}')
    TOTAL_MEM=$(free | grep "Mem" | awk '{print $2}')
    USED_MEM_PCT=$(awk "BEGIN{print ($USED_MEM / $TOTAL_MEM) * 100}")
    USED_MEM_INT=$(awk "BEGIN{print int($USED_MEM_PCT)}")
    if [ "$USED_MEM_INT" -lt 70 ]; then 
        write_log "INFO" "Memory usage is $USED_MEM_INT% — healthy"
    elif [[ "$USED_MEM_INT" -ge 70 && "$USED_MEM_INT" -lt 90 ]]; then 
        write_log "WARNING" "Memory usage is $USED_MEM_INT% — above threshold"
    else
        write_log "CRITICAL" "Memory usage is $USED_MEM_INT% — immediate attention"
    fi
}
check_memory

disk_check() {
    DISK_MEM_VALUE=$(df -h /| grep "overlay" | awk '{print $5}' | sed 's/%//')
    if [ "$DISK_MEM_VALUE" -lt 80 ]; then 
        write_log "INFO" "Disk usage is $DISK_MEM_VALUE% — healthy"
    elif [[ "$DISK_MEM_VALUE" -ge 80 && "$DISK_MEM_VALUE" -lt 95 ]]; then 
        write_log "WARNING" "Disk usage is $DISK_MEM_VALUE% — above threshold"
    else
        write_log "CRITICAL" "Disk usage is $DISK_MEM_VALUE% — immediate attention"
    fi
}
disk_check

check_process () {
    if  pgrep -x sshd ; then
        write_log "INFO" "sshd is running"
    else
        write_log "WARNING" "sshd is not running"
    fi

    if pgrep -x cron; then 
        write_log "INFO" "cron is running"
    else
        write_log "WARNING" "cron is not running"
    fi

}
check_process

check_top_processes() {
    TOP_PROCESS=$(ps -eo comm,pcpu | sort -rnk 2,2 | head -n 5 | awk '{print $1 "(" $2 "%)"}' | paste -sd ' ' -)
    write_log "INFO" "Top CPU processes: $TOP_PROCESS"
    
}
check_top_processes

check_network () {
    NETWORK_CHECK=$(ping -c 4 "$TARGET_HOST")
    PING_STATUS=$?
    PING_LATENCY=$(echo "$NETWORK_CHECK"| grep "rtt" | awk '{print $4}' | awk -F'/' '{print $2}')
    if [ $PING_STATUS -eq 0 ] ; then
        write_log "INFO" "Network OK - latency $PING_LATENCY"
    else
        write_log "CRITICAL" "No network connectivity"
    fi
}
check_network

check_ports (){
    PORTS=$(ss -tlnp | awk '{print $4}'| awk -F':' '{print $2}' | paste -sd ' ' -)
    write_log "INFO" "Listening ports: $PORTS"
}
check_ports

check_syslogs () {
    if [ -f /var/log/syslog ]; then
        LOGS=$(tail -n 10 /var/log/syslog)
    else
        LOGS=$(journalctl -n 10 --no-pager)
    fi
    write_log "INFO" "Recent System logs: $LOGS"
}
check_syslogs

check_uptime() {
    LOAD_AVG=$(cat /proc/loadavg)
    LOAD_1=$(echo "$LOAD_AVG" | awk '{print $1}')
    LOAD_5=$(echo "$LOAD_AVG" | awk '{print $2}')
    LOAD_15=$(echo "$LOAD_AVG" | awk '{print $3}')
    write_log "INFO" "Load Average (1m/5m/15m): $LOAD_1 / $LOAD_5 / $LOAD_15"

    UPTIME=$(uptime -p)
    write_log "INFO" "System uptime: $UPTIME"
    
}
check_uptime

print_summary() {
    echo "========================================="
    echo "         Linux SysMonitor Summary.       "
    echo "========================================="
    echo "Log File: $LOGFILE"
    echo "Total Entries: $(wc -l "$LOGFILE")"
    echo "INFO: $(grep -c 'INFO' "$LOGFILE")"
    echo "WARNING: $(grep -c 'WARNING' "$LOGFILE")"
    echo "CRITICAL: $(grep -c 'CRITICAL' "$LOGFILE")"
    echo "========================================="
    echo "         Health Check Complete.       "
    echo "========================================="

}
print_summary