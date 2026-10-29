# Social Media Usage and Engagement Analysis Using R

## 📌 Project Overview

Social Media Usage and Engagement Analysis is an interactive dashboard developed using R programming and Shiny. It analyzes social media usage patterns and engagement metrics across platforms such as Instagram, YouTube, Facebook, TikTok, and X.

The dashboard provides summary statistics, interactive charts, filtering options, and a data table to help users explore social media data.

## 🎯 Objectives

- Analyze daily social media usage hours.
- Compare usage across different social media platforms.
- Examine likes, comments, and shares.
- Compare engagement across content types.
- Explore the relationship between daily usage and engagement.
- Present insights through an interactive dashboard.

## 🛠️ Technologies Used

- R Programming
- RStudio Desktop
- Shiny
- ggplot2
- dplyr
- DT
- bslib
- CSV for data storage

## 📁 Project Structure

```text
social-media-usage-engagement-analysis/
│
├── app.R
├── social_media_data.csv
└── README.md
```

The CSV file is created automatically when the application runs for the first time, provided it does not already exist.

## ⚙️ Installation and Setup

### 1. Install R

Download R from:
https://cran.r-project.org/bin/windows/base/

### 2. Install RStudio

Download RStudio Desktop from:
https://posit.co/download/rstudio-desktop/

### 3. Install Required Packages

Open RStudio and run the following command in the Console:

```r
install.packages(c("shiny", "ggplot2", "dplyr", "DT", "bslib"))
```

### 4. Run the Project

1. Download or clone this repository.
2. Open the project folder in RStudio.
3. Open `app.R`.
4. Click **Run App**.
5. Explore the dashboard in the RStudio Viewer or your web browser.

## 📈 Dashboard Sections

### 1. Overview
Displays summary cards and platform-wise usage and engagement charts.

### 2. Engagement Analysis
Shows the relationship between daily usage hours and engagement, along with engagement comparisons by content type.

### 3. Data Explorer
Displays filtered social media records in an interactive table and allows CSV downloads.

## 🧮 Engagement Calculation

Total engagement is calculated as:

**Engagement = Likes + Comments + Shares**

This project uses a simple interaction count rather than a standardized engagement rate.

## 🔍 Expected Outcomes

- Understand usage patterns in the sample dataset.
- Compare social media platforms.
- Examine differences in engagement metrics.
- Practice data analysis and visualization using R.
- Develop an interactive dashboard using Shiny.

## 🚀 Future Scope

- Use a genuine, properly licensed social media dataset.
- Add date-wise and monthly trend analysis.
- Include a defined engagement rate using impressions or reach.
- Add more filters and visualizations.
- Explore statistical or predictive analysis.


