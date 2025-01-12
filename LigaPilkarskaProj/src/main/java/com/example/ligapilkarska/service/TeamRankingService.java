package com.example.ligapilkarska.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class TeamRankingService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ✅ Pobieranie pozycji drużyny w rankingu (zwraca tylko `ranking`)
    public int getTeamRanking(int teamId) {
        String sql = "SELECT getTeamRanking(?)"; // Zmieniamy na SELECT getTeamRanking(?)
        return jdbcTemplate.queryForObject(sql, Integer.class, teamId);
    }
}
