# 📊 HR Analytics: Workforce Attrition & Retention Strategy

## 🚀 Project Overview
This repository contains an end-to-end HR Data Analytics project designed to uncover the root causes of employee turnover. The objective is to translate raw human resources data into a compelling narrative and actionable business recommendations to stabilize the workforce and retain top talent.

## 🎯 The Business Problem
The organization is facing a compounding attrition problem with an overall turnover rate of **17.3%**. More critically, the company is bleeding top-tier talent, having lost **962 High Performers**. Management requested a comprehensive analysis to answer:
*   Which departments and roles are driving the highest turnover?
*   Are workload (overtime) and engagement scores linked to attrition?
*   Are compensation and promotions fairly aligned with actual performance?

## 🛠️ Tools & Methodology
This project demonstrates a full data analytics pipeline:
*   **Data Cleaning & Preprocessing:** **Python (Pandas)** across 5 Jupyter Notebooks to clean missing values, handle anomalies, and structure the data.
*   **Exploratory Data Analysis (EDA):** **SQL** queries to extract deep initial patterns, group behaviors, and test hypotheses.
*   **Data Visualization:** **Tableau** used to build 3 highly interactive, custom-designed dashboards featuring a clean, dark-themed UI.
*   **Data Storytelling:** Custom **PowerPoint** Executive Presentation created to translate visual data directly into strategic business actions.

## 💡 Key Business Insights
1.  **The "First-Year Flight" (46% Risk):** Nearly half of all resignations happen in year one, pointing to a severe onboarding or expectation mismatch.
2.  **Compensation Inequity:** Bonus structures heavily overlap across performance scores. Low performers frequently receive bonuses equal to top talent, destroying motivation and driving high-performer exits.
3.  **Career Stagnation:** Employees without recent promotions exhibit a **17% attrition rate** (compared to 12% for promoted staff), proving that the lack of visible career paths drives exits.
4.  **The Workload Paradox:** The lowest Work-Life Balance scores correlate directly with the highest average overtime (15.3%), acting as a clear indicator of localized burnout.

## ✅ Strategic Recommendations
*   **Overhaul Onboarding:** Implement strict 30-60-90 day check-ins and assign mentors for all new hires.
*   **Standardize Bonus Allocations:** Conduct an immediate audit of the compensation framework to ensure bonuses are strictly tied to performance scores, not just job levels.
*   **Unblock Career Progression:** Define transparent promotion criteria and timelines, specifically targeting Lead and Senior positions (where attrition is unusually high).

---

## 📁 Repository Structure
*   📂 `Final data/` - The cleaned and preprocessed datasets.
*   📂 `Raw data/` - The original, raw datasets.
*   📂 `dashboards/` - Exported high-quality images of the Tableau dashboards.
*   📂 `notebooks/` - Python Jupyter notebooks used for data preprocessing and cleaning.
*   📄 `Final Presentation.pptx` - PowerPoint file containing the Executive Summary slides.
*   📄 `HR Manager Request.pdf` - The original business objective and requirements from management.
*   📄 `dashboards.twb` - The Tableau workbook containing all interactive visualizations.
*   📄 `SQL queries.sql` - SQL scripts used for exploratory data analysis.
*   📄 `final report.pdf` - The detailed narrative report delivered to management.

---

## 🖼️ Dashboards Showcase

### 1. Attrition Overview
*(This dashboard provides a high-level view of headcount, overall attrition rates, and the historical trend of leavers, highlighting the risk across different demographics.)*

![Attrition Overview Dashboard](./dashboards/first%20dashboard.png)

### 2. Attendance & Engagement
*(This dashboard links workload metrics like overtime and sick leave with Work-Life Balance scores to identify burnout zones and manager satisfaction impacts.)*

![Attendance and Engagement Dashboard](./dashboards/second%20dashboard.png)

### 3. Performance & Compensation
*(The final dashboard uncovers the critical discrepancies in the reward system, showing how performance scores relate to bonus payouts and the massive loss of high-performing talent.)*

![Performance and Compensation Dashboard](./dashboards/third%20dashboard.png)

---
*Developed by **Mazen Ashraf Abdel Hamid** for portfolio demonstration purposes.*
