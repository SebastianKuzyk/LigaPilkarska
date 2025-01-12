package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.MatchDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MatchDetailsService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<MatchDetails> getRecentMatches(int teamId) {
        String sql = "SELECT * FROM get_recent_matches_by_team(?)";
        return jdbcTemplate.query(sql, ps -> ps.setInt(1, teamId), (rs, rowNum) ->
                new MatchDetails(
                        rs.getInt("match_id"),
                        rs.getString("home_team_name"),
                        rs.getString("away_team_name"),
                        rs.getInt("home_team_score"),
                        rs.getInt("away_team_score"),
                        rs.getDate("match_date"),
                        rs.getString("stadium_name"),
                        rs.getString("location_type")
                ));
    }

    public List<MatchDetails> getMatchesByTeam(int teamId) {
        String sql = "SELECT * FROM get_all_matches_by_team(?)";
        return jdbcTemplate.query(sql, ps -> ps.setInt(1, teamId), (rs, rowNum) ->
                new MatchDetails(
                        rs.getInt("match_id"),
                        rs.getString("home_team_name"),
                        rs.getString("away_team_name"),
                        rs.getInt("home_team_score"),
                        rs.getInt("away_team_score"),
                        rs.getDate("match_date"),
                        rs.getString("stadium_name"),
                        rs.getString("location_type")
                ));
    }
}
