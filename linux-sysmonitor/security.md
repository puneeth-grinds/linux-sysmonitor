# Security Assessment

## Baseline Scan (linux-sysmonitor:v2)

- Critical: 2
- High: Multiple
- Medium: Multiple
- Low: Multiple

## Hardening Changes

- Pinned base image to `debian:12.11-slim`
- Used `--no-install-recommends`
- Removed apt package cache
- Created dedicated non-root user (`appuser`)
- Configured container to run as `appuser`
- Kept runtime image minimal using a multi-stage build

## Final Scan (linux-sysmonitor:v3)

- Critical: 2
- High: Multiple
- Medium: Multiple
- Low: Multiple

## Comparison

The vulnerability count remained unchanged because the remaining findings originate from Debian base packages and runtime dependencies. Several vulnerabilities are marked by Trivy as `will_not_fix`, `affected`, or `fix_deferred`, indicating that no upstream patched version was available at the time of scanning.

## Conclusion

Although the vulnerability count did not decrease, the image was hardened by following Docker security best practices, including pinning the base image, minimizing installed packages, and running the container as a dedicated non-root user.