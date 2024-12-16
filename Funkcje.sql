-- 1. Funkcja: Lista zawodników z ich statystykami i drużynami
CREATE OR REPLACE FUNCTION get_players_with_stats()
RETURNS TABLE (
    player_id INT,
    player_name VARCHAR,
    team_name VARCHAR,
    position_name VARCHAR,
    goals INT,
    assists INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.player_id,
        CONCAT(p.first_name, ' ', p.last_name) AS player_name,
        t.team_name,
        pos.name AS position_name,
        ps.goals,
        ps.assists
    FROM Players p
    JOIN Teams t ON p.team_id = t.team_id
    JOIN Positions pos ON p.position_id = pos.position_id
    LEFT JOIN Players_Statistics ps ON p.player_id = ps.player_id;
END;
$$ LANGUAGE plpgsql;

-- 2. Funkcja: Szczegóły o wybranej drużynie
CREATE OR REPLACE FUNCTION get_team_details(team_id_param INT)
RETURNS TABLE (
    team_name VARCHAR,
    city VARCHAR,
    stadium_name VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.team_name,
        t.city,
        s.stadium_name
    FROM Teams t
    JOIN Stadiums s ON t.stadium_id = s.stadium_id
    WHERE t.team_id = team_id_param;
END;
$$ LANGUAGE plpgsql;

-- 3. Funkcja: Lista trenerów i ich drużyn
CREATE OR REPLACE FUNCTION get_coaches_with_teams()
RETURNS TABLE (
    coach_name VARCHAR,
    team_name VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        CONCAT(c.first_name, ' ', c.last_name) AS coach_name,
        t.team_name
    FROM Coaches c
    JOIN Teams t ON c.team_id = t.team_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION getOstatnieMecze()
RETURNS TABLE(id INT, home_team TEXT, away_team TEXT, match_date DATE, score TEXT) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        m.id, 
        m.home_team, 
        m.away_team, 
        m.match_date, 
        m.score 
    FROM matches m
    ORDER BY m.match_date DESC
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;
