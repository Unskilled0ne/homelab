# 🛡️ Cutting-Edge SecOps Homelab & AI Command Center

A high-performance, security-focused hybrid homelab infrastructure orchestrated across an **Arch Linux Workstation (RTX 4070 12GB)** and a **Raspberry Pi 4 NDR Sensor (`scaleless`)**, backed by GitOps and infrastructure-as-code.

---

## 🏛️ Architecture & Nodes

```mermaid
graph TD
    subgraph "Edge / Perimeter"
        TAP["Network TAP / SPAN"] -->|Mirror Port| ETH0["eth0 (Promiscuous)"]
        subgraph "Raspberry Pi 4 Sensor (scaleless.local)"
            ETH0 --> SURICATA["Suricata IDS/IPS"]
            ETH0 --> ZEEK["Zeek NDR Engine"]
            FORWARDER["pi4-ndr-forwarder"] -->|Tailscale / 10.42.0.1:8000| SOAR["Aegis-SOAR API"]
        end
    end

    subgraph "Central Node (Arch Linux Workstation)"
        TRAEFIK["Traefik v3 Ingress (Auto-TLS)"]
        
        subgraph "Security Operations"
            SOAR
            SHADOWPOT["ShadowPot Honeypot"]
            WAZUH["Wazuh SIEM / XDR"]
        end

        subgraph "Local AI Acceleration (NVIDIA RTX 4070)"
            OLLAMA["Ollama (LLaMA 3.3 / Qwen Coder)"]
            WEBUI["Open-WebUI (RAG & Multi-Agent)"]
            SOAR -->|LLM Triage API| OLLAMA
        end

        subgraph "Observability & Ingress"
            PROM["Prometheus + Loki + cAdvisor"]
            GRAFANA["Grafana Dashboards"]
            KUMA["Uptime Kuma"]
            ADGUARD["AdGuard Home DNS"]
        end
    end

    TAILSCALE["Tailscale Mesh Overlay"] -.-> RPI
    TAILSCALE -.-> ARCH
```

---

## 📂 Repository Layout

```
homelab/
├── docker/
│   ├── ai/            # Ollama GPU pass-through + Open-WebUI
│   ├── monitoring/    # Prometheus, Grafana, Loki, Promtail, cAdvisor, Uptime Kuma
│   ├── security/      # Wazuh SIEM, Caldera adversary emulation
│   └── services/      # Traefik v3 reverse proxy, AdGuard Home DNS
├── ansible/           # Automations for PC & Raspberry Pi sensor
├── scripts/           # Management, backup (Restic), and diagnostic scripts
└── docs/              # System architecture specs and runbooks
```

## 🚀 Quickstart
```bash
# Bring up monitoring stack
cd docker/monitoring && docker compose up -d

# Bring up Traefik and AdGuard Home
cd ../services && docker compose up -d

# Bring up GPU-accelerated AI stack
cd ../ai && docker compose up -d
```
