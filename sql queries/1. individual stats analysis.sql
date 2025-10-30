
--1.1 Top 10 scorers of all time 

WITH scorers AS -- top scorers queary
(
    SELECT
        scorer,
        COUNT(*) AS goals_scored
    FROM
        goalscorers
    WHERE
        scorer IS NOT NULL
    GROUP BY
        scorer
)
SELECT
    ROW_NUMBER() OVER(ORDER BY goals_scored DESC) number, -- row_number added 
    *
FROM
    scorers
ORDER BY
    goals_scored DESC
LIMIT 10;


--1.2 Top 10 Polish scorers

SELECT --adding row number
    ROW_NUMBER() OVER() nr,
    * 
FROM
(
    SELECT --top polish scorers 
        scorer,
        COUNT(*) AS goals_scored
    FROM
        goalscorers
    WHERE
        scorer IS NOT NULL AND team = 'Poland'
    GROUP BY
        scorer
)
ORDER BY
    goals_scored DESC
LIMIT 10;


--1.3 Top scorers in every decade     

WITH decades AS --stats (year, scorer's name, country, and num of goals)
(
    SELECT
        (EXTRACT(YEAR FROM date)::INT / 10) * 10 decade,
        scorer,
        team,
        COUNT(*) num_of_goals
    FROM
        goalscorers
    WHERE
        scorer IS NOT NULL
    GROUP BY
        decade,
        team,
        scorer
), add_t AS
(
    SELECT --max goals for every decade
        decade,
        MAX(num_of_goals) AS most_goals
    FROM
        decades
    GROUP BY
        decade
)
SELECT
   CONCAT(add_t.decade::TEXT,'s') decade,
   d.scorer,
   team country,
   add_t.most_goals
FROM
    add_t
JOIN
    decades d ON add_t.decade = d.decade AND d.num_of_goals = add_t.most_goals --joinig ctes
ORDER BY
    1;


--1.4 Top scorers that change the final result of the game in the key moment 

SELECT
    ROW_NUMBER() OVER(ORDER BY sum_of_goals DESC),
    *
FROM
(
    SELECT
        g.team,
        g.scorer,
        COUNT(*) AS sum_of_goals
    FROM
        goalscorers g
    JOIN
        results r ON g.date = r.date AND g.home_team = r.home_team AND g.away_team = r.away_team
    WHERE
        g.minute >= 80 AND ((g.team = r.home_team AND (home_score - 1 = away_score OR home_score = away_score)) OR (g.team = r.away_team AND (away_score - 1 = home_score OR home_score = away_score))) -- goals that change the final result (draw or win)
    GROUP BY
        g.team,
        g.scorer
)
ORDER BY
    sum_of_goals DESC
LIMIT 10;



--1.5 Top 15 players with the biggest percentage of goals scored from penalties (for players with total goals scored higher than 20)

WITH penalty_goals AS --penalty goals
(
    SELECT
        scorer,
        CASE
            WHEN penalty = 'True' THEN 1
            ELSE 0
        END penalty_goals
    FROM
        goalscorers
),
all_goals AS --all goals
(
    SELECT
        p.scorer,
        COUNT(*) AS goals_total,
        SUM(CASE WHEN p.penalty_goals = 1 THEN 1 ELSE 0 END)::NUMERIC pen_goals
    FROM
        penalty_goals AS p
    GROUP BY
        p.scorer
    HAVING
        COUNT(*) > 20
)
SELECT
    scorer,
    goals_total,
    pen_goals,
    ROUND(pen_goals*100 / goals_total, 2) percentage_of_goals_scored_from_pen
FROM
    all_goals
WHERE
    scorer IS NOT NULL 
ORDER BY
    percentage_of_goals_scored_from_pen DESC
LIMIT 15;