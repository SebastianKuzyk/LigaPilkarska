package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.PlayerDetails;
import com.example.ligapilkarska.service.PlayerDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/player-details")
public class PlayerDetailsController {

    @Autowired
    private PlayerDetailsService playerDetailsService;

    @GetMapping("/{teamId}")
    public List<PlayerDetails> getTopPlayers(@PathVariable int teamId) {
        return playerDetailsService.getTopPlayers(teamId);
    }
}
