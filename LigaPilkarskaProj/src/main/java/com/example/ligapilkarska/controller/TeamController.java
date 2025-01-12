package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.Team;
import com.example.ligapilkarska.service.TeamService;
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
@RequestMapping("/api/teams")
public class TeamController {

    @Autowired
    private TeamService teamService;

    @Autowired
    private DataSource dataSource;

    // ✅ Pobieranie wszystkich drużyn z bazy danych przy użyciu TeamService
    @GetMapping
    public List<Team> getAllTeams() {
        return teamService.getAllTeams();
    }

    @GetMapping("/ranking")
    public ResponseEntity<List<Team>> getTeamsRanking() {
        List<Team> teams = new ArrayList<>();
        try (Connection connection = dataSource.getConnection()) {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM getallteamsranking()");

            while (rs.next()) {
                Team team = new Team();
                team.setTeamId(rs.getLong("team_id"));
                team.setTeamName(rs.getString("team_name"));
                team.setRanking(rs.getInt("ranking"));
                teams.add(team);
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
        return ResponseEntity.ok(teams);
    }

    // ✅ Pobieranie drużyn BEZPOŚREDNIO z bazy danych przy użyciu DataSource
    @GetMapping("/raw")
    public ResponseEntity<List<Team>> getTeamsRaw() {
        List<Team> teams = new ArrayList<>();
        try (Connection connection = dataSource.getConnection()) {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT team_name FROM teams");

            while (rs.next()) {
                Team team = new Team();
                team.setTeamName(rs.getString("team_name")); // Pobieranie nazwy zespołu z wyniku zapytania
                teams.add(team);
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
        return ResponseEntity.ok(teams);
    }

    // ✅ Dodawanie nowej drużyny
    @PostMapping
    public void addTeam(@RequestBody Team team) {
        teamService.addTeam(team.getTeamName(), team.getStadiumName(), team.getCity());
    }

    // ✅ Edytowanie drużyny
    @PutMapping("/{teamId}")
    public void editTeam(@PathVariable Long teamId, @RequestBody Team team) {
        teamService.editTeam(teamId, team.getTeamName(), team.getStadiumName(), team.getCity());
    }

    // ✅ Usuwanie drużyny
    @DeleteMapping("/{teamId}")
    public void deleteTeam(@PathVariable Long teamId) {
        teamService.deleteTeam(teamId);
    }
}