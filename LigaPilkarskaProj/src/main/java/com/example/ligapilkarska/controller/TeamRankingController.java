package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.service.TeamRankingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/team-ranking")
public class TeamRankingController {

    @Autowired
    private TeamRankingService teamRankingService;

    // ✅ Pobieranie pozycji drużyny w rankingu
    @GetMapping("/{teamId}")
    public int getTeamRanking(@PathVariable int teamId) {
        return teamRankingService.getTeamRanking(teamId);
    }
}
