package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.Match;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.time.LocalDate; // <--- Import LocalDate


@Service
public class MatchService {

    private static final Logger LOGGER = Logger.getLogger(MatchService.class.getName());

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * Dodaje nowy mecz do bazy danych.
     */
    public void addMatch(String homeTeamName, String awayTeamName, int homeTeamScore, int awayTeamScore, Date matchDate, String stadiumName, String refereeName) {
        String sql = "CALL add_match(?, ?, ?, ?, ?, ?, ?)";
        try {
            jdbcTemplate.update(sql, homeTeamName, awayTeamName, homeTeamScore, awayTeamScore, matchDate, stadiumName, refereeName);
        } catch (Exception e) {
            LOGGER.severe("❌ Błąd dodawania meczu: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Edytuje istniejący mecz.
     */
    public void editMatch(int matchId, String homeTeamName, String awayTeamName, int homeTeamScore, int awayTeamScore, String matchDate, String stadiumName, String refereeName) {
        String sql = "CALL edit_match_by_team_names(?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            LocalDate mDate = LocalDate.parse(matchDate);
            jdbcTemplate.update(sql, matchId, homeTeamName, awayTeamName, homeTeamScore, awayTeamScore, mDate, stadiumName, refereeName);
        } catch (Exception e) {
            LOGGER.severe("❌ Błąd edycji meczu: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Usuwa mecz o podanym ID.
     */
    public void deleteMatch(int matchId) {
        String sql = "CALL delete_match(?)";
        try {
            jdbcTemplate.update(sql, matchId);
        } catch (Exception e) {
            LOGGER.severe("❌ Błąd usuwania meczu: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Pobiera listę wszystkich meczów.
     */
    public List<Match> getMatchesInfo() {
        String sql = "SELECT * FROM get_matches_info()";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Match match = new Match();
            match.setId(rs.getInt("match_id"));
            match.setHomeTeamName(rs.getString("home_team_name").trim());
            match.setAwayTeamName(rs.getString("away_team_name").trim());
            match.setHomeTeamScore(rs.getInt("home_team_score"));
            match.setAwayTeamScore(rs.getInt("away_team_score"));
            match.setMatchDate(rs.getDate("match_date"));
            match.setStadiumName(rs.getString("stadium_name").trim());
            match.setRefereeName(rs.getString("referee_name").trim());
            return match;
        });
    }

    /**
     * Pobiera mecze dla podanej daty (format: YYYY-MM-DD).
     */
    public List<Match> getMatchesByDate(Date date) throws SQLException {
        List<Match> matches = new ArrayList<>();
        String query = "SELECT * FROM get_matches_by_date(?)"; // Używamy funkcji SQL

        try (Connection connection = jdbcTemplate.getDataSource().getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {
            if (date == null) {
                throw new IllegalArgumentException("❌ Błąd: Data nie może być pusta!");
            }
            stmt.setDate(1, date);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Match match = new Match();
                match.setHomeTeamName(rs.getString("home_team_name"));
                match.setHomeTeamScore(rs.getInt("home_team_score"));
                match.setAwayTeamScore(rs.getInt("away_team_score"));
                match.setAwayTeamName(rs.getString("away_team_name"));
                match.setMatchDate(rs.getDate("match_date"));
                matches.add(match);
            }
        } catch (Exception e) {
            throw new SQLException("❌ Błąd pobierania meczów: " + e.getMessage());
        }
        return matches;
    }

}
