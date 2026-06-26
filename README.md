# 🏏 Cricket Master Analytics Platform

## Project Overview
Complete end-to-end Cricket Analytics Platform covering IPL, T20 World Cup, ODI World Cup, and Test Cricket. Built for professional-grade sports BI analysis.

## Dataset
- **Matches**: 2,000 matches (2008-2023) across 4 formats
- **Batting**: 5,000 batting innings records
- **Bowling**: 4,000 bowling spell records
- **Formats**: IPL (45%), T20 WC (20%), ODI WC (20%), Test (15%)

## Project Structure
```
cricket_platform/
├── dataset/
│   ├── cricket_matches.csv
│   ├── cricket_batting.csv
│   └── cricket_bowling.csv
├── visualizations/   (11 charts)
├── sql/
│   └── cricket_queries.sql
├── reports/          (10 SQL result CSVs)
├── dashboard/
├── cricket_analytics.py
└── README.md
```

## Key Findings
- India wins 64.3% of ODI WC matches vs Australia
- T20 WC has highest toss advantage (52%)
- Dubai International: highest toss-win conversion (57.4%)
- MS Dhoni & Rohit Sharma: Elite Allrounders (high avg + high SR)
- Suresh Raina: Top run scorer across all formats

## Tech Stack
Python | Pandas | NumPy | Matplotlib | Seaborn | SQLite3

## How to Run
```bash
pip install pandas numpy matplotlib seaborn
python cricket_analytics.py
```

## GitHub Repository
```
cricket-master-analytics-platform
```
