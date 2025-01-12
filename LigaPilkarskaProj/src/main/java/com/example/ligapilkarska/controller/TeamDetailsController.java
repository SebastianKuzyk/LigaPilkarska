package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.TeamDetails;
import com.example.ligapilkarska.service.TeamDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/team-details")
public class TeamDetailsController {

    @Autowired
    private TeamDetailsService teamDetailsService;

    @GetMapping("/{teamId}")
    public TeamDetails getTeamDetails(@PathVariable int teamId) {
        return teamDetailsService.getTeamDetails(teamId);
    }

    @GetMapping("/{teamId}/players")
    public List<TeamDetails> getTeamPlayers(@PathVariable int teamId) {
        return teamDetailsService.getTeamPlayers(teamId);
    }

}
