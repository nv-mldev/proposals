# Project Scope

## AI Agents Architecture

```mermaid
  flowchart LR
    subgraph AI_Agent_Module["AI Agent Module - Project Isolated"]
      direction LR

      API[AI Agent API - REST GRPC]:::api
      ORCH[Agent Orchestrator and Task Queue]:::orch
      CM[Project Context Loader]:::infra

      COMPL[Compliance Agent]:::agent
      DOCGEN[Document Generation Agent]:::agent
      DIAGP[Diagram Parsing Agent]:::agent
      %% ENQ[Enquiry Agent]:::agent   %% ENQ agent is commented out
      EMAIL[Email Agent]:::agent
      ERPAGENT[ERP Action Agent]:::agent

      LLM[LLM Runtime - GPT Claude Ollama]:::service
      EMBED[Embedding Service]:::service
      VDB[(Vector DB - project partitioned)]:::database
      KB[(Knowledge Base - project scoped)]:::database

      MQ[(Message Queue Kafka RabbitMQ)]:::infra
      LOG[Logging and Metrics with Prometheus and Loki]:::obs
    end

    API --> ORCH
    ORCH --> CM
    CM --> COMPL
    CM --> DOCGEN
    CM --> DIAGP
    %% CM --> ENQ   %% ENQ agent is commented out
    CM --> EMAIL
    CM --> ERPAGENT

    COMPL --> LLM
    DOCGEN --> LLM
    DIAGP --> LLM
    %% ENQ --> LLM   %% ENQ agent is commented out
    EMAIL --> LLM
    ERPAGENT --> LLM

    COMPL --> KB
    DOCGEN --> KB
    DIAGP --> KB
    %% ENQ --> KB   %% ENQ agent is commented out
    EMAIL --> KB
    ERPAGENT --> KB

    COMPL --> EMBED --> VDB
    DOCGEN --> EMBED --> VDB
    DIAGP --> EMBED --> VDB
    %% ENQ --> EMBED --> VDB   %% ENQ agent is commented out

    ORCH --> MQ --> ORCH

    ORCH -.-> LOG
    COMPL -.-> LOG
    DOCGEN -.-> LOG
    DIAGP -.-> LOG
    %% ENQ -.-> LOG   %% ENQ agent is commented out
    EMAIL -.-> LOG
    ERPAGENT -.-> LOG

    classDef api       fill:#e3f2fd,stroke:#2196f3,color:#000
    classDef orch      fill:#fff3e0,stroke:#fb8c00,color:#000
    classDef agent     fill:#fde0dc,stroke:#d32f2f,color:#000
    classDef service   fill:#c8e6c9,stroke:#388e3c,color:#000
    classDef database  fill:#d1c4e9,stroke:#5e35b1,stroke-dasharray:5 5,color:#000
    classDef infra     fill:#f5f5f5,stroke:#424242,color:#000
    classDef obs       fill:#fff9c4,stroke:#fbc02d,color:#000
```

## AI Infra Architecture

```mermaid
flowchart TB
  %% Edge
  DNS[DNS]:::infra
  LB[Load Balancer]:::infra
  DNS --> LB
  LB --> IC[Ingress Controller]:::infra
  IC --> SM[Service Mesh]:::infra

  %% Control Plane
  subgraph ControlPlane
    CP1[CP Node 1: 8c/32G]:::node
    CP2[CP Node 2: 8c/32G]:::node
    CP3[CP Node 3: 8c/32G]:::node
  end
  SM --> CP1
  SM --> CP2
  SM --> CP3

  %% Worker Pools
  subgraph Workers
    GW1[General Node 1: 16c/64G]:::node
    GW2[General Node 2: 16c/64G]:::node
    GW3[General Node 3: 16c/64G]:::node
    AI1[AI Node 1: 8c/64G + GPU]:::node
    AI2[AI Node 2: 8c/64G + GPU]:::node
  end
  CP1 --> GW1
  CP2 --> GW2
  CP3 --> GW3
  CP1 --> AI1
  CP2 --> AI2

  %% Storage
  subgraph Storage
    ST1[Storage Node 1: RAID10 4×4TB]:::node
    ST2[Storage Node 2: RAID10 4×4TB]:::node
    ST3[Storage Node 3: RAID10 4×4TB]:::node
  end
  GW1 --> ST1
  GW2 --> ST2
  GW3 --> ST3

  %% Observability & Services (example)
  subgraph Observability
    PROM[Prometheus]:::infra
    GRAF[Grafana]:::infra
    LOKI[Loki]:::infra
    JAEG[Jaeger]:::infra
  end
  GW1 --> PROM
  GW2 --> LOKI
  GW3 --> JAEG
  PROM --> GRAF

  classDef infra fill:#f5f5f5,stroke:#424242,color:#000
  classDef node  fill:#d1c4e9,stroke:#5e35b1,color:#000

```

## AI server slicing

