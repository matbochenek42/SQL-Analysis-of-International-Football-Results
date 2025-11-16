--DROP DATABASE IF EXISTS football_database;

CREATE DATABASE football_database;


CREATE TABLE former_names --zmiana nazw państw
(
    current VARCHAR(100),
    former VARCHAR(100),
    start_date DATE,
    end_date DATE
);

ALTER TABLE public.former_names OWNER to postgres;

COPY former_names FROM '...\International football results from 1872 to 2025\data\former_names.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE goalscorers --dane zawierające informacje o strzelcach
(
    date DATE,
    home_team VARCHAR(100),
    away_team VARCHAR(100),
    team VARCHAR(100),
    scorer VARCHAR(100),
    minute INT,
    own_goal BOOLEAN,
    penalty BOOLEAN
);

ALTER TABLE public.goalscorers OWNER to postgres;

COPY goalscorers FROM '...\International football results from 1872 to 2025\data\goalscorers.csv' DELIMITER ',' CSV HEADER NULL 'NA';


CREATE TABLE results -- wyniki meczów
(
    date DATE,
    home_team VARCHAR(100),
    away_team VARCHAR(100),
    home_score INT,
    away_score INT,
    tournament VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100),
    neutral BOOLEAN
);

ALTER TABLE public.results OWNER to postgres;

COPY results FROM '...\International football results from 1872 to 2025\data\results.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE shootouts -- karne 
(
    date DATE,
    home_team VARCHAR(100),
    away_team VARCHAR(100),
    winner VARCHAR(100),
    first_shooter VARCHAR(100)
);

ALTER TABLE public.shootouts OWNER to postgres;

COPY shootouts FROM '...\International football results from 1872 to 2025\data\shootouts.csv' DELIMITER ',' CSV HEADER;



SELECT * FROM goalscorers LIMIT 10;

SELECT * FROM former_names;

SELECT * FROM results LIMIT 10;

SELECT * FROM shootouts LIMIT 10;
