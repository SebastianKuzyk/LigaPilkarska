package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.MatchResultStats;
import com.example.ligapilkarska.model.TeamStats;
import com.example.ligapilkarska.service.TeamStatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/team-stats")
public class TeamStatsController {

    @Autowired
    private TeamStatsService teamStatsService;

    @GetMapping("/ranking")
    public List<TeamStats> getAllTeamsRanking() {
        return teamStatsService.getAllTeamsRanking();
    }

    @GetMapping("/attack")
    public List<TeamStats> getBestAttackingTeams() {
        return teamStatsService.getBestAttackingTeams();
    }

    @GetMapping("/defense")
    public List<TeamStats> getBestDefensiveTeams() {
        return teamStatsService.getBestDefensiveTeams();
    }

    @GetMapping("/average-points")
    public List<TeamStats> getAveragePointsPerMatch() {
        return teamStatsService.getAveragePointsPerMatch();
    }

    @GetMapping("/home-away")
    public List<TeamStats> getHomeAwayPerformance() {
        return teamStatsService.getHomeAwayPerformance();
    }

    @GetMapping("/most-common-results")
    public List<MatchResultStats> getMostCommonMatchResults() {
        return teamStatsService.getMostCommonMatchResults();
    }
}
