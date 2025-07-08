import pandas as pd
from datetime import datetime, timedelta

# Define task phases from the Gantt chart with approximate durations
tasks = [
    ("Infra Design & Node Setup", "2025-07-15", 30),
    ("Observability Stack", "2025-08-14", 15),
    ("Ingress, Storage, MQ Setup", "2025-08-29", 15),
    ("CI/CD Pipelines", "2025-08-29", 20),
    ("Project Context Loader", "2025-08-29", 15),
    ("Orchestrator + Queue Layer", "2025-09-13", 20),
    ("Embedding + Vector DB Setup", "2025-10-03", 15),
    ("API Integration Layer", "2025-10-03", 15),
    ("OSS PDF Parser Research", "2025-08-15", 20),
    ("Text & Table Extraction", "2025-09-04", 30),
    ("Table Reconstruction", "2025-10-04", 30),
    ("PDF Parsing QA", "2025-11-03", 20),
    ("Diagram VLM Research", "2025-08-15", 30),
    ("Diagram Preprocessor", "2025-09-14", 30),
    ("Model Fine-tuning", "2025-10-14", 45),
    ("DSL Conversion Logic", "2025-11-28", 30),
    ("Diagram Regression Testing", "2025-12-28", 15),
    ("Compliance Spec Definition", "2025-08-15", 20),
    ("Equation + DSL Evaluator", "2025-09-04", 30),
    ("Multi-standard Rule Loader", "2025-10-04", 30),
    ("Compliance QA", "2025-11-03", 20),
    ("Prompt & Template Design", "2025-09-15", 20),
    ("Doc Generator Implementation", "2025-10-05", 30),
    ("LLM Fine-tuning Loop", "2025-11-04", 30),
    ("Deploy OSS LLM", "2025-08-20", 15),
    ("Embedding Optimization", "2025-12-04", 20),
    ("Email Agent Dev", "2025-09-01", 20),
    ("ERP Hook Agent", "2025-09-21", 20),
    ("Logging Agent Hooks", "2025-10-11", 15),
    ("Full Agent Integration", "2026-03-15", 30),
    ("Compliance + Diagram QA", "2026-04-14", 30),
    ("Stability & Perf Testing", "2026-05-14", 30),
    ("Buffer + Customer Adaptation", "2026-06-13", 30),
]

# Generate the DataFrame
data = []
for task, start_date_str, duration in tasks:
    start_date = datetime.strptime(start_date_str, "%Y-%m-%d")
    end_date = start_date + timedelta(days=duration)
    data.append({
        "Task": task,
        "Start Date": start_date.date(),
        "End Date": end_date.date(),
        "Duration (days)": duration
    })

df = pd.DataFrame(data)

# Save to CSV
df.to_csv("gantt_chart_tasks.csv", index=False)