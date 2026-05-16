# Olympics SQL Analysis

## Project Overview

This project analyzes 120 years of Olympic history using MySQL. The dataset contains athlete participation and medal records from 1896 to 2016 across both Summer and Winter Olympics. The goal is to answer key questions about countries, athletes, sports, and medal trends using SQL.

---

## Database Schema

The database contains two tables — olympics_history and olympics_history_noc_regions.

- olympics_history stores athlete-level data including name, sex, age, height, weight, team, NOC code, games, year, season, city, sport, event, and medal.
- olympics_history_noc_regions maps each NOC code to a country region name.

---

## Data Cleaning

The age column contains string values including 'NA' for missing ages, which needed to be handled before performing age-based calculations. Medal values are stored as text including 'NA' for no medal, so all medal-related queries filter out 'NA' explicitly. No other major cleaning was required as the dataset was relatively structured.

---

## SQL Topics Covered

- Aggregate functions — COUNT, MAX, ROUND
- Joins — INNER JOIN and LEFT JOIN across tables
- Filtering — WHERE and HAVING with multiple conditions
- Grouping — GROUP BY with ORDER BY
- Subqueries — correlated and non-correlated subqueries in WHERE and HAVING
- Common Table Expressions — WITH clause for multi-step logic
- Window functions — FIRST_VALUE with PARTITION BY and ORDER BY
- CASE WHEN — for pivot-style medal breakdown by type
- String handling — CAST and CONCAT for data transformation
- DISTINCT — for counting unique games, sports, and nations

---

## Questions Answered

The analysis covers 20 questions including total Olympic games held, nations participating per game, highest and lowest participation years, nations attending every games, male to female ratio, top medal-winning athletes and countries, sports played in every Summer Olympics, sports played only once, oldest gold medalist, medal tallies by country and by game, countries with no gold medals, and India's performance in Hockey.

---

## Tools Used

- MySQL — database creation and all SQL queries
- MySQL Workbench — query execution and testing

---

## How to Run

1. Open MySQL Workbench and run the data loading script to create the tables and insert the data.
2. Run the queries file to execute all
