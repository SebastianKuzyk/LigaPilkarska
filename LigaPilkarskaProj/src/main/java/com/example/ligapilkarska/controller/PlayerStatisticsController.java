package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.PlayerStatistics;
import com.example.ligapilkarska.service.PlayerStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/player-statistics")
public class PlayerStatisticsController {

    @Autowired
    private PlayerStatisticsService playerStatisticsService;

    // Endpoint do pobierania statystyk wszystkich graczy
    @GetMapping
    public List<PlayerStatistics> getPlayerStatistics() {
        return playerStatisticsService.getPlayerStatistics();
    }

    // Endpoint do edytowania statystyk gracza
    @PutMapping("/{playerId}")
    public void editPlayerStatistics(@PathVariable int playerId, @RequestBody PlayerStatistics stats) {
        playerStatisticsService.editPlayerStatistics(playerId, stats.getGoals(), stats.getAssists(), stats.getYellowCards(), stats.getRedCards(), stats.getCleanSheet());
    }
}
