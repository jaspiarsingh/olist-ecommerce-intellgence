# Olist E-Commerce Performance Intelligence | 2016–2018

## 📊 [View Live Dashboard](https://public.tableau.com/views/e-commerce-dashboard_17806002163060/Dashboard1)

---

## Business Context

Olist is Brazil's largest department store marketplace, connecting small businesses to major e-commerce channels. This project analyzes **100,000+ real orders** placed between 2016 and 2018 to answer a core business question:

> **Where is revenue leaking — and what can leadership do about it?**

Late deliveries, underperforming sellers, and category concentration risk are costing the business in customer satisfaction and repeat purchases. This analysis surfaces those problems and provides data-driven recommendations.

---

## Key Business Findings

- **Health & Beauty and Watches/Gifts** drove the most revenue (~$1.2M each), signaling heavy dependence on two categories — a concentration risk
- **Credit card payments** account for 80%+ of all revenue; boleto (bank slip) is the only meaningful alternative at ~20%
- **Alagoas (AL) and Maranhão (MA)** had the highest late delivery rates (23%+), directly correlated with lower review scores
- **Review scores drop sharply** when late delivery rates exceed 10% — delivery performance is the single biggest driver of customer satisfaction
- **Revenue grew 10x** from late 2016 to mid-2018, with a clear seasonal peak in November (Black Friday)

---

## Recommendations

1. **Logistics investment in AL and MA** — late delivery rates above 20% in these states are damaging brand reputation; regional carrier partnerships or fulfillment centers would reduce this
2. **Seller quality program** — bottom quartile sellers average 3.5 review scores; introducing performance thresholds with consequences would lift overall platform quality
3. **Category diversification** — over-reliance on 2 categories creates revenue risk; targeted promotions in furniture, electronics, and garden tools could balance the mix
4. **Delivery expectation alignment** — setting more conservative estimated delivery dates would reduce "late" classifications and improve perceived reliability

---

## Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — Kaggle  
**Size:** 100,000+ orders across 7 relational tables  
**Period:** September 2016 – August 2018  

| Table | Description |
|---|---|
| `orders` | Order status and timestamps |
| `order_items` | Products, prices, freight per order |
| `payments` | Payment type, installments, value |
| `reviews` | Customer review scores and comments |
| `customers` | Customer location by state |
| `products` | Product category and dimensions |
| `category_translation` | Portuguese → English category names |

---

## Tech Stack

| Tool | Purpose |
|---|---|
| MySQL | Data storage, cleaning, and analysis |
| Python (Pandas) | Data import and ETL pipeline |
| Tableau Public | Interactive dashboard and visualization |

---

## SQL Analysis

Six business-driven queries were written to power the dashboard:

| Query | Business Question |
|---|---|
| Monthly Revenue Trend | Is the business growing? Are there seasonal patterns? |
| Revenue by Category | Which product lines are driving the business? |
| Delivery Performance by State | Which states have the worst logistics problems? |
| Review Score vs Delivery | Does late delivery hurt customer satisfaction? |
| Payment Behavior | How are customers paying and what drives higher spend? |
| Seller Performance Scorecard | Which sellers are underperforming and why? |

Full queries available in the [`/sql`](/sql) folder.

---

## Project Structure

```
olist-ecommerce-intelligence/
│
├── sql/
│   ├── 01_monthly_revenue.sql
│   ├── 02_category_revenue.sql
│   ├── 03_delivery_by_state.sql
│   ├── 04_review_vs_delivery.sql
│   ├── 05_payment_behavior.sql
│   └── 06_seller_performance.sql
│
├── python/
│   └── import_ecommerce.py
│
├── dashboard/
│   └── dashboard_screenshot.png
│
└── README.md
```

---

## Dashboard Preview

[![Dashboard Preview](dashboard/dashboard_screenshot.png)](https://public.tableau.com/views/e-commerce-dashboard_17806002163060/Dashboard1)

---

## Author

**Jaspiar Singh**  
Data Analyst | linkedin.com/in/jaspiar
