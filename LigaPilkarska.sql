--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-01-12 21:00:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 252 (class 1255 OID 24662)
-- Name: add_coach(text, text, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_coach(IN p_first_name text, IN p_last_name text, IN p_team_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO coaches (first_name, last_name, team_id)
    VALUES (p_first_name, p_last_name, p_team_id);
END;
$$;


ALTER PROCEDURE public.add_coach(IN p_first_name text, IN p_last_name text, IN p_team_id integer) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 24743)
-- Name: add_coach_by_team_name(character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_coach_by_team_name(IN p_first_name character varying, IN p_last_name character varying, IN p_team_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    team_id integer;
BEGIN
    -- Wyszukanie ID zespołu na podstawie jego nazwy
    SELECT t.team_id INTO team_id
    FROM teams t
    WHERE t.team_name = p_team_name;

    -- Dodanie trenera do bazy danych
    INSERT INTO coaches (first_name, last_name, team_id)
    VALUES (p_first_name, p_last_name, team_id);
END;
$$;


ALTER PROCEDURE public.add_coach_by_team_name(IN p_first_name character varying, IN p_last_name character varying, IN p_team_name character varying) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 24644)
-- Name: add_match(character varying, character varying, integer, integer, date, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_match(IN p_home_team_name character varying, IN p_away_team_name character varying, IN p_home_team_score integer, IN p_away_team_score integer, IN p_match_date date, IN p_stadium_name character varying, IN p_referee_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    home_team_id INTEGER;
    away_team_id INTEGER;
    stadium_id INTEGER;
    referee_id INTEGER;
BEGIN
    -- Pobranie ID drużyn
    SELECT t.team_id INTO home_team_id FROM teams t WHERE t.team_name = p_home_team_name;
    SELECT t.team_id INTO away_team_id FROM teams t WHERE t.team_name = p_away_team_name;

    -- Pobranie ID stadionu (z aliasem)
    SELECT s.stadium_id INTO stadium_id FROM stadiums s WHERE s.stadium_name = p_stadium_name;

    -- Pobranie ID sędziego (z aliasem)
    SELECT r.referee_id INTO referee_id FROM referees r WHERE CONCAT(r.first_name, ' ', r.last_name) = p_referee_name;

    -- Sprawdzenie poprawności danych
    IF home_team_id IS NULL THEN
        RAISE EXCEPTION 'Drużyna gospodarzy % nie istnieje', p_home_team_name;
    END IF;

    IF away_team_id IS NULL THEN
        RAISE EXCEPTION 'Drużyna gości % nie istnieje', p_away_team_name;
    END IF;

    IF stadium_id IS NULL THEN
        RAISE EXCEPTION 'Stadion % nie istnieje', p_stadium_name;
    END IF;

    IF referee_id IS NULL THEN
        RAISE EXCEPTION 'Sędzia % nie istnieje', p_referee_name;
    END IF;

    -- Wstawienie meczu (z aliasami)
    INSERT INTO matches (home_team_id, away_team_id, home_team_score, away_team_score, match_date, stadium_id, referee_id)
    VALUES (home_team_id, away_team_id, p_home_team_score, p_away_team_score, p_match_date, stadium_id, referee_id);
END;
$$;


ALTER PROCEDURE public.add_match(IN p_home_team_name character varying, IN p_away_team_name character varying, IN p_home_team_score integer, IN p_away_team_score integer, IN p_match_date date, IN p_stadium_name character varying, IN p_referee_name character varying) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 16515)
-- Name: add_match_referee(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_match_referee(IN m_match_id integer, IN m_referee_id integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    INSERT INTO match_referees(
	    match_id, referee_id
    )
	VALUES (
        m_match_id, m_referee_id
    );
END; 
$$;


ALTER PROCEDURE public.add_match_referee(IN m_match_id integer, IN m_referee_id integer) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 24744)
-- Name: add_player(character, character, character, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_player(IN first_name_param character, IN last_name_param character, IN name_param character, IN team_name_param character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    v_position_id INT;
    v_team_id INT;
BEGIN
    -- Pobierz ID pozycji na podstawie jej nazwy
    SELECT pos.position_id INTO v_position_id 
    FROM positions pos 
    WHERE pos.name = name_param;
    
    IF v_position_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono pozycji %', name_param;
    END IF;

    -- Pobierz ID drużyny na podstawie jej nazwy
    SELECT t.team_id INTO v_team_id 
    FROM teams t 
    WHERE t.team_name = team_name_param;
    
    IF v_team_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono drużyny %', team_name_param;
    END IF;

    -- Dodanie gracza do bazy danych
    INSERT INTO players (first_name, last_name, position_id, team_id)
    VALUES (first_name_param, last_name_param, v_position_id, v_team_id);
END;
$$;


ALTER PROCEDURE public.add_player(IN first_name_param character, IN last_name_param character, IN name_param character, IN team_name_param character varying) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 24686)
-- Name: add_player_statistics(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_player_statistics() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO players_statistics (player_id, goals, assists, yellow_cards, red_cards, clean_sheet)
    VALUES (NEW.player_id, 0, 0, 0, 0, 0); -- Ustawienie wartości domyślnych
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.add_player_statistics() OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 16523)
-- Name: add_players_statistic(integer, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_players_statistic(IN p_player_id integer, IN p_goals integer, IN p_assists integer, IN p_yellow_vards integer, IN p_red_cards integer, IN p_clean_sheet integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    INSERT INTO public.players_statistics(
	    player_id, goals, assists, yellow_vards, red_cards, clean_sheet)
	VALUES (p_player_id, p_goals, p_assists, p_yellow_vards, p_red_cards, p_clean_sheet);
END; 
$$;


ALTER PROCEDURE public.add_players_statistic(IN p_player_id integer, IN p_goals integer, IN p_assists integer, IN p_yellow_vards integer, IN p_red_cards integer, IN p_clean_sheet integer) OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 16526)
-- Name: add_position(character); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_position(IN p_name character)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    INSERT INTO positions (name)  
    VALUES (p_name); 
END; 
$$;


ALTER PROCEDURE public.add_position(IN p_name character) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 24703)
-- Name: add_referee(character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_referee(IN first_name_param character varying, IN last_name_param character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO referees (first_name, last_name)
    VALUES (first_name_param, last_name_param);
END;
$$;


ALTER PROCEDURE public.add_referee(IN first_name_param character varying, IN last_name_param character varying) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 24720)
-- Name: add_stadium(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_stadium(IN stadium_name_param character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO stadiums (stadium_name)
    VALUES (stadium_name_param);
END;
$$;


ALTER PROCEDURE public.add_stadium(IN stadium_name_param character varying) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 24745)
-- Name: add_team(character, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_team(IN team_name_param character, IN stadium_name_param character varying, IN city_param character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    v_stadium_id INT;
BEGIN
    -- Pobranie ID stadionu na podstawie nazwy
    SELECT stadium_id INTO v_stadium_id FROM stadiums WHERE stadium_name = stadium_name_param;
    
    -- Jeśli stadion nie istnieje, zgłoś błąd
    IF v_stadium_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono stadionu %', stadium_name_param;
    END IF;

    -- Dodanie drużyny
    INSERT INTO teams (team_name, stadium_id, city, points, matches_played, wins, draws, losses, goals_scored, goals_conceded)
    VALUES (team_name_param, v_stadium_id, city_param, 0, 0, 0, 0, 0, 0, 0);
END;
$$;


ALTER PROCEDURE public.add_team(IN team_name_param character, IN stadium_name_param character varying, IN city_param character varying) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 24620)
-- Name: delete_coach(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_coach(IN p_coach_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM coaches WHERE coach_id = p_coach_id;
END;
$$;


ALTER PROCEDURE public.delete_coach(IN p_coach_id integer) OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 24637)
-- Name: delete_match(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_match(IN p_match_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM matches WHERE match_id = p_match_id;
END;
$$;


ALTER PROCEDURE public.delete_match(IN p_match_id integer) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 16516)
-- Name: delete_match_referee(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_match_referee(IN m_match_id integer, IN m_referee_id integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    DELETE FROM matches 
    WHERE   match_id = m_match_id
        AND referee_id  = m_referee_id; 
END; 
$$;


ALTER PROCEDURE public.delete_match_referee(IN m_match_id integer, IN m_referee_id integer) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 24674)
-- Name: delete_player(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_player(IN player_id_param integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM players WHERE player_id = player_id_param;
END;
$$;


ALTER PROCEDURE public.delete_player(IN player_id_param integer) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 24688)
-- Name: delete_player_statistics(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_player_statistics() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM players_statistics WHERE player_id = OLD.player_id;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.delete_player_statistics() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 16524)
-- Name: delete_players_statistic(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_players_statistic(IN p_player_statistic_id integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    DELETE FROM players_statistics WHERE player_statistic_id = p_player_statistic_id; 
END; 
$$;


ALTER PROCEDURE public.delete_players_statistic(IN p_player_statistic_id integer) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 16527)
-- Name: delete_position(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_position(IN p_position_id integer)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    DELETE FROM positions WHERE position_id = p_position_id; 
END; 
$$;


ALTER PROCEDURE public.delete_position(IN p_position_id integer) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 24705)
-- Name: delete_referee(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_referee(IN referee_id_param integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM referees
    WHERE referee_id = referee_id_param;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Sędzia o ID % nie istnieje', referee_id_param;
    END IF;
END;
$$;


ALTER PROCEDURE public.delete_referee(IN referee_id_param integer) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 24709)
-- Name: delete_stadium(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_stadium(IN stadium_id_param integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM stadiums
    WHERE stadium_id = stadium_id_param;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Stadion o ID % nie istnieje', stadium_id_param;
    END IF;
END;
$$;


ALTER PROCEDURE public.delete_stadium(IN stadium_id_param integer) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 24731)
-- Name: delete_team(bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_team(IN team_id_param bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM teams WHERE team_id = team_id_param;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Drużyna o ID % nie istnieje', team_id_param;
    END IF;
END;
$$;


ALTER PROCEDURE public.delete_team(IN team_id_param bigint) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 24664)
-- Name: edit_coach(integer, text, text, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.edit_coach(IN p_coach_id integer, IN p_first_name text, IN p_last_name text, IN p_team_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE coaches
    SET first_name = p_first_name,
        last_name = p_last_name,
        team_id = p_team_id
    WHERE coach_id = p_coach_id;
END;
$$;


ALTER PROCEDURE public.edit_coach(IN p_coach_id integer, IN p_first_name text, IN p_last_name text, IN p_team_id integer) OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 24726)
-- Name: edit_match_by_team_names(integer, text, text, integer, integer, date, text, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.edit_match_by_team_names(IN p_match_id integer, IN p_home_team_name text, IN p_away_team_name text, IN p_home_team_score integer, IN p_away_team_score integer, IN p_match_date date, IN p_stadium_name text, IN p_referee_name text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_home_team_id integer;
    v_away_team_id integer;
    v_stadium_id integer;
    v_referee_id integer;
BEGIN
    -- Wyszukanie ID drużyn na podstawie ich nazw
    SELECT team_id INTO v_home_team_id FROM teams WHERE team_name = p_home_team_name;
    SELECT team_id INTO v_away_team_id FROM teams WHERE team_name = p_away_team_name;

    -- Wyszukanie ID stadionu na podstawie jego nazwy
    SELECT stadium_id INTO v_stadium_id FROM stadiums WHERE TRIM(stadium_name) = TRIM(p_stadium_name);

    -- Wyszukanie ID sędziego na podstawie jego imienia i nazwiska
    SELECT referee_id INTO v_referee_id FROM referees WHERE TRIM(first_name || ' ' || last_name) = TRIM(p_referee_name);

    -- Sprawdzenie, czy wszystkie dane są poprawne
    IF v_home_team_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono drużyny gospodarzy: %', p_home_team_name;
    END IF;

    IF v_away_team_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono drużyny gości: %', p_away_team_name;
    END IF;

    IF v_stadium_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono stadionu: %', p_stadium_name;
    END IF;

    IF v_referee_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono sędziego: %', p_referee_name;
    END IF;

    -- Aktualizacja meczu w bazie danych
    UPDATE matches
    SET home_team_id = v_home_team_id,
        away_team_id = v_away_team_id,
        home_team_score = p_home_team_score,
        away_team_score = p_away_team_score,
        match_date = p_match_date,
        stadium_id = v_stadium_id,
        referee_id = v_referee_id
    WHERE match_id = p_match_id;
END;
$$;


ALTER PROCEDURE public.edit_match_by_team_names(IN p_match_id integer, IN p_home_team_name text, IN p_away_team_name text, IN p_home_team_score integer, IN p_away_team_score integer, IN p_match_date date, IN p_stadium_name text, IN p_referee_name text) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 24754)
-- Name: edit_player(bigint, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.edit_player(IN p_player_id bigint, IN p_first_name character varying, IN p_last_name character varying, IN p_position_name character varying, IN p_team_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    v_position_id INT;
    v_team_id INT;
    v_row_count INT;
BEGIN
    -- Pobranie ID pozycji na podstawie jej nazwy
    SELECT position_id INTO v_position_id FROM positions WHERE name = p_position_name;
    IF v_position_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono pozycji: %', p_position_name;
    END IF;

    -- Pobranie ID drużyny na podstawie jej nazwy
    SELECT team_id INTO v_team_id FROM teams WHERE team_name = p_team_name;
    IF v_team_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono drużyny: %', p_team_name;
    END IF;

    -- Aktualizacja danych gracza
    UPDATE players
    SET 
        first_name = p_first_name,
        last_name = p_last_name,
        position_id = v_position_id,
        team_id = v_team_id
    WHERE player_id = p_player_id;

    -- Sprawdzenie, czy aktualizacja się powiodła
    GET DIAGNOSTICS v_row_count = ROW_COUNT;
    IF v_row_count = 0 THEN
        RAISE EXCEPTION 'Gracz o ID % nie istnieje', p_player_id;
    END IF;
END;
$$;


ALTER PROCEDURE public.edit_player(IN p_player_id bigint, IN p_first_name character varying, IN p_last_name character varying, IN p_position_name character varying, IN p_team_name character varying) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 24701)
-- Name: edit_player_statistics(integer, integer, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.edit_player_statistics(IN player_id integer, IN new_goals integer, IN new_assists integer, IN new_yellow_cards integer, IN new_red_cards integer, IN new_clean_sheets integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy gracz istnieje w `players_statistics`
    IF NOT EXISTS (SELECT 1 FROM players_statistics WHERE players_statistics.player_id = edit_player_statistics.player_id) THEN
        RAISE EXCEPTION 'Nie znaleziono statystyk dla gracza o ID %', players_statistics.player_id;
    END IF;

    -- Aktualizacja statystyk gracza
    UPDATE players_statistics
    SET goals = new_goals,
        assists = new_assists,
        yellow_cards = new_yellow_cards,
        red_cards = new_red_cards,
        clean_sheet = new_clean_sheets
    WHERE players_statistics.player_id = edit_player_statistics.player_id;
END;
$$;


ALTER PROCEDURE public.edit_player_statistics(IN player_id integer, IN new_goals integer, IN new_assists integer, IN new_yellow_cards integer, IN new_red_cards integer, IN new_clean_sheets integer) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 24704)
-- Name: edit_referee(integer, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.edit_referee(IN referee_id_param integer, IN first_name_param character varying, IN last_name_param character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE referees
    SET first_name = first_name_param,
        last_name = last_name_param
    WHERE referee_id = referee_id_param;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Sędzia o ID % nie istnieje', referee_id_param;
    END IF;
END;
$$;


ALTER PROCEDURE public.edit_referee(IN referee_id_param integer, IN first_name_param character varying, IN last_name_param character varying) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 24721)
-- Name: edit_stadium(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.edit_stadium(IN stadium_id_param integer, IN stadium_name_param character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE stadiums
    SET stadium_name = stadium_name_param
    WHERE stadium_id = stadium_id_param;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Stadion o ID % nie istnieje', stadium_id_param;
    END IF;
END;
$$;


ALTER PROCEDURE public.edit_stadium(IN stadium_id_param integer, IN stadium_name_param character varying) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 24733)
-- Name: edit_team(bigint, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.edit_team(IN p_team_id bigint, IN p_team_name character varying, IN p_stadium_name character varying, IN p_city character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    v_stadium_id INT;
    v_row_count INT;
BEGIN
    -- Pobranie ID stadionu na podstawie nazwy
    SELECT stadium_id INTO v_stadium_id FROM stadiums WHERE TRIM(stadium_name) = TRIM(p_stadium_name);
    
    -- Jeśli stadion nie istnieje, zgłoś błąd
    IF v_stadium_id IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono stadionu: %', p_stadium_name;
    END IF;

    -- Aktualizacja danych drużyny (BEZ PUNKTÓW)
    UPDATE teams
    SET 
        team_name = p_team_name,
        stadium_id = v_stadium_id,
        city = p_city
    WHERE team_id = p_team_id;

    -- Sprawdzenie, czy aktualizacja się powiodła
    GET DIAGNOSTICS v_row_count = ROW_COUNT;
    IF v_row_count = 0 THEN
        RAISE EXCEPTION 'Drużyna o ID % nie istnieje', p_team_id;
    END IF;
END;
$$;


ALTER PROCEDURE public.edit_team(IN p_team_id bigint, IN p_team_name character varying, IN p_stadium_name character varying, IN p_city character varying) OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 24798)
-- Name: get_all_matches_by_team(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_matches_by_team(team_id_param bigint) RETURNS TABLE(match_id bigint, home_team_name character varying, away_team_name character varying, home_team_score integer, away_team_score integer, match_date date, stadium_name character varying, location_type text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    (
        SELECT 
            m.match_id::BIGINT,
            ht.team_name AS home_team_name,
            at.team_name AS away_team_name,
            m.home_team_score,
            m.away_team_score,
            m.match_date,
            s.stadium_name,
            'u siebie' AS location_type
        FROM matches m
        JOIN teams ht ON m.home_team_id = ht.team_id
        JOIN teams at ON m.away_team_id = at.team_id
        JOIN stadiums s ON m.stadium_id = s.stadium_id
        WHERE m.home_team_id = team_id_param
        ORDER BY m.match_date DESC
    )
    UNION ALL
    (
        SELECT 
            m.match_id::BIGINT,
            ht.team_name AS home_team_name,
            at.team_name AS away_team_name,
            m.home_team_score,
            m.away_team_score,
            m.match_date,
            s.stadium_name,
            'na wyjeździe' AS location_type
        FROM matches m
        JOIN teams ht ON m.home_team_id = ht.team_id
        JOIN teams at ON m.away_team_id = at.team_id
        JOIN stadiums s ON m.stadium_id = s.stadium_id
        WHERE m.away_team_id = team_id_param
        ORDER BY m.match_date DESC
    );
END;
$$;


ALTER FUNCTION public.get_all_matches_by_team(team_id_param bigint) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 24702)
-- Name: get_all_referees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_referees() RETURNS TABLE(referee_id integer, first_name character varying, last_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT referees.referee_id, referees.first_name, referees.last_name
    FROM referees;
END;
$$;


ALTER FUNCTION public.get_all_referees() OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 24719)
-- Name: get_all_stadiums(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_stadiums() RETURNS TABLE(stadium_id integer, stadium_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT stadiums.stadium_id, stadiums.stadium_name
    FROM stadiums;
END;
$$;


ALTER FUNCTION public.get_all_stadiums() OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 24742)
-- Name: get_all_teams(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_teams() RETURNS TABLE(team_id integer, team_name character varying, stadium_name character varying, city character, points integer, matches_played integer, wins integer, draws integer, losses integer, goals_scored integer, goals_conceded integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.team_id,
        t.team_name,
        s.stadium_name, -- 🔹 Pobieramy nazwę stadionu z tabeli `stadiums`
        t.city,
        t.points,
        t.matches_played,
        t.wins,
        t.draws,
        t.losses,
        t.goals_scored,
        t.goals_conceded
    FROM teams t
    JOIN stadiums s ON t.stadium_id = s.stadium_id;
END;
$$;


ALTER FUNCTION public.get_all_teams() OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 24738)
-- Name: get_coaches_info(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_coaches_info() RETURNS TABLE(coach_id integer, first_name character varying, last_name character varying, team_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT c.coach_id, c.first_name, c.last_name, t.team_name
    FROM coaches c
    JOIN teams t ON c.team_id = t.team_id;
END;
$$;


ALTER FUNCTION public.get_coaches_info() OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 24755)
-- Name: get_matches_by_date(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_matches_by_date(match_day date) RETURNS TABLE(home_team_name character varying, home_team_score integer, away_team_score integer, away_team_name character varying, match_date date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ht.team_name AS home_team_name,
        m.home_team_score,
        m.away_team_score,
        at.team_name AS away_team_name,
        m.match_date
    FROM 
        matches AS m
    JOIN 
        teams AS ht ON m.home_team_id = ht.team_id
    JOIN 
        teams AS at ON m.away_team_id = at.team_id
    WHERE 
        m.match_date = match_day
    ORDER BY 
        m.match_date;
END;
$$;


ALTER FUNCTION public.get_matches_by_date(match_day date) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 24739)
-- Name: get_matches_info(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_matches_info() RETURNS TABLE(match_id integer, home_team_name character varying, away_team_name character varying, home_team_score integer, away_team_score integer, match_date date, stadium_name character varying, referee_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.match_id,
        ht.team_name AS home_team_name,
        at.team_name AS away_team_name,
        m.home_team_score,
        m.away_team_score,
        m.match_date,
        s.stadium_name,
        CONCAT(r.first_name, ' ', r.last_name) AS referee_name
    FROM matches m
    JOIN teams ht ON m.home_team_id = ht.team_id
    JOIN teams at ON m.away_team_id = at.team_id
    JOIN stadiums s ON m.stadium_id = s.stadium_id
    JOIN referees r ON m.referee_id = r.referee_id;
END;
$$;


ALTER FUNCTION public.get_matches_info() OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 24700)
-- Name: get_player_statistics(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_player_statistics() RETURNS TABLE(player_id integer, player_name text, goals integer, assists integer, yellow_cards integer, red_cards integer, clean_sheet integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
		ps.player_id,
        p.first_name || ' ' || p.last_name AS player_name,  -- 🔹 Łączenie imienia i nazwiska
        ps.goals,
        ps.assists,
        ps.yellow_cards,
        ps.red_cards,
        ps.clean_sheet
    FROM players p
    JOIN players_statistics ps ON p.player_id = ps.player_id; -- 🔹 Łączenie tabel po player_id
END;
$$;


ALTER FUNCTION public.get_player_statistics() OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 24740)
-- Name: get_players_info(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_players_info() RETURNS TABLE(player_id integer, first_name character, last_name character, name character, team_name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.player_id,
        p.first_name, 
        p.last_name, 
        pos.name, 
        t.team_name
    FROM players p
    JOIN positions pos ON p.position_id = pos.position_id
    JOIN teams t ON p.team_id = t.team_id;
END;
$$;


ALTER FUNCTION public.get_players_info() OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 24793)
-- Name: get_recent_matches_by_team(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_recent_matches_by_team(team_id_param bigint) RETURNS TABLE(match_id bigint, home_team_name character varying, away_team_name character varying, home_team_score integer, away_team_score integer, match_date date, stadium_name character varying, location_type text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    (
        SELECT 
            m.match_id::BIGINT,
            ht.team_name AS home_team_name,
            at.team_name AS away_team_name,
            m.home_team_score,
            m.away_team_score,
            m.match_date,
            s.stadium_name,
            'u siebie' AS location_type
        FROM matches m
        JOIN teams ht ON m.home_team_id = ht.team_id
        JOIN teams at ON m.away_team_id = at.team_id
        JOIN stadiums s ON m.stadium_id = s.stadium_id
        WHERE m.home_team_id = team_id_param
        ORDER BY m.match_date DESC
        LIMIT 5
    )
    UNION ALL
    (
        SELECT 
            m.match_id::BIGINT,
            ht.team_name AS home_team_name,
            at.team_name AS away_team_name,
            m.home_team_score,
            m.away_team_score,
            m.match_date,
            s.stadium_name,
            'na wyjeździe' AS location_type
        FROM matches m
        JOIN teams ht ON m.home_team_id = ht.team_id
        JOIN teams at ON m.away_team_id = at.team_id
        JOIN stadiums s ON m.stadium_id = s.stadium_id
        WHERE m.away_team_id = team_id_param
        ORDER BY m.match_date DESC
        LIMIT 5
    );
END;
$$;


ALTER FUNCTION public.get_recent_matches_by_team(team_id_param bigint) OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 24784)
-- Name: get_team_details(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_team_details(team_id_param bigint) RETURNS TABLE(team_id bigint, team_name character varying, stadium_name character varying, city character, coach_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.team_id::BIGINT,  -- Wymuszenie BIGINT
        t.team_name,
        s.stadium_name,
        t.city,
        COALESCE(c.first_name || ' ' || c.last_name, 'Brak trenera') AS coach_name
    FROM teams t
    LEFT JOIN stadiums s ON t.stadium_id = s.stadium_id
    LEFT JOIN coaches c ON t.team_id = c.team_id
    WHERE t.team_id = team_id_param;
END;
$$;


ALTER FUNCTION public.get_team_details(team_id_param bigint) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 24741)
-- Name: get_team_id_by_name(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_team_id_by_name(p_team_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    team_id integer;
BEGIN
    SELECT t.team_id INTO team_id
    FROM teams t
    WHERE t.team_name = p_team_name;
    RETURN team_id;
END;
$$;


ALTER FUNCTION public.get_team_id_by_name(p_team_name character varying) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 24797)
-- Name: get_team_players(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_team_players(team_id_param bigint) RETURNS TABLE(player_id bigint, first_name character, last_name character, position_name character, goals integer, assists integer, clean_sheet integer, yellow_cards integer, red_cards integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.player_id::BIGINT,
        p.first_name,
        p.last_name,
        pos.name, -- Pobieramy nazwę pozycji
        ps.goals,
        ps.assists,
        ps.clean_sheet,
        ps.yellow_cards,
        ps.red_cards
    FROM players p
    JOIN players_statistics ps ON p.player_id = ps.player_id
    JOIN positions pos ON p.position_id = pos.position_id -- Powiązanie z tabelą positions
    WHERE p.team_id = team_id_param;
END;
$$;


ALTER FUNCTION public.get_team_players(team_id_param bigint) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 24756)
-- Name: get_top_assisters(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_top_assisters() RETURNS TABLE(first_name character, last_name character, team_name character varying, assists integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.first_name,
        p.last_name,
        t.team_name,
        ps.assists
    FROM 
        players AS p
    JOIN 
        players_statistics AS ps ON p.player_id = ps.player_id
    JOIN 
        teams AS t ON p.team_id = t.team_id
    ORDER BY 
        ps.assists DESC
    LIMIT 10;
END;
$$;


ALTER FUNCTION public.get_top_assisters() OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 24757)
-- Name: get_top_goalkeepers(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_top_goalkeepers() RETURNS TABLE(first_name character, last_name character, team_name character varying, clean_sheets integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.first_name,
        p.last_name,
        t.team_name,
        ps.clean_sheet
    FROM 
        players AS p
    JOIN 
        players_statistics AS ps ON p.player_id = ps.player_id
    JOIN 
        teams AS t ON p.team_id = t.team_id
    WHERE 
        p.position_id = 4 -- Tylko bramkarze
    ORDER BY 
        ps.clean_sheet DESC
    LIMIT 10;
END;
$$;


ALTER FUNCTION public.get_top_goalkeepers() OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 24790)
-- Name: get_top_players_by_team(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_top_players_by_team(team_id_param bigint) RETURNS TABLE(player_id bigint, first_name character, last_name character, team_id bigint, statistic_type text, statistic_value integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM (
        SELECT 
            p.player_id::BIGINT,
            p.first_name,
            p.last_name,
            p.team_id::BIGINT,
            'Najwięcej goli' AS statistic_type,
            ps.goals AS statistic_value
        FROM players p
        JOIN players_statistics ps ON p.player_id = ps.player_id
        WHERE p.team_id = team_id_param
        ORDER BY ps.goals DESC
        LIMIT 1
    ) AS top_goals

    UNION ALL

    SELECT * FROM (
        SELECT 
            p.player_id::BIGINT,
            p.first_name,
            p.last_name,
            p.team_id::BIGINT,
            'Najwięcej asyst' AS statistic_type,
            ps.assists AS statistic_value
        FROM players p
        JOIN players_statistics ps ON p.player_id = ps.player_id
        WHERE p.team_id = team_id_param
        ORDER BY ps.assists DESC
        LIMIT 1
    ) AS top_assists

    UNION ALL

    SELECT * FROM (
        SELECT 
            p.player_id::BIGINT,
            p.first_name,
            p.last_name,
            p.team_id::BIGINT,
            'Najlepszy bramkarz' AS statistic_type,
            ps.clean_sheet AS statistic_value
        FROM players p
        JOIN players_statistics ps ON p.player_id = ps.player_id
        WHERE p.team_id = team_id_param
        ORDER BY ps.clean_sheet DESC
        LIMIT 1
    ) AS top_goalkeeper

    UNION ALL

    SELECT * FROM (
        SELECT 
            p.player_id::BIGINT,
            p.first_name,
            p.last_name,
            p.team_id::BIGINT,
            'Najwięcej żółtych kartek' AS statistic_type,
            ps.yellow_cards AS statistic_value
        FROM players p
        JOIN players_statistics ps ON p.player_id = ps.player_id
        WHERE p.team_id = team_id_param
        ORDER BY ps.yellow_cards DESC
        LIMIT 1
    ) AS top_yellow_cards

    UNION ALL

    SELECT * FROM (
        SELECT 
            p.player_id::BIGINT,
            p.first_name,
            p.last_name,
            p.team_id::BIGINT,
            'Najwięcej czerwonych kartek' AS statistic_type,
            ps.red_cards AS statistic_value
        FROM players p
        JOIN players_statistics ps ON p.player_id = ps.player_id
        WHERE p.team_id = team_id_param
        ORDER BY ps.red_cards DESC
        LIMIT 1
    ) AS top_red_cards;
END;
$$;


ALTER FUNCTION public.get_top_players_by_team(team_id_param bigint) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 24758)
-- Name: get_top_scorers(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_top_scorers() RETURNS TABLE(first_name character, last_name character, team_name character varying, goals integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.first_name,
        p.last_name,
        t.team_name,
        ps.goals
    FROM 
        players AS p
    JOIN 
        players_statistics AS ps ON p.player_id = ps.player_id
    JOIN 
        teams AS t ON p.team_id = t.team_id
    ORDER BY 
        ps.goals DESC
    LIMIT 10;
END;
$$;


ALTER FUNCTION public.get_top_scorers() OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 24765)
-- Name: getallteamsranking(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getallteamsranking() RETURNS TABLE(team_id bigint, team_name character varying, points bigint, goal_difference bigint, yellow_cards bigint, red_cards bigint, ranking bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    WITH TeamCardStats AS (
        SELECT 
            p.team_id,
            COALESCE(SUM(ps.yellow_cards), 0) AS total_yellow_cards,
            COALESCE(SUM(ps.red_cards), 0) AS total_red_cards
        FROM players p
        LEFT JOIN players_statistics ps ON p.player_id = ps.player_id
        GROUP BY p.team_id
    ),
    TeamRanking AS (
        SELECT 
            t.team_id::BIGINT,
            t.team_name,
            t.points::BIGINT,
            (t.goals_scored - t.goals_conceded)::BIGINT AS goal_difference,
            COALESCE(tc.total_yellow_cards, 0)::BIGINT AS yellow_cards,
            COALESCE(tc.total_red_cards, 0)::BIGINT AS red_cards,
            RANK() OVER (
                ORDER BY t.points DESC, 
                         (t.goals_scored - t.goals_conceded) DESC, 
                         COALESCE(tc.total_yellow_cards, 0) ASC, 
                         COALESCE(tc.total_red_cards, 0) ASC
            )::BIGINT AS ranking
        FROM teams t
        LEFT JOIN TeamCardStats tc ON t.team_id = tc.team_id
    )
    SELECT * FROM TeamRanking
    ORDER BY ranking;
END;
$$;


ALTER FUNCTION public.getallteamsranking() OWNER TO postgres;

--
-- TOC entry 292 (class 1255 OID 24774)
-- Name: getaveragepointspermatch(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getaveragepointspermatch() RETURNS TABLE(team_id bigint, team_name character varying, matches_played bigint, total_points bigint, avg_points_per_match numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        t.team_id::BIGINT,
        t.team_name,
        t.matches_played::BIGINT,
        t.points::BIGINT AS total_points,
        ROUND((t.points::NUMERIC / NULLIF(t.matches_played, 0)), 2) AS avg_points_per_match
    FROM teams t
    ORDER BY avg_points_per_match DESC;
END;
$$;


ALTER FUNCTION public.getaveragepointspermatch() OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 24771)
-- Name: getbestattackingteams(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getbestattackingteams() RETURNS TABLE(team_id bigint, team_name character varying, goals_scored bigint, attack_percentage numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    WITH TotalGoals AS (
        SELECT SUM(t.goals_scored)::BIGINT AS total_goals FROM teams t
    )
    SELECT 
        t.team_id::BIGINT,
        t.team_name,
        t.goals_scored::BIGINT,
        ROUND((t.goals_scored::NUMERIC / (SELECT total_goals FROM TotalGoals)) * 100, 2) AS attack_percentage
    FROM teams t
    ORDER BY t.goals_scored DESC;
END;
$$;


ALTER FUNCTION public.getbestattackingteams() OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 24772)
-- Name: getbestdefensiveteams(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getbestdefensiveteams() RETURNS TABLE(team_id bigint, team_name character varying, goals_conceded bigint, defense_percentage numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    WITH TotalGoalsConceded AS (
        SELECT SUM(t.goals_conceded)::BIGINT AS total_conceded FROM teams t
    )
    SELECT 
        t.team_id::BIGINT,
        t.team_name,
        t.goals_conceded::BIGINT,
        ROUND((t.goals_conceded::NUMERIC / (SELECT total_conceded FROM TotalGoalsConceded)) * 100, 2) AS defense_percentage
    FROM teams t
    ORDER BY t.goals_conceded ASC; -- Najlepsza obrona = najmniej straconych goli
END;
$$;


ALTER FUNCTION public.getbestdefensiveteams() OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 24776)
-- Name: gethomeawayperformance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gethomeawayperformance() RETURNS TABLE(team_id bigint, team_name character varying, home_matches bigint, home_points bigint, avg_home_points numeric, away_matches bigint, away_points bigint, avg_away_points numeric, home_advantage numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    WITH HomeStats AS (
        SELECT 
            m.home_team_id AS team_id,
            COUNT(m.match_id) AS home_matches,
            SUM(
                CASE 
                    WHEN m.home_team_score > m.away_team_score THEN 3 
                    WHEN m.home_team_score = m.away_team_score THEN 1 
                    ELSE 0 
                END
            ) AS home_points
        FROM matches m
        GROUP BY m.home_team_id
    ),
    AwayStats AS (
        SELECT 
            m.away_team_id AS team_id,
            COUNT(m.match_id) AS away_matches,
            SUM(
                CASE 
                    WHEN m.away_team_score > m.home_team_score THEN 3 
                    WHEN m.away_team_score = m.home_team_score THEN 1 
                    ELSE 0 
                END
            ) AS away_points
        FROM matches m
        GROUP BY m.away_team_id
    )
    SELECT 
        t.team_id::BIGINT,
        t.team_name,
        COALESCE(h.home_matches, 0)::BIGINT AS home_matches,
        COALESCE(h.home_points, 0)::BIGINT AS home_points,
        ROUND((COALESCE(h.home_points::NUMERIC, 0) / NULLIF(h.home_matches, 0)), 2) AS avg_home_points,
        COALESCE(a.away_matches, 0)::BIGINT AS away_matches,
        COALESCE(a.away_points, 0)::BIGINT AS away_points,
        ROUND((COALESCE(a.away_points::NUMERIC, 0) / NULLIF(a.away_matches, 0)), 2) AS avg_away_points,
        ROUND(
            (COALESCE(h.home_points::NUMERIC, 0) / NULLIF(h.home_matches, 0)) - 
            (COALESCE(a.away_points::NUMERIC, 0) / NULLIF(a.away_matches, 0)), 
        2) AS home_advantage
    FROM teams t
    LEFT JOIN HomeStats h ON t.team_id = h.team_id
    LEFT JOIN AwayStats a ON t.team_id = a.team_id
    ORDER BY home_advantage DESC;
END;
$$;


ALTER FUNCTION public.gethomeawayperformance() OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 24778)
-- Name: getmostcommonmatchresults(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getmostcommonmatchresults() RETURNS TABLE(match_result text, match_count bigint, percentage numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    WITH MatchResults AS (
        SELECT 
            CONCAT(m.home_team_score, ' - ', m.away_team_score) AS match_result,
            COUNT(*) AS match_count
        FROM matches m
        GROUP BY m.home_team_score, m.away_team_score
    ),
    TotalMatches AS (
        SELECT SUM(MatchResults.match_count) AS total_matches FROM MatchResults
    )
    SELECT 
        mr.match_result,
        mr.match_count,
        ROUND((mr.match_count::NUMERIC / (SELECT total_matches FROM TotalMatches)) * 100, 2) AS percentage
    FROM MatchResults mr
    ORDER BY mr.match_count DESC;
END;
$$;


ALTER FUNCTION public.getmostcommonmatchresults() OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 24767)
-- Name: getteamranking(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getteamranking(p_team_id bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE 
    team_rank BIGINT;
BEGIN
    WITH TeamCardStats AS (
        SELECT 
            p.team_id AS team_id,
            COALESCE(SUM(ps.yellow_cards), 0) AS total_yellow_cards,
            COALESCE(SUM(ps.red_cards), 0) AS total_red_cards
        FROM players p
        LEFT JOIN players_statistics ps ON p.player_id = ps.player_id
        GROUP BY p.team_id
    ),
    TeamRanking AS (
        SELECT 
            t.team_id AS team_id,
            RANK() OVER (
                ORDER BY t.points DESC, 
                         (t.goals_scored - t.goals_conceded) DESC, 
                         COALESCE(tc.total_yellow_cards, 0) ASC, 
                         COALESCE(tc.total_red_cards, 0) ASC
            ) AS ranking
        FROM teams t
        LEFT JOIN TeamCardStats tc ON t.team_id = tc.team_id
    )
    SELECT ranking INTO team_rank 
    FROM TeamRanking 
    WHERE TeamRanking.team_id = p_team_id; -- Jednoznaczne odwołanie do kolumny

    RETURN team_rank;
END;
$$;


ALTER FUNCTION public.getteamranking(p_team_id bigint) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 24746)
-- Name: update_matches_played(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_matches_played() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Jeśli dodajemy nowy mecz, zwiększamy ilość rozegranych meczów
    IF TG_OP = 'INSERT' THEN
        UPDATE teams SET matches_played = matches_played + 1 WHERE team_id = NEW.home_team_id;
        UPDATE teams SET matches_played = matches_played + 1 WHERE team_id = NEW.away_team_id;
    
    -- Jeśli usuwamy mecz, zmniejszamy ilość rozegranych meczów
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE teams SET matches_played = matches_played - 1 WHERE team_id = OLD.home_team_id;
        UPDATE teams SET matches_played = matches_played - 1 WHERE team_id = OLD.away_team_id;
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_matches_played() OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 16528)
-- Name: update_position(integer, character); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_position(IN position_id integer, IN name character)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
    UPDATE positions  
    SET name = p_name
    WHERE position_id = p_position_id; 
END; 
$$;


ALTER PROCEDURE public.update_position(IN position_id integer, IN name character) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 24750)
-- Name: update_team_goals(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_team_goals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- 🔹 Jeśli dodajemy nowy mecz
    IF TG_OP = 'INSERT' THEN
        -- Gospodarze strzelili bramki (goals_scored) i stracili bramki (goals_conceded)
        UPDATE teams SET 
            goals_scored = goals_scored + NEW.home_team_score, 
            goals_conceded = goals_conceded + NEW.away_team_score 
        WHERE team_id = NEW.home_team_id;

        -- Goście strzelili bramki (goals_scored) i stracili bramki (goals_conceded)
        UPDATE teams SET 
            goals_scored = goals_scored + NEW.away_team_score, 
            goals_conceded = goals_conceded + NEW.home_team_score 
        WHERE team_id = NEW.away_team_id;

    -- 🔹 Jeśli usuwamy mecz (przywracamy poprzednie wartości)
    ELSIF TG_OP = 'DELETE' THEN
        -- Cofamy bramki dla gospodarzy
        UPDATE teams SET 
            goals_scored = goals_scored - OLD.home_team_score, 
            goals_conceded = goals_conceded - OLD.away_team_score 
        WHERE team_id = OLD.home_team_id;

        -- Cofamy bramki dla gości
        UPDATE teams SET 
            goals_scored = goals_scored - OLD.away_team_score, 
            goals_conceded = goals_conceded - OLD.home_team_score 
        WHERE team_id = OLD.away_team_id;
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_team_goals() OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 24752)
-- Name: update_team_points(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_team_points() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- 🔹 Jeśli dodajemy nowy mecz
    IF TG_OP = 'INSERT' THEN
        IF NEW.home_team_score > NEW.away_team_score THEN
            -- Gospodarze wygrywają (+3 pkt), goście przegrywają (0 pkt)
            UPDATE teams SET points = points + 3 WHERE team_id = NEW.home_team_id;
        ELSIF NEW.home_team_score < NEW.away_team_score THEN
            -- Goście wygrywają (+3 pkt), gospodarze przegrywają (0 pkt)
            UPDATE teams SET points = points + 3 WHERE team_id = NEW.away_team_id;
        ELSE
            -- Remis (+1 pkt dla obu drużyn)
            UPDATE teams SET points = points + 1 WHERE team_id = NEW.home_team_id;
            UPDATE teams SET points = points + 1 WHERE team_id = NEW.away_team_id;
        END IF;

    -- 🔹 Jeśli usuwamy mecz (przywracamy poprzednie wartości)
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.home_team_score > OLD.away_team_score THEN
            -- Gospodarze wygrali -> cofamy +3 pkt
            UPDATE teams SET points = points - 3 WHERE team_id = OLD.home_team_id;
        ELSIF OLD.home_team_score < OLD.away_team_score THEN
            -- Goście wygrali -> cofamy +3 pkt
            UPDATE teams SET points = points - 3 WHERE team_id = OLD.away_team_id;
        ELSE
            -- Remis -> cofamy +1 pkt dla obu drużyn
            UPDATE teams SET points = points - 1 WHERE team_id = OLD.home_team_id;
            UPDATE teams SET points = points - 1 WHERE team_id = OLD.away_team_id;
        END IF;
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_team_points() OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 24748)
-- Name: update_team_results(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_team_results() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- 🔹 Jeśli dodajemy nowy mecz
    IF TG_OP = 'INSERT' THEN
        IF NEW.home_team_score > NEW.away_team_score THEN
            -- Gospodarze wygrywają
            UPDATE teams SET wins = wins + 1 WHERE team_id = NEW.home_team_id;
            UPDATE teams SET losses = losses + 1 WHERE team_id = NEW.away_team_id;
        ELSIF NEW.home_team_score < NEW.away_team_score THEN
            -- Goście wygrywają
            UPDATE teams SET wins = wins + 1 WHERE team_id = NEW.away_team_id;
            UPDATE teams SET losses = losses + 1 WHERE team_id = NEW.home_team_id;
        ELSE
            -- Remis
            UPDATE teams SET draws = draws + 1 WHERE team_id = NEW.home_team_id;
            UPDATE teams SET draws = draws + 1 WHERE team_id = NEW.away_team_id;
        END IF;

    -- 🔹 Jeśli usuwamy mecz (przywracamy poprzednie wartości)
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.home_team_score > OLD.away_team_score THEN
            -- Gospodarze wygrali -> cofamy zmiany
            UPDATE teams SET wins = wins - 1 WHERE team_id = OLD.home_team_id;
            UPDATE teams SET losses = losses - 1 WHERE team_id = OLD.away_team_id;
        ELSIF OLD.home_team_score < OLD.away_team_score THEN
            -- Goście wygrali -> cofamy zmiany
            UPDATE teams SET wins = wins - 1 WHERE team_id = OLD.away_team_id;
            UPDATE teams SET losses = losses - 1 WHERE team_id = OLD.home_team_id;
        ELSE
            -- Remis -> cofamy zmiany
            UPDATE teams SET draws = draws - 1 WHERE team_id = OLD.home_team_id;
            UPDATE teams SET draws = draws - 1 WHERE team_id = OLD.away_team_id;
        END IF;
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.update_team_results() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16414)
-- Name: coaches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coaches (
    coach_id integer NOT NULL,
    first_name character varying(20) NOT NULL,
    last_name character varying(20) NOT NULL,
    team_id integer NOT NULL
);


ALTER TABLE public.coaches OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16413)
-- Name: coaches_coach_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coaches_coach_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.coaches_coach_id_seq OWNER TO postgres;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 221
-- Name: coaches_coach_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coaches_coach_id_seq OWNED BY public.coaches.coach_id;


--
-- TOC entry 231 (class 1259 OID 16474)
-- Name: matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matches (
    match_id integer NOT NULL,
    home_team_id integer NOT NULL,
    away_team_id integer NOT NULL,
    home_team_score integer DEFAULT 0,
    away_team_score integer DEFAULT 0,
    match_date date,
    stadium_id integer NOT NULL,
    referee_id integer
);


ALTER TABLE public.matches OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16473)
-- Name: matches_match_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.matches_match_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.matches_match_id_seq OWNER TO postgres;

--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 230
-- Name: matches_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.matches_match_id_seq OWNED BY public.matches.match_id;


--
-- TOC entry 226 (class 1259 OID 16433)
-- Name: players; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.players (
    player_id integer NOT NULL,
    first_name character(20) NOT NULL,
    last_name character(20) NOT NULL,
    position_id integer NOT NULL,
    team_id integer NOT NULL
);


ALTER TABLE public.players OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16432)
-- Name: players_player_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.players_player_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.players_player_id_seq OWNER TO postgres;

--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 225
-- Name: players_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.players_player_id_seq OWNED BY public.players.player_id;


--
-- TOC entry 227 (class 1259 OID 16450)
-- Name: players_statistics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.players_statistics (
    player_id integer NOT NULL,
    goals integer DEFAULT 0 NOT NULL,
    assists integer DEFAULT 0 NOT NULL,
    yellow_cards integer DEFAULT 0 NOT NULL,
    red_cards integer DEFAULT 0 NOT NULL,
    clean_sheet integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.players_statistics OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16426)
-- Name: positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions (
    position_id integer NOT NULL,
    name character(20) NOT NULL
);


ALTER TABLE public.positions OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16425)
-- Name: positions_position_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.positions_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.positions_position_id_seq OWNER TO postgres;

--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 223
-- Name: positions_position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.positions_position_id_seq OWNED BY public.positions.position_id;


--
-- TOC entry 229 (class 1259 OID 16467)
-- Name: referees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.referees (
    referee_id integer NOT NULL,
    first_name character varying(20) NOT NULL,
    last_name character varying(20) NOT NULL
);


ALTER TABLE public.referees OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16466)
-- Name: referees_referee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.referees_referee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.referees_referee_id_seq OWNER TO postgres;

--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 228
-- Name: referees_referee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.referees_referee_id_seq OWNED BY public.referees.referee_id;


--
-- TOC entry 220 (class 1259 OID 16397)
-- Name: stadiums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stadiums (
    stadium_id integer NOT NULL,
    stadium_name character varying(100) NOT NULL
);


ALTER TABLE public.stadiums OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16396)
-- Name: stadiums_stadium_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stadiums_stadium_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stadiums_stadium_id_seq OWNER TO postgres;

--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 219
-- Name: stadiums_stadium_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stadiums_stadium_id_seq OWNED BY public.stadiums.stadium_id;


--
-- TOC entry 218 (class 1259 OID 16390)
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    team_id integer NOT NULL,
    team_name character varying(50) NOT NULL,
    stadium_id integer NOT NULL,
    city character(50) NOT NULL,
    points integer,
    matches_played integer,
    wins integer,
    draws integer,
    losses integer,
    goals_scored integer,
    goals_conceded integer
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: teams_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teams_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teams_team_id_seq OWNER TO postgres;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 217
-- Name: teams_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teams_team_id_seq OWNED BY public.teams.team_id;


--
-- TOC entry 4835 (class 2604 OID 16417)
-- Name: coaches coach_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coaches ALTER COLUMN coach_id SET DEFAULT nextval('public.coaches_coach_id_seq'::regclass);


--
-- TOC entry 4844 (class 2604 OID 16477)
-- Name: matches match_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches ALTER COLUMN match_id SET DEFAULT nextval('public.matches_match_id_seq'::regclass);


--
-- TOC entry 4837 (class 2604 OID 16436)
-- Name: players player_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players ALTER COLUMN player_id SET DEFAULT nextval('public.players_player_id_seq'::regclass);


--
-- TOC entry 4836 (class 2604 OID 16429)
-- Name: positions position_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions ALTER COLUMN position_id SET DEFAULT nextval('public.positions_position_id_seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 16470)
-- Name: referees referee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referees ALTER COLUMN referee_id SET DEFAULT nextval('public.referees_referee_id_seq'::regclass);


--
-- TOC entry 4834 (class 2604 OID 16400)
-- Name: stadiums stadium_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stadiums ALTER COLUMN stadium_id SET DEFAULT nextval('public.stadiums_stadium_id_seq'::regclass);


--
-- TOC entry 4833 (class 2604 OID 16393)
-- Name: teams team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams ALTER COLUMN team_id SET DEFAULT nextval('public.teams_team_id_seq'::regclass);


--
-- TOC entry 5026 (class 0 OID 16414)
-- Dependencies: 222
-- Data for Name: coaches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coaches (coach_id, first_name, last_name, team_id) FROM stdin;
1	Mikel	Arteta	1
2	Unai	Emery	2
3	Andoni	Iraola	3
4	Thomas	Frank	4
5	Roberto	De Zerbi	5
6	Vincent	Kompany	6
7	Mauricio	Pochettino	7
8	Roy	Hodgson	8
9	Sean	Dyche	9
10	Marco	Silva	10
11	Jurgen	Klopp	11
12	Rob	Edwards	12
13	Pep	Guardiola	13
14	Erik	ten Hag	14
15	Eddie	Howe	15
16	Steve	Cooper	16
17	Paul	Heckingbottom	17
18	Ange	Postecoglou	18
19	David	Moyes	19
20	Gary	ONeil	20
\.


--
-- TOC entry 5035 (class 0 OID 16474)
-- Dependencies: 231
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matches (match_id, home_team_id, away_team_id, home_team_score, away_team_score, match_date, stadium_id, referee_id) FROM stdin;
2	1	16	2	1	2024-08-12	1	1
3	3	19	1	1	2024-08-12	3	8
4	5	12	4	1	2024-08-12	5	1
5	9	10	0	1	2024-08-12	9	3
6	17	8	0	1	2024-08-12	17	6
7	15	2	5	1	2024-08-12	15	2
9	7	11	1	1	2024-08-13	7	6
10	14	20	1	0	2024-08-14	14	9
11	16	17	2	1	2024-08-18	16	6
12	10	4	0	3	2024-08-19	10	8
13	11	3	3	1	2024-08-19	11	10
14	20	5	1	4	2024-08-19	20	8
15	18	14	2	0	2024-08-19	18	4
16	13	15	1	0	2024-08-19	13	8
17	2	9	4	0	2024-08-20	2	8
18	19	7	3	1	2024-08-20	19	2
19	8	1	0	1	2024-08-21	8	9
20	7	12	3	0	2024-08-25	7	10
21	3	18	0	2	2024-08-26	3	8
22	1	10	2	2	2024-08-26	1	10
23	4	8	1	1	2024-08-26	4	9
24	9	20	0	1	2024-08-26	9	8
25	14	16	3	2	2024-08-26	14	8
26	5	19	1	3	2024-08-26	5	1
27	6	2	1	3	2024-08-27	6	5
28	17	13	1	2	2024-08-27	17	4
29	15	11	1	2	2024-08-27	15	6
30	12	19	1	2	2024-09-01	12	5
31	17	9	2	2	2024-09-02	17	3
32	4	3	2	2	2024-09-02	4	2
33	6	18	2	5	2024-09-02	6	1
34	7	16	0	1	2024-09-02	7	4
35	13	10	5	1	2024-09-02	13	8
36	5	15	3	1	2024-09-02	5	3
37	8	20	3	2	2024-09-03	8	4
38	11	2	3	0	2024-09-03	11	5
39	1	14	3	1	2024-09-03	1	10
40	20	11	1	3	2024-09-16	20	1
41	2	8	3	1	2024-09-16	2	1
42	10	12	1	0	2024-09-16	10	10
43	14	5	1	3	2024-09-16	14	7
44	18	17	2	1	2024-09-16	18	6
45	19	13	1	3	2024-09-16	19	3
46	15	4	1	0	2024-09-16	15	1
47	3	7	0	0	2024-09-17	3	4
48	9	1	0	1	2024-09-17	9	6
49	16	6	1	1	2024-09-18	16	4
50	8	10	0	0	2024-09-23	8	6
51	12	20	1	1	2024-09-23	12	3
52	13	16	2	0	2024-09-23	13	9
53	4	9	1	3	2024-09-23	4	5
54	6	14	0	1	2024-09-23	6	5
55	1	18	2	2	2024-09-24	1	1
56	5	3	3	1	2024-09-24	5	4
57	7	2	0	1	2024-09-24	7	9
58	11	19	3	1	2024-09-24	11	9
59	17	15	0	8	2024-09-24	17	9
60	2	5	6	1	2024-09-30	2	8
61	3	1	0	4	2024-09-30	3	6
62	9	12	1	2	2024-09-30	9	4
63	14	8	0	1	2024-09-30	14	7
64	15	6	2	0	2024-09-30	15	5
65	19	17	2	0	2024-09-30	19	10
66	20	13	2	1	2024-09-30	20	8
67	18	11	2	1	2024-09-30	18	10
68	16	4	1	1	2024-10-01	16	5
69	10	7	0	2	2024-10-02	10	3
70	12	6	1	2	2024-10-03	12	3
73	1	18	2	1	2024-12-04	2	1
74	1	10	10	10	2024-12-04	2	1
1	6	13	2	3	2023-08-11	6	6
8	4	18	2	2	2024-08-13	4	10
\.


--
-- TOC entry 5030 (class 0 OID 16433)
-- Dependencies: 226
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.players (player_id, first_name, last_name, position_id, team_id) FROM stdin;
1	Bukayo              	Saka                	1	1
2	Declan              	Rice                	2	1
3	Martin              	Odegaard            	2	1
4	Gabriel             	Jesus               	1	1
5	Kai                 	Havertz             	2	1
6	William             	Saliba              	3	1
7	Ben                 	White               	3	1
8	Gabriel             	Magalhaes           	3	1
9	Aaron               	Ramsdale            	4	1
10	Leandro             	Trossard            	1	1
11	Jorginho            	Frello              	2	1
12	Thomas              	Partey              	2	1
13	Takehiro            	Tomiyasu            	3	1
14	Oleksandr           	Zinchenko           	3	1
15	Jakub               	Kiwior              	3	1
16	Eddie               	Nketiah             	1	1
17	Reiss               	Nelson              	1	1
18	David               	Raya                	4	1
19	Ollie               	Watkins             	1	2
20	John                	McGinn              	2	2
21	Leon                	Bailey              	1	2
22	Douglas             	Luiz                	2	2
23	Boubacar            	Kamara              	2	2
24	Emiliano            	Martinez            	4	2
25	Tyrone              	Mings               	3	2
26	Pau                 	Torres              	3	2
27	Ezri                	Konsa               	3	2
28	Matty               	Cash                	3	2
29	Jacob               	Ramsey              	2	2
30	Lucas               	Digne               	3	2
31	Jhon                	Duran               	1	2
32	Moussa              	Diaby               	1	2
33	Youri               	Tielemans           	2	2
34	Diego               	Carlos              	3	2
35	Robin               	Olsen               	4	2
36	Bertrand            	Traore              	1	2
37	Dominic             	Solanke             	1	3
38	Philip              	Billing             	2	3
39	Marcus              	Tavernier           	2	3
40	Kieffer             	Moore               	1	3
41	Justin              	Kluivert            	2	3
42	Marcos              	Senesi              	3	3
43	Chris               	Mepham              	3	3
44	Adam                	Smith               	3	3
45	Neto                	Murara              	4	3
46	Ryan                	Christie            	1	3
47	Lewis               	Cook                	2	3
48	Joe                 	Rothwell            	2	3
49	Lloyd               	Kelly               	3	3
50	Jack                	Stacey              	3	3
51	Ilya                	Zabarnyi            	3	3
52	Antoine             	Semenyo             	1	3
53	David               	Brooks              	1	3
54	Mark                	Travers             	4	3
55	Ivan                	Toney               	1	4
56	Bryan               	Mbeumo              	1	4
57	Yoane               	Wissa               	1	4
58	Mikkel              	Damsgaard           	2	4
59	Josh                	Dasilva             	2	4
60	Christian           	NÃ¸rgaard           	2	4
61	Vitaly              	Janelt              	2	4
62	Mathias             	Jensen              	2	4
63	Aaron               	Hickey              	3	4
64	Ethan               	Pinnock             	3	4
65	Ben                 	Mee                 	3	4
66	Pontus              	Jansson             	3	4
67	Kristoffer          	Ajer                	3	4
68	David               	Raya                	4	4
69	Mark                	Flekken             	4	4
70	Keane               	Lewis-Potter        	1	4
71	Frank               	Onyeka              	2	4
72	Saman               	Ghoddos             	2	4
73	Kaoru               	Mitoma              	1	5
74	Evan                	Ferguson            	1	5
75	Danny               	Welbeck             	1	5
76	Pascal              	Gross               	2	5
77	Adam                	Lallana             	2	5
78	Billy               	Gilmour             	2	5
79	James               	Milner              	2	5
80	João                	Pedro               	2	5
81	Pervis              	Estupiñán           	3	5
82	Tariq               	Lamptey             	3	5
83	Lewis               	Dunk                	3	5
84	Adam                	Webster             	3	5
85	Jan                 	Paul van Hecke      	3	5
86	Jason               	Steele              	4	5
87	Bart                	Verbruggen          	4	5
88	Solly               	March               	1	5
89	Facundo             	Buonanotte          	2	5
90	Simon               	Adingra             	2	5
91	Lyle                	Foster              	1	6
92	Zeki                	Amdouni             	1	6
93	Jay                 	Rodriguez           	1	6
94	Josh                	Brownhill           	2	6
95	Jack                	Cork                	2	6
96	Sander              	Berge               	2	6
97	Johann              	Gudmundsson         	2	6
98	Aaron               	Ramsey              	2	6
99	Charlie             	Taylor              	3	6
100	Jordan              	Beyer               	3	6
101	Connor              	Roberts             	3	6
102	Hjalmar             	Ekdal               	3	6
103	Dara                	OShea               	3	6
104	Arijanet            	Muric               	4	6
105	James               	Trafford            	4	6
106	Anass               	Zaroury             	1	6
107	Manuel              	Benson              	1	6
108	Nathan              	Redmond             	2	6
109	Raheem              	Sterling            	1	7
110	Nicolas             	Jackson             	1	7
111	Christopher         	Nkunku              	1	7
112	Cole                	Palmer              	2	7
113	Enzo                	Fernandez           	2	7
114	Moises              	Caicedo             	2	7
115	Conor               	Gallagher           	2	7
116	Mykhailo            	Mudryk              	2	7
117	Ben                 	Chilwell            	3	7
118	Reece               	James               	3	7
119	Thiago              	Silva               	3	7
120	Levi                	Colwill             	3	7
121	Axel                	Disasi              	3	7
122	Djordje             	Petrovic            	4	7
123	Robert              	Sanchez             	4	7
124	Armando             	Broja               	1	7
125	Carney              	Chukwuemeka         	2	7
126	Lesley              	Ugochukwu           	2	7
127	Eberechi            	Eze                 	1	8
128	Michael             	Olise               	1	8
129	Odsonne             	Edouard             	1	8
130	Jean-Philippe       	Mateta              	1	8
131	Jordan              	Ayew                	2	8
132	Will                	Hughes              	2	8
133	Jeffrey             	Schlupp             	2	8
134	Cheick              	DoucourÃ©           	2	8
135	Joachim             	Andersen            	3	8
136	Marc                	Guehi               	3	8
137	Joel                	Ward                	3	8
138	Nathaniel           	Clyne               	3	8
139	Tyrick              	Mitchell            	3	8
140	Dean                	Henderson           	4	8
141	Sam                 	Johnstone           	4	8
142	Matheus             	Franca              	2	8
143	Chris               	Richards            	3	8
144	Jesurun             	Rak-Sakyi           	1	8
145	Dominic             	Calvert-Lewin       	1	9
146	Beto                	Betuncal            	1	9
147	Arnaut              	Danjuma             	1	9
148	Dwight              	McNeil              	2	9
149	Abdoulaye           	Doucoure            	2	9
150	Amadou              	Onana               	2	9
151	James               	Garner              	2	9
152	Idrissa             	Gueye               	2	9
153	James               	Tarkowski           	3	9
154	Jarrad              	Branthwaite         	3	9
155	Nathan              	Patterson           	3	9
156	Ben                 	Godfrey             	3	9
157	Ashley              	Young               	3	9
158	Jordan              	Pickford            	4	9
159	Joao                	Virginia            	4	9
160	Michael             	Keane               	3	9
161	Andre               	Gomes               	2	9
162	Neal                	Maupay              	1	9
163	Raul                	Jimenez             	1	10
164	Carlos              	Vinicius            	1	10
165	Willian             	Borges              	1	10
166	Bobby               	Decordova-Reid      	2	10
167	Andreas             	Pereira             	2	10
168	Harrison            	Reed                	2	10
169	Joao                	Palhinha            	2	10
170	Tom                 	Cairney             	2	10
171	Kenny               	Tete                	3	10
172	Antonee             	Robinson            	3	10
173	Issa                	Diop                	3	10
174	Tim                 	Ream                	3	10
175	Calvin              	Bassey              	3	10
176	Bernd               	Leno                	4	10
177	Marek               	Rodak               	4	10
178	Adama               	Traore              	1	10
179	Sasa                	Lukic               	2	10
180	Timothy             	Castagne            	3	10
181	Mohamed             	Salah               	1	11
182	Darwin              	Nunez               	1	11
183	Luis                	Diaz                	1	11
184	Diogo               	Jota                	1	11
185	Cody                	Gakpo               	1	11
186	Alexis              	Mac Allister        	2	11
187	Dominik             	Szoboszlai          	2	11
188	Curtis              	Jones               	2	11
189	Thiago              	Alcantara           	2	11
190	Wataru              	Endo                	2	11
191	Trent               	Alexander-Arnold    	3	11
192	Andrew              	Robertson           	3	11
193	Virgil              	van Dijk            	3	11
194	Ibrahima            	Konate              	3	11
195	Joe                 	Gomez               	3	11
196	Alisson             	Becker              	4	11
197	Caoimhin            	Kelleher            	4	11
198	Joel                	Matip               	3	11
199	Carlton             	Morris              	1	12
200	Elijah              	Adebayo             	1	12
201	Jacob               	Brown               	1	12
202	Tahith              	Chong               	2	12
203	Albert              	Sambi Lokonga       	2	12
204	Marvelous           	Nakamba             	2	12
205	Ross                	Barkley             	2	12
206	Pelly               	Ruddock             	2	12
207	Tom                 	Lockyer             	3	12
208	Mads                	Andersen            	3	12
209	Issa                	Kabore              	3	12
210	Alfie               	Doughty             	3	12
211	Teden               	Mengi               	3	12
212	Thomas              	Kaminski            	4	12
213	James               	Shea                	4	12
214	Reece               	Burke               	3	12
215	Chiedozie           	Ogbene              	1	12
216	Dan                 	Potts               	3	12
217	Erling              	Haaland             	1	13
218	Julian              	Alvarez             	1	13
219	Jack                	Grealish            	1	13
220	Phil                	Foden               	2	13
221	Kevin               	De Bruyne           	2	13
222	Rodri               	Hernandez           	2	13
223	Bernardo            	Silva               	2	13
224	Mateo               	Kovacic             	2	13
225	Joao                	Cancelo             	3	13
226	Kyle                	Walker              	3	13
227	Ruben               	Dias                	3	13
228	John                	Stones              	3	13
229	Manuel              	Akanji              	3	13
230	Ederson             	Moraes              	4	13
231	Stefan              	Ortega              	4	13
232	Nathan              	Ake                 	3	13
233	Josko               	Gvardiol            	3	13
234	Rico                	Lewis               	3	13
235	Marcus              	Rashford            	1	14
236	Rasmus              	Hojlund             	1	14
237	Antony              	Matheus             	1	14
238	Bruno               	Fernandes           	2	14
239	Casemiro            	Casemiro            	2	14
240	Christian           	Eriksen             	2	14
241	Mason               	Mount               	2	14
242	Scott               	McTominay           	2	14
243	Luke                	Shaw                	3	14
244	Diogo               	Dalot               	3	14
245	Lisandro            	Martinez            	3	14
246	Raphael             	Varane              	3	14
247	Aaron               	Wan-Bissaka         	3	14
248	Andre               	Onana               	4	14
249	Altay               	Bayindir            	4	14
250	Harry               	Maguire             	3	14
251	Victor              	Lindelof            	3	14
252	Jadon               	Sancho              	1	14
253	Alexander           	Isak                	1	15
254	Callum              	Wilson              	1	15
255	Miguel              	Almiron             	1	15
256	Anthony             	Gordon              	1	15
257	Bruno               	Guimaraes           	2	15
258	Joelinton           	Cassio              	2	15
259	Sean                	Longstaff           	2	15
260	Sandro              	Tonali              	2	15
261	Kieran              	Trippier            	3	15
262	Dan                 	Burn                	3	15
263	Sven                	Botman              	3	15
264	Fabian              	Schar               	3	15
265	Tino                	Livramento          	3	15
266	Nick                	Pope                	4	15
267	Martin              	Dubravka            	4	15
268	Jamaal              	Lascelles           	3	15
269	Matt                	Targett             	3	15
270	Jacob               	Murphy              	1	15
271	Taiwo               	Awoniyi             	1	16
272	Chris               	Wood                	1	16
273	Anthony             	Elanga              	1	16
274	Morgan              	Gibbs-White         	2	16
275	Orel                	Mangala             	2	16
276	Ibrahim             	Sangare             	2	16
277	Ryan                	Yates               	2	16
278	Danilo              	Dos Santos          	2	16
279	Serge               	Aurier              	3	16
280	Neco                	Williams            	3	16
281	Moussa              	Niakhate            	3	16
282	Felipe              	Monteiro            	3	16
283	Willy               	Boly                	3	16
284	Matt                	Turner              	4	16
285	Odysseas            	Vlachodimos         	4	16
286	Joe                 	Worrall             	3	16
287	Ola                 	Aina                	3	16
288	Divock              	Origi               	1	16
289	Oli                 	McBurnie            	1	17
290	Cameron             	Archer              	1	17
291	Benie               	Traore              	1	17
292	Gustavo             	Hamer               	2	17
293	Oliver              	Norwood             	2	17
294	James               	McAtee              	2	17
295	Vinicius            	Souza               	2	17
296	Tom                 	Davies              	2	17
297	Jack                	Robinson            	3	17
298	Anel                	Ahmedhodzic         	3	17
299	George              	Baldock             	3	17
300	Jayden              	Bogle               	3	17
301	Auston              	Trusty              	3	17
302	Wes                 	Foderingham         	4	17
303	Ivo                 	Grbic               	4	17
304	Chris               	Basham              	3	17
305	John                	Egan                	3	17
306	Rhian               	Brewster            	1	17
307	Heung-min           	Son                 	1	18
308	Richarlison         	de Andrade          	1	18
309	Brennan             	Johnson             	1	18
310	James               	Maddison            	2	18
311	Rodrigo             	Bentancur           	2	18
312	Pierre-Emile        	Hojbjerg            	2	18
313	Yves                	Bissouma            	2	18
314	Pape                	Matar Sarr          	2	18
315	Cristian            	Romero              	3	18
316	Micky               	van de Ven          	3	18
317	Pedro               	Porro               	3	18
318	Destiny             	Udogie              	3	18
319	Emerson             	Royal               	3	18
320	Guglielmo           	Vicario             	4	18
321	Fraser              	Forster             	4	18
322	Ben                 	Davies              	3	18
323	Giovani             	Lo Celso            	2	18
324	Dejan               	Kulusevski          	1	18
325	Jarrod              	Bowen               	1	19
326	Michail             	Antonio             	1	19
327	Danny               	Ings                	1	19
328	Lucas               	Paqueta             	2	19
329	James               	Ward-Prowse         	2	19
330	Edson               	Alvarez             	2	19
331	Tomas               	Soucek              	2	19
332	Pablo               	Fornals             	2	19
333	Kurt                	Zouma               	3	19
334	Nayef               	Aguerd              	3	19
335	Vladimir            	Coufal              	3	19
336	Emerson             	Palmieri            	3	19
337	Ben                 	Johnson             	3	19
338	Alphonse            	Areola              	4	19
339	Lukasz              	Fabianski           	4	19
340	Thilo               	Kehrer              	3	19
341	Konstantinos        	Mavropanos          	3	19
342	Said                	Benrahma            	1	19
343	Matheus             	Cunha               	1	20
344	Hwang               	Hee-chan            	1	20
345	Pablo               	Sarabia             	1	20
346	Pedro               	Neto                	2	20
347	Joao                	Gomes               	2	20
348	Mario               	Lemina              	2	20
349	Jean-Ricner         	Bellegarde          	2	20
350	Boubacar            	Traore              	2	20
351	Max                 	Kilman              	3	20
352	Craig               	Dawson              	3	20
353	Toti                	Gomes               	3	20
354	Rayan               	Ait-Nouri           	3	20
355	Nelson              	Semedo              	3	20
356	Jose                	Sa                  	4	20
357	Daniel              	Bentley             	4	20
358	Hugo                	Bueno               	3	20
359	Santiago            	Bueno               	3	20
360	Fabio               	Silva               	1	20
365	Test1               	Test1               	1	1
\.


--
-- TOC entry 5031 (class 0 OID 16450)
-- Dependencies: 227
-- Data for Name: players_statistics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.players_statistics (player_id, goals, assists, yellow_cards, red_cards, clean_sheet) FROM stdin;
1	5	3	0	0	0
2	0	1	2	0	0
3	2	3	0	0	0
4	0	0	0	1	0
5	2	0	3	0	0
6	0	0	0	0	0
7	0	0	1	0	0
8	0	0	0	0	0
9	0	0	0	0	0
10	3	2	0	0	0
11	1	0	0	0	0
12	0	0	0	0	0
13	0	0	2	0	0
14	0	0	0	0	0
15	1	1	0	0	0
16	0	0	0	0	0
17	1	0	0	0	0
18	0	0	0	0	3
19	3	3	0	0	0
20	2	0	1	0	0
21	0	0	0	0	0
22	5	2	0	0	0
23	0	0	0	0	0
24	0	1	0	0	2
25	3	0	0	0	0
26	0	0	0	0	0
27	0	2	0	0	0
28	5	0	1	0	0
29	0	0	0	0	0
30	0	0	0	0	0
31	0	0	3	0	0
32	0	0	0	0	0
33	0	0	1	0	0
34	0	0	0	0	0
35	0	0	0	1	0
36	0	0	0	0	0
37	0	0	0	0	0
38	0	2	0	0	0
39	0	0	3	0	0
40	1	0	0	0	0
41	0	0	0	0	0
42	0	0	0	0	0
43	0	1	0	0	0
44	0	0	0	0	0
45	0	0	1	0	1
46	0	0	0	0	0
47	0	0	0	0	0
48	3	0	0	0	0
49	0	0	0	1	0
50	0	1	0	0	0
51	0	0	0	0	0
52	1	0	0	0	0
53	0	0	0	0	0
54	0	0	0	0	0
55	0	0	0	0	0
56	0	0	1	0	0
57	1	0	0	0	0
58	0	1	0	0	0
59	0	0	0	1	0
60	2	0	2	0	0
61	0	0	0	0	0
62	0	0	0	0	0
63	0	2	0	0	0
64	0	0	0	0	0
65	1	0	0	0	0
66	4	0	1	0	0
67	0	0	0	0	0
68	0	0	0	0	1
69	0	0	0	0	0
70	2	3	0	0	0
71	0	0	0	0	0
72	0	1	1	0	0
73	1	0	1	0	0
74	1	2	0	0	0
75	0	0	1	0	0
76	2	0	0	1	0
77	0	2	0	0	0
78	0	0	0	0	0
79	6	4	1	0	0
80	0	0	0	0	0
81	0	0	0	0	0
82	4	7	1	0	0
83	0	0	0	0	0
84	0	0	0	0	0
85	5	0	0	0	0
86	0	0	0	0	0
87	0	0	0	1	0
88	0	0	0	0	0
89	0	0	0	0	0
90	0	0	0	0	0
91	0	0	0	0	0
92	0	0	0	1	0
93	0	1	0	0	0
94	0	0	0	0	0
95	2	0	1	0	0
96	0	0	0	0	0
97	1	0	0	0	0
98	0	1	0	0	0
99	1	0	0	0	0
100	0	0	0	0	0
101	0	1	1	0	0
102	2	0	0	0	0
103	0	0	0	0	0
104	0	0	0	0	0
105	0	0	0	0	0
106	0	0	0	0	0
107	0	0	0	0	0
108	0	0	0	0	0
109	0	0	0	0	0
110	0	0	1	0	0
111	0	0	0	1	0
112	1	0	0	0	0
113	0	1	0	0	0
114	0	0	1	0	0
115	3	0	0	0	0
116	0	0	0	0	0
117	0	2	0	0	0
118	1	0	0	0	0
119	0	0	0	0	0
120	0	0	1	0	0
121	2	2	0	0	0
122	0	0	0	0	3
123	0	0	0	0	0
124	0	0	0	0	0
125	0	0	0	0	0
126	0	0	0	0	0
127	0	0	1	0	0
128	1	0	0	0	0
129	1	1	0	0	0
130	0	1	0	0	0
131	0	0	1	0	0
132	3	0	0	0	0
133	0	1	0	0	0
134	0	0	0	0	0
135	0	0	0	0	0
136	2	2	0	0	0
137	0	0	1	0	0
138	0	0	0	0	0
139	0	0	0	0	0
140	0	0	0	0	3
141	0	0	0	0	0
142	0	0	0	0	0
143	0	0	0	0	0
144	0	0	0	0	0
145	2	0	1	0	0
146	0	0	0	0	0
147	0	1	0	0	0
148	0	0	0	0	0
149	0	1	1	0	0
150	0	0	0	0	0
151	2	0	0	0	0
152	0	0	0	0	0
153	0	0	0	0	0
154	0	2	0	0	0
155	0	0	0	0	0
156	2	0	0	0	0
157	0	0	0	0	0
158	0	0	0	0	0
159	0	0	0	0	0
160	0	0	0	0	0
161	0	0	0	0	0
162	0	0	0	0	0
163	0	0	0	0	0
164	1	1	0	0	0
165	0	0	1	0	0
166	1	0	0	0	0
167	0	2	0	0	0
168	0	0	0	1	0
169	0	0	0	0	0
170	0	0	1	0	0
171	2	0	0	0	0
172	0	1	0	0	0
173	1	0	0	0	0
174	0	0	1	0	0
175	0	0	0	0	0
176	0	0	0	0	3
177	0	0	0	0	0
178	0	0	0	0	0
179	0	0	0	0	0
180	0	0	0	0	0
181	1	0	0	0	0
182	0	3	3	0	0
183	2	0	0	0	0
184	0	0	0	0	0
185	0	0	2	1	0
186	3	0	0	0	0
187	0	2	0	0	0
188	0	0	0	0	0
189	6	2	1	0	0
190	0	0	0	0	0
191	0	0	0	0	0
192	0	0	0	0	0
193	4	3	1	0	0
194	0	0	0	0	0
195	0	0	0	0	0
196	0	0	0	0	1
197	0	0	0	0	0
198	0	0	0	0	0
199	0	0	0	0	0
200	0	1	1	0	0
201	2	0	0	0	0
202	2	0	0	0	0
203	0	2	1	0	0
204	1	0	0	0	0
205	0	0	0	0	0
206	1	0	1	0	0
207	0	0	0	0	0
208	0	0	0	0	0
209	0	0	0	0	0
210	0	0	0	0	0
211	0	0	0	0	0
212	0	0	0	0	0
213	0	0	0	0	0
214	0	0	0	0	0
215	0	0	0	0	0
216	0	0	0	0	0
217	0	1	1	0	0
218	3	0	0	0	0
219	2	0	0	0	0
220	2	4	2	0	0
221	0	0	0	0	0
222	0	0	0	0	0
223	0	3	0	0	0
224	0	0	1	1	0
225	4	0	0	0	0
226	0	2	1	0	0
227	3	0	0	0	0
228	3	0	0	0	0
229	0	0	0	0	0
230	0	0	0	0	3
231	0	0	0	0	0
232	0	0	0	0	0
233	0	0	0	0	0
234	0	0	0	0	0
235	0	0	0	0	0
236	0	1	2	0	0
237	0	0	0	0	0
238	0	0	0	1	0
239	4	0	0	0	0
240	0	0	1	0	0
241	0	2	0	0	0
242	0	0	0	0	0
243	0	0	0	0	0
244	0	1	1	0	0
245	3	0	0	0	0
246	0	0	0	0	0
247	0	0	0	0	0
248	0	0	0	0	2
249	0	0	0	0	0
250	0	0	0	0	0
251	0	0	0	0	0
252	0	0	0	0	0
253	0	0	2	0	0
254	2	0	0	0	0
255	0	0	3	1	0
256	3	0	0	0	0
257	2	4	0	0	0
258	2	0	0	0	0
259	3	0	0	0	0
260	0	2	0	0	0
261	0	5	2	0	0
262	6	0	0	0	0
263	0	2	0	0	0
264	0	0	0	0	0
265	0	0	0	0	0
266	0	0	0	0	3
267	0	0	0	0	0
268	0	0	0	0	0
269	0	0	0	0	0
270	0	0	0	0	0
271	0	0	0	0	0
272	1	0	2	0	0
273	0	2	0	0	0
274	0	0	0	1	0
275	2	0	1	0	0
276	0	0	0	0	0
277	0	1	0	0	0
278	0	0	0	0	0
279	3	1	0	0	0
280	0	1	2	0	0
281	2	0	0	0	0
282	0	0	0	0	0
283	0	0	0	0	0
284	0	0	0	0	1
285	0	0	0	0	0
286	0	0	0	0	0
287	0	0	0	0	0
288	0	0	0	0	0
289	0	0	1	0	0
290	0	0	0	0	0
291	0	0	0	1	0
292	1	0	0	0	0
293	0	1	1	0	0
294	1	0	0	0	0
295	0	0	0	0	0
296	0	1	0	0	0
297	0	0	1	0	0
298	0	1	0	0	0
299	3	0	0	0	0
300	0	0	0	0	0
301	0	0	0	0	0
302	0	0	0	0	0
303	0	0	0	0	0
304	0	0	0	0	0
305	0	0	0	0	0
306	0	0	0	0	0
307	4	0	0	0	0
308	0	2	1	0	0
309	2	0	0	0	0
310	0	0	2	0	0
311	0	0	0	0	0
312	0	4	0	0	0
313	3	0	2	0	0
314	0	0	0	0	0
315	4	0	0	0	0
316	0	2	0	0	0
317	0	0	0	0	0
318	4	0	1	0	0
319	0	3	0	0	0
320	0	0	0	0	2
321	0	0	0	0	0
322	0	0	0	0	0
323	0	0	0	0	0
324	0	0	0	0	0
325	0	0	0	0	0
326	3	2	3	0	0
327	1	0	1	0	0
328	3	0	2	0	0
329	0	2	0	0	0
330	0	0	0	0	0
331	2	1	1	0	0
332	0	0	0	0	0
333	0	0	0	0	0
334	0	3	0	0	0
335	4	0	0	0	0
336	0	0	0	1	0
337	0	0	0	0	0
338	0	0	0	0	1
339	0	0	0	0	0
340	0	0	0	0	0
341	0	0	0	0	0
342	0	0	0	0	0
343	1	0	0	0	0
344	2	0	2	0	0
345	0	2	0	0	0
346	0	0	0	1	0
347	2	0	0	0	0
348	0	1	0	0	0
349	0	0	0	0	0
350	3	0	0	0	0
351	0	0	2	0	0
352	0	0	0	1	0
353	0	2	0	0	0
354	0	0	0	0	0
355	0	0	1	0	0
356	0	0	0	0	1
357	0	0	0	0	0
358	0	0	0	0	0
359	0	0	0	0	0
360	0	0	0	0	0
365	0	0	0	0	0
\.


--
-- TOC entry 5028 (class 0 OID 16426)
-- Dependencies: 224
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.positions (position_id, name) FROM stdin;
1	Forward             
2	Midfielder          
3	Defender            
4	Goalkeeper          
\.


--
-- TOC entry 5033 (class 0 OID 16467)
-- Dependencies: 229
-- Data for Name: referees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referees (referee_id, first_name, last_name) FROM stdin;
1	Michael	Oliver
2	Anthony	Taylor
3	Paul	Tierney
4	Craig	Pawson
5	Stuart	Attwell
6	David	Coote
7	Simon	Hooper
8	Andy	Madley
9	John	Brooks
10	Robert	Jones
\.


--
-- TOC entry 5024 (class 0 OID 16397)
-- Dependencies: 220
-- Data for Name: stadiums; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stadiums (stadium_id, stadium_name) FROM stdin;
1	Emirates Stadium
2	Villa Park
3	Vitality Stadium
4	Gtech Community Stadium
5	Amex Stadium
6	Turf Moor
7	Stamford Bridge
8	Selhurst Park
9	Goodison Park
10	Craven Cottage
11	Anfield
12	Kenilworth Road
13	Etihad Stadium
14	Old Trafford
15	St. James Park
16	City Ground
17	Bramall Lane
18	Tottenham Hotspur Stadium
19	London Stadium
20	Molineux
\.


--
-- TOC entry 5022 (class 0 OID 16390)
-- Dependencies: 218
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teams (team_id, team_name, stadium_id, city, points, matches_played, wins, draws, losses, goals_scored, goals_conceded) FROM stdin;
4	Brentford	4	London                                            	3	7	0	3	1	6	8
9	Everton	9	Liverpool                                         	0	7	0	0	4	1	5
7	Chelsea	7	London                                            	4	7	1	1	2	4	3
10	Fulham	10	London                                            	3	8	1	0	2	1	5
15	Newcastle	15	Newcastle                                         	9	7	3	0	1	9	3
6	Burnley	6	Burnley                                           	0	7	0	0	4	5	12
12	Luton Town	12	Luton                                             	1	7	0	1	2	3	5
19	West Ham	19	London                                            	6	7	2	0	1	6	4
14	Manchester United	14	Manchester                                        	6	7	2	0	2	5	6
3	Bournemouth	3	Bournemouth                                       	2	7	0	2	2	1	7
17	Sheffield United	17	Sheffield                                         	1	7	0	1	3	3	13
20	Wolves	20	Wolverhampton                                     	3	7	1	0	2	4	8
13	Manchester City	13	Manchester                                        	9	7	3	0	0	8	1
1	Arsenal	1	London                                            	12	9	3	3	0	21	17
5	Brighton	5	Brighton                                          	9	7	3	0	1	11	6
18	Tottenham	18	London                                            	9	8	3	0	0	6	2
2	Aston Villa	2	Birmingham                                        	9	7	3	0	0	13	2
16	Nottingham Forest	16	Nottingham                                        	5	7	1	2	0	4	3
11	Liverpool	11	Liverpool                                         	9	7	3	0	0	9	2
8	Crystal Palace	8	London                                            	4	7	1	1	1	3	3
\.


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 221
-- Name: coaches_coach_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coaches_coach_id_seq', 29, true);


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 230
-- Name: matches_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matches_match_id_seq', 76, true);


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 225
-- Name: players_player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.players_player_id_seq', 365, true);


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 223
-- Name: positions_position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.positions_position_id_seq', 1, false);


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 228
-- Name: referees_referee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.referees_referee_id_seq', 12, true);


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 219
-- Name: stadiums_stadium_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stadiums_stadium_id_seq', 24, true);


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 217
-- Name: teams_team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teams_team_id_seq', 23, true);


--
-- TOC entry 4852 (class 2606 OID 16419)
-- Name: coaches coaches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coaches
    ADD CONSTRAINT coaches_pkey PRIMARY KEY (coach_id);


--
-- TOC entry 4860 (class 2606 OID 16481)
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (match_id);


--
-- TOC entry 4856 (class 2606 OID 16438)
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (player_id);


--
-- TOC entry 4854 (class 2606 OID 16431)
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (position_id);


--
-- TOC entry 4858 (class 2606 OID 16472)
-- Name: referees referees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referees
    ADD CONSTRAINT referees_pkey PRIMARY KEY (referee_id);


--
-- TOC entry 4850 (class 2606 OID 16402)
-- Name: stadiums stadiums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stadiums
    ADD CONSTRAINT stadiums_pkey PRIMARY KEY (stadium_id);


--
-- TOC entry 4848 (class 2606 OID 16395)
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (team_id);


--
-- TOC entry 4870 (class 2620 OID 24687)
-- Name: players trigger_add_player_statistics; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_add_player_statistics AFTER INSERT ON public.players FOR EACH ROW EXECUTE FUNCTION public.add_player_statistics();


--
-- TOC entry 4871 (class 2620 OID 24689)
-- Name: players trigger_delete_player_statistics; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_delete_player_statistics BEFORE DELETE ON public.players FOR EACH ROW EXECUTE FUNCTION public.delete_player_statistics();


--
-- TOC entry 4872 (class 2620 OID 24747)
-- Name: matches trigger_update_matches_played; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_matches_played AFTER INSERT OR DELETE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.update_matches_played();


--
-- TOC entry 4873 (class 2620 OID 24751)
-- Name: matches trigger_update_team_goals; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_team_goals AFTER INSERT OR DELETE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.update_team_goals();


--
-- TOC entry 4874 (class 2620 OID 24753)
-- Name: matches trigger_update_team_points; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_team_points AFTER INSERT OR DELETE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.update_team_points();


--
-- TOC entry 4875 (class 2620 OID 24749)
-- Name: matches trigger_update_team_results; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_team_results AFTER INSERT OR DELETE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.update_team_results();


--
-- TOC entry 4862 (class 2606 OID 16420)
-- Name: coaches coaches_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coaches
    ADD CONSTRAINT coaches_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(team_id);


--
-- TOC entry 4866 (class 2606 OID 24576)
-- Name: matches fk_referee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT fk_referee FOREIGN KEY (referee_id) REFERENCES public.referees(referee_id);


--
-- TOC entry 4861 (class 2606 OID 16408)
-- Name: teams fk_teams_stadiums; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT fk_teams_stadiums FOREIGN KEY (stadium_id) REFERENCES public.stadiums(stadium_id);


--
-- TOC entry 4867 (class 2606 OID 16487)
-- Name: matches matches_away_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_away_team_id_fkey FOREIGN KEY (away_team_id) REFERENCES public.teams(team_id);


--
-- TOC entry 4868 (class 2606 OID 16482)
-- Name: matches matches_home_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_home_team_id_fkey FOREIGN KEY (home_team_id) REFERENCES public.teams(team_id);


--
-- TOC entry 4869 (class 2606 OID 16492)
-- Name: matches matches_stadium_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES public.stadiums(stadium_id);


--
-- TOC entry 4863 (class 2606 OID 16439)
-- Name: players players_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.positions(position_id);


--
-- TOC entry 4865 (class 2606 OID 16461)
-- Name: players_statistics players_statistics_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players_statistics
    ADD CONSTRAINT players_statistics_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(player_id);


--
-- TOC entry 4864 (class 2606 OID 16444)
-- Name: players players_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(team_id);


-- Completed on 2025-01-12 21:00:34

--
-- PostgreSQL database dump complete
--

