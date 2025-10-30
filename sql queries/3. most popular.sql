--3.1 The most popular places where home or away country didn't participate in the game

SELECT
    country,
    COUNT(*) num_of_games
FROM
    results
WHERE
    home_team != country AND away_team != country
GROUP BY
    country
HAVING
    COUNT(*) > 50
ORDER BY
    num_of_games DESC;
