package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.PlayerStatistics;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PlayerStatisticsService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Pobieranie statystyk graczy z bazy danych
    public List<PlayerStatistics> getPlayerStatistics() {
        String sql = "SELECT * FROM get_player_statistics()";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new PlayerStatistics(
                rs.getInt("player_id"),
                rs.getString("player_name"),
                rs.getInt("goals"),
                rs.getInt("assists"),
                rs.getInt("yellow_cards"),
                rs.getInt("red_cards"),
                rs.getInt("clean_sheet")
        ));
    }

    // Edycja statystyk gracza
    public void editPlayerStatistics(int playerId, int goals, int assists, int yellowCards, int redCards, int cleanSheet) {
        String sql = "CALL edit_player_statistics(?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, playerId, goals, assists, yellowCards, redCards, cleanSheet);
    }
}