```mermaid

  flowchart LR
    subgraph Host["Single Physical Host"]
      direction TB
      subgraph ControlPlane_VMs
        CP1["CP-VM1: 8 vCPU, 32 GB RAM"]:::vm
        CP2["CP-VM2: 8 vCPU, 32 GB RAM"]:::vm
        CP3["CP-VM3: 8 vCPU, 32 GB RAM"]:::vm
      end

      subgraph Worker_VMs
        GW1["GW-VM1: 16 vCPU, 64 GB RAM"]:::vm
        GW2["GW-VM2: 16 vCPU, 64 GB RAM"]:::vm
        GW3["GW-VM3: 16 vCPU, 64 GB RAM"]:::vm
      end

      subgraph AI_VMs
        AI1["AI-VM1: 16 vCPU, 128 GB RAM + 2×T4"]:::vm
        AI2["AI-VM2: 16 vCPU, 128 GB RAM + 2×T4"]:::vm
      end

      subgraph Storage_VMs
        ST1["Storage-VM1: 8 vCPU, 32 GB RAM"]:::vm
        ST2["Storage-VM2: 8 vCPU, 32 GB RAM"]:::vm
        ST3["Storage-VM3: 8 vCPU, 32 GB RAM"]:::vm
      end

      subgraph Infra_VMs
        ING["Ingress-VM: 4 vCPU, 16 GB RAM"]:::vm
        OBS["Obs-VM: 8 vCPU, 32 GB RAM"]:::vm
        AUTH["Auth-VM: 4 vCPU, 16 GB RAM"]:::vm
      end
    end
    classDef vm fill:#d1c4e9,stroke:#5e35b1,color:#000

```

## AI Server Pricing - Estimated (For 1000 users )

| Component                        | Qty | Unit Cost (INR) | Total (INR)     | Notes                                 |
| -------------------------------- | --- | ------------- | ------------- | ------------------------------------- |
| Intel Xeon Gold 6348 CPU         | 2   | 478,125       | 956,250       | Wikipedia RCP INR 3,072 × INR 83/USD        |
| 32 GB DDR4 ECC RDIMM             | 16  | 37,500        | 600,000       | Approx. INR 20K per 32 GB server module |
| NVIDIA Tesla T4 16 GB GPU        | 4   | 271,255       | 1,085,020     | ServerBasket list price               |
| 1 TB NVMe SSD (enterprise)       | 4   | 22,500        | 90,000        | Enterprise NVMe \~INR 12K/TB            |
| 8 TB HDD (enterprise, RAID-10)   | 12  | 37,500        | 450,000       | Enterprise 8 TB \~INR 20K each          |
| Dual-port 25 GbE NIC             | 2   | 46,875        | 93,750        | SFP28 cards                           |
| Dual-port 10 GbE NIC             | 2   | 22,500        | 45,000        | SFP+ cards                            |
| Chassis, PSUs, Board, Fans, etc. | —   | 187,500       | 187,500       | Supermicro or similar                 |
| **Scaled Total**                 |     |               | **3,507,520** | ~INR 35.1 lakhs (~INR 3.5M)              |

## Gannt Chart

```mermaid
gantt
  title AI Agent ERP System — 15-Month Development Plan(start: July 15, 2025)
  dateFormat  YYYY-MM-DD

  %% Phase 1: Infrastructure & Planning
  section Infra & CI/CD
  Infra Design & Node Setup             :a1, 2025-07-15,60d
  Observability Stack (Prom/Loki/Graf) :a2, after a1, 25d
  Ingress, Storage, Message Queue Setup:a3, after a2, 25d
  CI/CD Pipelines, Monitoring Hooks    :a4, after a3, 20d

  %% Phase 2: Core Framework
  section Agent Framework & Orchestrator
  Project Context Loader (CM)          :b1, 2025-08-29,25d
  Orchestrator + Queue Layer           :b2, after b1, 30d
  Embedding + Vector DB Setup          :b3, after b2, 25d
  API Integration Layer                :b4, after b3, 25d

  %% Phase 3: Agent Development
  section PDF Parsing Agent
  OSS Parser Research + Benchmarking   :c1, 2025-08-15, 30d
  Text & Table Extraction Pipeline     :c2, after c1, 40d
  Table Structure Reconstruction       :c3, after c2, 40d
  PDF Parsing Refinement + QA          :c4, after c3, 40d

  section Diagram Parsing Agent
  VLM Research + Dataset Prep          :d1, 2025-08-15,90d
  Basic Diagram Preprocessor           :d2, after d1, 30d
  Model Fine-tuning + Integration      :d3, after d2, 45d
  Diagram → DSL Conversion Logic       :d4, after d3, 30d
  Regression Testing                   :d5, after d4, 15d

  section Compliance Agent
  Rule Format & Spec Definition        :e1, after c4, 30d
  Equation Engine + DSL Evaluator      :e2, after e1, 60d
  Multi-standard Rule Loader           :e3, after e2, 40d
  Compliance Agent QA & Test Coverage  :e4, after e3, 30d

  section Document Generation Agent
  Prompt & Template Design             :f1, 2025-09-15, 30d
  Doc Generator Implementation         :f2, after f1, 40d
  Fine-tuning / Feedback Loop          :f3, after f2, 30d

  section LLM Runtime Setup
  Select & Deploy OSS LLM (e.g. Mistral):g1, 2025-08-20, 15d
  Fine-tuning / Evaluation Loop        :g2, after g1, 30d
  Embedding Optimization + Caching     :g3, after g2, 20d

  section Email / ERP / Logging Agents
  Email Agent Dev                      :h1, 2025-09-01, 20d
  ERP Hook Agent Dev                   :h2, after h1, 20d
  Logging / Observability Agent Hooks  :h3, after h2, 15d

  %% Final Integration
  section Integration, QA, Stabilization
  Full Agent Integration               :i1, 2026-03-15, 30d
  Compliance + Diagram Edge Testing    :i2, after i1, 30d
  Stability + Perf Testing             :i3, after i2, 30d
  Buffer + Customer Adaptations        :i4, after i3, 30d

```
