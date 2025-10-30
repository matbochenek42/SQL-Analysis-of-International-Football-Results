
--2.1 Sum of goals scored grouped by a decade (since 70's) and the difference between current row and previous decade
WITH year_extracted AS --decades extracted
(
    SELECT 
        home_team,
        away_team,
        date,
        CASE 
            WHEN EXTRACT(YEAR FROM date) >= 1970 AND EXTRACT(YEAR FROM date) < 1979 THEN '1970-1979'
            WHEN EXTRACT(YEAR FROM date) >= 1980 AND EXTRACT(YEAR FROM date) < 1989 THEN '1980-1989'
            WHEN EXTRACT(YEAR FROM date) >= 1990 AND EXTRACT(YEAR FROM date) < 1999 THEN '1990-1999'
            WHEN EXTRACT(YEAR FROM date) >= 2000 AND EXTRACT(YEAR FROM date) < 2009 THEN '2000-2009'
            WHEN EXTRACT(YEAR FROM date) >= 2010 AND EXTRACT(YEAR FROM date) < 2020 THEN '2010-2009'
            WHEN EXTRACT(YEAR FROM date) >= 2020 AND EXTRACT(YEAR FROM date) < 2026 THEN '2020-NOW' 
        END decade
    FROM
        results
), 
final_result AS --goals by a decade
(
    SELECT DISTINCT
        ye.decade,
        SUM(home_score + away_score) AS goals
    FROM
        year_extracted ye
    JOIN
        results r ON r.home_team = ye.home_team AND r.away_team = ye.away_team AND r.date = ye.date
    WHERE
        ye.decade IS NOT NULL
    GROUP BY
        ye.decade
)
SELECT --final query
    *,
    LAG(goals) OVER(ORDER BY decade) previous_decade_value,
    100* (goals - LAG(goals) OVER(ORDER BY decade)) / LAG(goals) OVER(ORDER BY decade) previous_decade_diff
FROM 
    final_result f
ORDER BY
    f. decade;



--2.2.1 Top 10 nations with the most wins against Poland

WITH nation AS --won matches against Poland
(
    SELECT
        CASE 
            WHEN home_team = 'Poland' THEN away_team
            WHEN away_team = 'Poland' THEN home_team
        END nation_name,
        CASE
            WHEN home_team = 'Poland' AND home_score < away_score THEN 1
            WHEN away_team = 'Poland' AND home_score > away_score THEN 1
            ELSE 0
        END defeats
    FROM
        results
)
SELECT
    nation_name,
    COUNT(CASE WHEN defeats = 1 THEN 1 END) number_of_wins_against_pl
FROM
    nation
WHERE
    nation_name IS NOT NULL
GROUP BY
    nation_name
ORDER BY
    number_of_wins_against_pl DESC
LIMIT 10;

--2.2.2 Top 10 countries Poland has won against the most

WITH nation AS
(
    SELECT
        CASE 
            WHEN home_team = 'Poland' THEN away_team
            WHEN away_team = 'Poland' THEN home_team
        END nation_name,
        CASE
            WHEN home_team = 'Poland' AND home_score > away_score THEN 1
            WHEN away_team = 'Poland' AND home_score < away_score THEN 1
            ELSE 0
        END wins
    FROM
        results
)
SELECT
    nation_name,
    COUNT(CASE WHEN wins = 1 THEN 1 END) number_of_pl_wins
FROM
    nation
WHERE
    nation_name IS NOT NULL
GROUP BY
    nation_name
ORDER BY
    number_of_pl_wins DESC
LIMIT 10;


--2.2.3 Top 10 countries Poland has drawn with the most 

WITH nation AS
(
    SELECT
        CASE 
            WHEN home_team = 'Poland' AND away_score = home_score THEN away_team
            WHEN away_team = 'Poland' AND away_score = home_score THEN home_team
        END country
    FROM
        results
)
SELECT
    country,
    COUNT(*) number_of_draws_with_poland
FROM
    nation
WHERE
    country IS NOT NULL
GROUP BY
    country
ORDER BY
    number_of_draws_with_poland DESC
LIMIT 10;


--2.3 Top 20 countries that have the highest average of away goals in the last 10 years (only teams with more than 30 games played)

SELECT
    r.away_team away_team,
    ROUND(AVG(r.away_score),2) avg_away_goals
FROM
    results r
WHERE
    date >= CURRENT_DATE - INTERVAL '120 months'
GROUP BY
    r.away_team
HAVING
    COUNT(*) > 30
ORDER BY
    avg_away_goals DESC
LIMIT 15;



--2.4 Comparison between Brazil and Argentina (results and goals)

WITH match AS --all matches between Brazil and Argentina 
(
    SELECT --matches and scores between Br and Arg 
        home_team, 
        away_team,
        home_score,
        away_score
    FROM
        results
    WHERE
        (home_team = 'Argentina' AND away_team = 'Brazil')
        OR (home_team = 'Brazil' AND away_team = 'Argentina')
),
team AS --home_team results and goals scored during the match
(
    SELECT --
        home_team country,
        CASE 
            WHEN home_score > away_score THEN 'win'
            WHEN home_score < away_score THEN 'lose'
            ELSE 'draw'
        END result,
        home_score goals
    FROM 
        match

    UNION ALL

    SELECT --away_team results and goals scored during the match
        away_team country,
        CASE 
            WHEN away_score > home_score THEN 'win'
            WHEN away_score < home_score THEN 'lose'
            ELSE 'draw'
        END result,
        away_score goals
    FROM 
        match
)
SELECT
    country,
    COUNT(CASE WHEN result = 'win' THEN 1 END) wins,
    COUNT(CASE WHEN result = 'lose' THEN 1 END) losses,
    COUNT(CASE WHEN result = 'draw' THEN 1 END) draws,
    SUM(goals) goals_scored
FROM
    team
GROUP BY
    country;


--2.5 Countries ordered by an elo system (win = 3 points, lose = 0, draw = 1)

WITH match AS 
(
    SELECT 
        home_team, 
        away_team,
        home_score,
        away_score
    FROM
        results
),
team AS
(
    SELECT --
        home_team country,
        CASE 
            WHEN home_score > away_score THEN 3
            WHEN home_score < away_score THEN 0
            ELSE 1
        END result
    FROM 
        match

    UNION ALL

    SELECT
        away_team country,
        CASE 
            WHEN away_score > home_score THEN 3
            WHEN away_score < home_score THEN 0
            ELSE 1
        END result
    FROM 
        match
),
add_table AS
(
    SELECT
        country,
        SUM(result) elo_points
    FROM
        team
    GROUP BY
        country
)
SELECT
    DENSE_RANK() OVER(ORDER BY elo_points DESC) AS place,
    *
FROM
    add_table
ORDER BY
    elo_points DESC
LIMIT 100;


--2.6 Average countries elo points change over the months of 2014

WITH match AS 
(
    SELECT
        TO_CHAR(date,'YYYY-MM') as month,
        home_team, 
        away_team,
        home_score,
        away_score
    FROM
        results
),
team AS
(
    SELECT --
        month,
        home_team country,
        CASE 
            WHEN home_score > away_score THEN 3
            WHEN home_score < away_score THEN 0
            ELSE 1
        END result
    FROM 
        match

    UNION ALL

    SELECT
        month,
        away_team country,
        CASE 
            WHEN away_score > home_score THEN 3
            WHEN away_score < home_score THEN 0
            ELSE 1
        END result
    FROM 
        match
)
SELECT DISTINCT
    month,
    country,
    ROUND(AVG(result) OVER(PARTITION BY country, month ORDER BY country, month),2) avg_elo_points_over_time
FROM
    team
WHERE
    month >= '2014-01' AND month <= '2014-12'
ORDER BY
    country,
    month;