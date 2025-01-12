package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.MatchDetails;
import com.example.ligapilkarska.service.MatchDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/match-details")
public class MatchDetailsController {

    @Autowired
    private MatchDetailsService matchDetailsService;

    @GetMapping("/{teamId}/recent")
    public List<MatchDetails> getRecentMatches(@PathVariable int teamId) {
        return matchDetailsService.getRecentMatches(teamId);
    }
    @GetMapping("/{teamId}/all")
    public List<MatchDetails> getTeamMatches(@PathVariable int teamId) {
        return matchDetailsService.getMatchesByTeam(teamId);
    }
}
