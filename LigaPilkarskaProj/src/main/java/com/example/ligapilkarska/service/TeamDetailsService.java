package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.TeamDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TeamDetailsService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public TeamDetails getTeamDetails(int teamId) {
        String sql = "SELECT * FROM get_team_details(?)";
        List<TeamDetails> result = jdbcTemplate.query(sql, ps -> ps.setInt(1, teamId), (rs, rowNum) ->
                new TeamDetails(
                        rs.getInt("team_id"),
                        rs.getString("team_name"),
                        rs.getString("stadium_name"),
                        rs.getString("city"),
                        rs.getString("coach_name")
                ));

        return result.isEmpty() ? null : result.get(0);
    }

    public List<TeamDetails> getTeamPlayers(int teamId) {
        String sql = "SELECT * FROM get_team_players(?)";
        return jdbcTemplate.query(sql, ps -> ps.setInt(1, teamId), (rs, rowNum) ->
                new TeamDetails(
                        rs.getInt("player_id"),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("position_name"),
                        rs.getInt("goals"),
                        rs.getInt("assists"),
                        rs.getInt("clean_sheet"),
                        rs.getInt("yellow_cards"),
                        rs.getInt("red_cards")
                ));
    }

}
