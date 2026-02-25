# 📊 SQL Analysis of International Football Results 

## 📚 Table of Contents
- **Project Overview**
- **Data Overview**
- **Structure Explanation**
- **How to Run**
- **Sample Queries**
- **Technical Details**
- **Author**

## 🔎 Project Overview

The goal of this project is to analyze international football data from 1872 to 2025 using PostgreSQL. Analysis itself is divided into three separate SQL file(plus an additional one that establishes the database), followed later by Excel files that contain charts which visually represent SQL outputs. The project takes closer look at players stats, country comparisons and other.

## 📂 Data Overview

The dataset consists of **four CSV files**:

- `goalscorers.csv` – contains match date, player name, team, minute of the goal, etc.  
- `results.csv` – contains match date, teams, score, host country, etc.  
- `shootouts.csv` – contains penalty shootout data (not used in this project).  
- `former_names.csv` – contains former and current country names mappings (not used in this project).  

**Data source:** [Kaggle International Football Results Dataset](https://www.kaggle.com/datasets/martj42/international-football-results-from-1872-to-2017) 


## 🧱 Structure Explanation

| Folder / File | Description |
|----------------|-------------|
| **data/** | Contains original data files |
| **sql_queries/** | SQL scripts used for analysis |
| **visualization/** | Excel charts used to visualize analysis |
| **README.md** | Project overview 


## ⚙️ How to Run

1. Install PostgreSQL locally 
2. Download the entire folder
3. Run SQL scripts starting with file ***1_Create_DB.sql***
4. Update all directory paths in [1_Create_DB.sql](sql%20queries/0.%20create.sql) file

## 📈 Sample Queries

### The best scorers every decade

Query: [Top scorers in every decade](sql_queries/2_Individual_Stats_Analysis.sql)

**Visualization:**

![Top Scorers by Decade](visualization/images/1__Top_scorers_in_every_decade.png)

**Insights:**

<p style="text-align:justify;">
    It appears that players tend to score more and more goals with each passing decade. The best national scorer is Ronaldo (2010s). The best scorer in current decade is Harry Kane, who has scored almost half as many goals as Ronaldo. However, the decade isn't over yet!
</p>

### Argentina vs Brazil

Query: [Comparison between Brazil and Argentina (results and goals)](sql_queries/3_Team_Stats_Analysis.sql)

**Visualization:**

![Brazil vs Argentina](visualization/images/2_Brazil_vs_Argentina.png)

**Insights:**

<p style="text-align:justify;">
    The query compares direct results for Argentina and Brazil - one of the most famous and oldest national rivalries. According to results, Brazil has won 2 more games against Argentina and scored two goals more. This emphasizes how close and competitive the rivalry has been.
</p>

### Most Popular Third-Country Match Locations

Query: [3.1 The most popular places where home or away country didn't participate in the game](sql_queries/4_Most_Popular_Places.sql)

**Visualization:**

![Most popular places](visualization/images/3_Chart_Most_Popular_Places.png)

**Insights:**


The query shows what are the most famous third-countries match locations(host countries that didn't participate in the game). The most popularcountry is the USA with 997 games, then Malaysia with 508 games andFrance with 442 games. Other popular places are: Latin America, MiddleEast, West Africa. It is worth to notice that Western Europe is waybehind those locations. 


## 🖥️ Technical Details

- **DBMS:** PostgreSQL
- **Environment:** Visual Studio Code
- **Visualization:** Excel 
- **Data source:** [Kaggle International Football Results Dataset](https://www.kaggle.com/datasets/martj42/international-football-results-from-1872-to-2017) 


## ✒️ Author

- **Author:** Mateusz Bochenek
- **Mail:** matbochenek42@gmail.com
- **GitHub link:** https://github.com/matbochenek42
- **LeetCode link:** https://leetcode.com/u/SmO7BWmsiz/
