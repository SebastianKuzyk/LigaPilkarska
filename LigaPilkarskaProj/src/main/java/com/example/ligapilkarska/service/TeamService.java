package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.Team;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TeamService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Pobieranie wszystkich drużyn z nazwą stadionu
    public List<Team> getAllTeams() {
        String sql = "SELECT * FROM get_all_teams()";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Team(
                rs.getLong("team_id"),
                rs.getString("team_name"),
                rs.getString("stadium_name"),
                rs.getString("city"),
                rs.getInt("points"),
                rs.getInt("matches_played"),
                rs.getInt("wins"),
                rs.getInt("draws"),
                rs.getInt("losses"),
                rs.getInt("goals_scored"),
                rs.getInt("goals_conceded")
        ));
    }

    // Pobieranie rankingu drużyn na podstawie funkcji z bazy danych
    public List<Team> getAllTeamsRanking() {
        String sql = "SELECT * FROM getallteamsranking()";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Team(
                rs.getLong("team_id"),
                rs.getString("team_name"),
                rs.getInt("points"),
                rs.getInt("goal_difference"),
                rs.getInt("yellow_cards"),
                rs.getInt("red_cards"),
                rs.getInt("ranking")
        ));
    }

    // Dodawanie nowej drużyny (po nazwie stadionu)
    public void addTeam(String teamName, String stadiumName, String city) {
        String sql = "CALL add_team(?, ?, ?)";
        jdbcTemplate.update(sql, teamName, stadiumName, city);
    }

    // Edytowanie drużyny (po nazwie stadionu)
    public void editTeam(Long teamId, String teamName, String stadiumName, String city) {
        String sql = "CALL edit_team(?, ?, ?, ?)";
        jdbcTemplate.update(sql, teamId, teamName, stadiumName, city);
    }

    // Usuwanie drużyny
    public void deleteTeam(Long teamId) {
        String sql = "CALL delete_team(?)";
        jdbcTemplate.update(sql, teamId);
    }
}