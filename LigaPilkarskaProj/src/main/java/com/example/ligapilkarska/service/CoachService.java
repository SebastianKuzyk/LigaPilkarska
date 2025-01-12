package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.Coach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.logging.Logger;

@Service
public class CoachService {

    private static final Logger LOGGER = Logger.getLogger(CoachService.class.getName());

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Coach> getAllCoaches() {
        String sql = "SELECT coach_id, first_name, last_name, team_name FROM get_coaches_info()";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Coach(
                rs.getInt("coach_id"),
                rs.getString("first_name").trim(),
                rs.getString("last_name").trim(),
                rs.getString("team_name").trim()
        ));
    }

    public void addCoach(String firstName, String lastName, String teamName) {
        String sql = "CALL add_coach_by_team_name(?, ?, ?)";
        try {
            jdbcTemplate.update(sql, firstName, lastName, teamName);
        } catch (Exception e) {
            LOGGER.severe("Error adding coach: " + e.getMessage());
            throw e;  // Rzuć wyjątek ponownie, aby można było zobaczyć komunikat w logach
        }
    }

    public void deleteCoach(int coachId) {
        String sql = "CALL delete_coach(?)";
        try {
            jdbcTemplate.update(sql, coachId);
        } catch (Exception e) {
            LOGGER.severe("Error deleting coach: " + e.getMessage());
            throw e;  // Rzuć wyjątek ponownie, aby można było zobaczyć komunikat w logach
        }
    }

    public void editCoach(int coachId, String firstName, String lastName, String teamName) {
        int teamId = getTeamIdByName(teamName);
        String sql = "CALL edit_coach(?, ?, ?, ?)";
        try {
            jdbcTemplate.update(sql, coachId, firstName, lastName, teamId);
        } catch (Exception e) {
            LOGGER.severe("Error editing coach: " + e.getMessage());
            throw e;  // Rzuć wyjątek ponownie, aby można było zobaczyć komunikat w logach
        }
    }

    private int getTeamIdByName(String teamName) {
        String sql = "SELECT get_team_id_by_name(?)";
        return jdbcTemplate.queryForObject(sql, new Object[]{teamName}, Integer.class);
    }
}
