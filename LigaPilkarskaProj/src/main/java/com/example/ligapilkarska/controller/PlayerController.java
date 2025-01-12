package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.Player;
import com.example.ligapilkarska.service.PlayerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/players")

public class PlayerController {

    @Autowired
    private PlayerService playerService;

    @Autowired
    private DataSource dataSource;

    @GetMapping("/top-scorers")
    public ResponseEntity<List<Player>> getTopScorers() {
        return getPlayersFromQuery("SELECT * FROM get_top_scorers()", "goals");
    }

    @GetMapping("/top-assisters")
    public ResponseEntity<List<Player>> getTopAssisters() {
        return getPlayersFromQuery("SELECT * FROM get_top_assisters()", "assists");
    }

    @GetMapping("/top-goalkeepers")
    public ResponseEntity<List<Player>> getTopGoalkeepers() {
        return getPlayersFromQuery("SELECT * FROM get_top_goalkeepers()", "clean_sheets");
    }

    private ResponseEntity<List<Player>> getPlayersFromQuery(String query, String statisticColumn) {
        List<Player> players = new ArrayList<>();
        try (Connection connection = dataSource.getConnection()) {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                Player player = new Player();
                player.setFirstName(rs.getString("first_name"));
                player.setLastName(rs.getString("last_name"));
                player.setTeamName(rs.getString("team_name"));
                player.setStatistic(rs.getInt(statisticColumn));
                players.add(player);
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
        return ResponseEntity.ok(players);
    }

    @GetMapping("/details")
    public List<Player> getPlayersWithDetails() {
        return playerService.getPlayersWithDetails();
    }

    // Nowy endpoint do dodawania gracza (przekazujemy nazwę drużyny i pozycji, nie ID)
    @PostMapping("/details")
    public void addPlayerWithDetails(@RequestBody Player player) {
        playerService.addPlayerWithDetails(player.getFirstName(), player.getLastName(), player.getPositionName(), player.getTeamName());
    }

    // Nowy endpoint do edycji gracza (aktualizacja drużyny i pozycji po nazwie)
    @PutMapping("/details/{id}")
    public void editPlayerWithDetails(@PathVariable int id, @RequestBody Player player) {
        playerService.editPlayerWithDetails(id, player.getFirstName(), player.getLastName(), player.getPositionName(), player.getTeamName());
    }

    // Nowy endpoint do usuwania gracza
    @DeleteMapping("/details/{id}")
    public void deletePlayerById(@PathVariable int id) {
        playerService.deletePlayerById(id);
    }
}
