#  Linux SysMonitor

A Bash-based Linux monitoring and log analysis tool designed to monitor system health, generate structured logs, and provide powerful log analysis capabilities.

Built as a hands-on DevOps learning project covering Linux administration, Bash scripting, troubleshooting, automation, and log management.

---

##  Table of Contents

* [Overview](#-overview)
* [Features](#-features)
* [Project Structure](#-project-structure)
* [Installation](#-installation)
* [Usage](#-usage)
* [Log Analysis](#-log-analysis)
* [Validation & Error Handling](#-validation--error-handling)
* [Sample Outputs](#-sample-outputs)
* [Troubleshooting](#-troubleshooting)
* [Technologies Used](#-technologies-used)
* [What I Learned](#-what-i-learned)
* [Future Improvements](#-future-improvements)

---
#  Overview

Linux SysMonitor performs automated health checks on a Linux system and stores results in structured log files.

The accompanying analysis tool enables engineers to:

* Review health check results
* Filter logs by severity
* Identify recurring issues
* Generate summaries
* Perform time-based log analysis

This project was built to strengthen practical Linux and DevOps skills through real-world scripting and troubleshooting.

---

#  Features

##  Health Monitoring

* CPU Usage Monitoring
* Memory Usage Monitoring
* Disk Usage Monitoring
* SSH Service Health Check
* Cron Service Health Check
* Network Connectivity Validation
* Open Port Inspection
* Recent System Log Collection
* Load Average Monitoring
* System Uptime Monitoring

##  Log Analysis

* Summary Reports
* Severity-Based Filtering
* Top Recurring Issues
* Time-Based Filtering
* Custom Log File Support
* Colored Terminal Output
* Input Validation
* Graceful Error Handling

---

#  Architecture

```text
+-------------------+
| health-check.sh   |
+-------------------+
          |
          v
+-------------------+
| Structured Logs   |
| logs/*.log        |
+-------------------+
          |
          v
+-------------------+
| analyse.sh        |
+-------------------+
          |
   +------+------+------+
   |             |      |
   v             v      v
Summary      Filtering  Top Issues
```

---

#  Project Structure

```text
linux-sysmonitor/
├── health-check.sh
├── analyse.sh
├── logs/
│   └── *.log
├── sample-output/
│   ├── sample-log.log
│   ├── summary.txt
│   ├── top-issues.txt
│   ├── critical.txt
│   └── since.txt
├── README.md
└── .gitignore
```

---

#  Installation

## Clone the Repository

```bash
git clone https://github.com/<your-username>/linux-sysmonitor.git
cd linux-sysmonitor
```

## Make Scripts Executable

```bash
chmod +x health-check.sh
chmod +x analyse.sh
```

## Build the Docker Image

From the repository root, build the container image with:

```bash
docker build -t linux-sysmonitor:latest .
```

## Run the Docker Container

Run the health check inside the container and persist logs to the local `logs` directory:

```bash
docker run --rm -v "$PWD/logs:/app/logs" linux-sysmonitor:latest
```

---

# 🚦 Usage

## Run a Full Health Check

```bash
./health-check.sh
```

This generates a timestamped log file under:

```text
logs/
```

Example:

```text
logs/2026-06-23-05-06.log
```

---

## Log Format

Generated logs follow the structure:

```text
YYYY-MM-DD HH:MM:SS | LEVEL | MESSAGE
```

Example:

```text
2026-06-23 05:06:37 | INFO | CPU usage is 10% — healthy
2026-06-23 05:06:37 | WARNING | cron is not running
2026-06-23 05:06:37 | CRITICAL | Disk usage is 96%
```

---

#  Log Analysis

## Generate Summary Report

```bash
./analyse.sh --summary
```

Example Output:

```text
=================================
Log Summary
=================================
Total Entries: 11
INFO: 9
WARNING: 1
CRITICAL: 1
=================================
```

---

## Filter Logs by Severity

### INFO Logs

```bash
./analyse.sh --level INFO
```

### WARNING Logs

```bash
./analyse.sh --level WARNING
```

### CRITICAL Logs

```bash
./analyse.sh --level CRITICAL
```

---

## Find Top Recurring Issues

Display the most frequent log entries:

```bash
./analyse.sh --top 5
```

Example:

```text
4 CPU usage is 10% — healthy
3 Memory usage is 28% — healthy
2 cron is not running
```

---

## Time-Based Filtering

Display entries after a specific time:

```bash
./analyse.sh --since 10:30
```

Example:

```bash
./analyse.sh --since 14:00
```

---

## Analyse a Specific Log File

```bash
./analyse.sh --file logs/sample.log --summary
```

---

#  Validation & Error Handling

Linux SysMonitor includes validation for:

* Missing arguments
* Invalid flags
* Invalid log levels
* Missing log files
* Missing logs directory
* Empty logs directory
* Invalid user input

### Invalid Level

```bash
./analyse.sh --level TEST
```

Output:

```text
Error: Invalid level. Use INFO, WARNING, or CRITICAL
```

### Missing File

```bash
./analyse.sh --file missing.log
```

Output:

```text
Error: File not found: missing.log
```

### Missing Logs Directory

```text
Error: logs directory does not exist
```

### Empty Logs Directory

```text
Error: No log files found
```

---

# 📸 Sample Outputs

Store generated examples under:

```text
sample-output/
```

Suggested files:

```text
sample-output/
├── sample-log.log
├── summary.txt
├── top-issues.txt
├── critical.txt
├── since.txt
├── health-check.png
└── analysis-summary.png
```

Example screenshots:

```text
sample-output/health-check.png
sample-output/analysis-summary.png
```

---

#  Validation Commands

Generate a new log file:

```bash
./health-check.sh
```

Generate a summary:

```bash
./analyse.sh --summary
```

Display warning entries:

```bash
./analyse.sh --level WARNING
```

Display top recurring issues:

```bash
./analyse.sh --top 5
```

Display entries after a specific time:

```bash
./analyse.sh --since 12:00
```

---

#  Troubleshooting

## Permission Denied

```bash
chmod +x health-check.sh
chmod +x analyse.sh
```

---

## No Log Files Found

Generate a log first:

```bash
./health-check.sh
```

---

## Missing Logs Directory

```bash
mkdir -p logs
```

---

## Verify Script Quality

Install ShellCheck:

```bash
sudo apt update
sudo apt install shellcheck -y
```

Run analysis:

```bash
shellcheck health-check.sh
shellcheck analyse.sh
```

---

#  Technologies Used

| Category        | Tools                  |
| --------------- | ---------------------- |
| Scripting       | Bash                   |
| Monitoring      | top, free, df          |
| Networking      | ping, ss               |
| Text Processing | awk, grep, sort, uniq  |
| Logging         | Custom Structured Logs |
| Version Control | Git, GitHub            |
| Quality Checks  | ShellCheck             |

---

#  What I Learned

Through this project I gained hands-on experience with:

* Linux Fundamentals
* Bash Scripting
* Shell Functions
* Conditional Logic
* Argument Parsing
* Log Management
* System Monitoring
* Process Monitoring
* Network Troubleshooting
* Text Processing with awk and grep
* Error Handling
* Defensive Scripting
* Git Branching & Pull Requests
* GitHub Project Management
* ShellCheck Best Practices

---

# Future Improvements

* Email Alerts
* Slack Notifications
* HTML Report Generation
* Systemd Service Integration
* Cron-Based Scheduling
* Prometheus Metrics Export
* Grafana Dashboard Integration
* Docker Packaging
* Configuration File Support
* Multi-Server Monitoring

---

#  License

This project is intended for learning, experimentation, and portfolio demonstration purposes.

---

##  Support

If you found this project useful, consider starring the repository and sharing feedback.

Happy scripting! 🐧
