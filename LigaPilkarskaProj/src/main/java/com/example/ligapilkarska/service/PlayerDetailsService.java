package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.PlayerDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PlayerDetailsService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<PlayerDetails> getTopPlayers(int teamId) {
        String sql = "SELECT * FROM get_top_players_by_team(?)";
        return jdbcTemplate.query(sql, ps -> ps.setInt(1, teamId), (rs, rowNum) ->
                new PlayerDetails(
                        rs.getInt("player_id"),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("statistic_type"),
                        rs.getInt("statistic_value")
                ));
    }
}
