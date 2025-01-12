package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.Match;
import com.example.ligapilkarska.service.MatchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/matches")
public class MatchController {

    @Autowired
    private MatchService matchService;

    @Autowired
    private DataSource dataSource; // Wstrzyknięcie DataSource do pobierania dat meczów

    /**
     * Dodaje nowy mecz do bazy danych.
     */
    @PostMapping
    public ResponseEntity<String> addMatch(@RequestBody Match match) {
        try {
            matchService.addMatch(
                    match.getHomeTeamName(),
                    match.getAwayTeamName(),
                    match.getHomeTeamScore(),
                    match.getAwayTeamScore(),
                    match.getMatchDate(),
                    match.getStadiumName(),
                    match.getRefereeName()
            );
            return ResponseEntity.ok("Mecz dodany pomyślnie.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Błąd dodawania meczu: " + e.getMessage());
        }
    }

    /**
     * Aktualizuje istniejący mecz.
     */
    @PutMapping("/{id}")
    public ResponseEntity<String> editMatch(@PathVariable int id, @RequestBody Match match) {
        try {
            matchService.editMatch(
                    id,
                    match.getHomeTeamName(),
                    match.getAwayTeamName(),
                    match.getHomeTeamScore(),
                    match.getAwayTeamScore(),
                    match.getMatchDate().toString(),
                    match.getStadiumName(),
                    match.getRefereeName()
            );
            return ResponseEntity.ok("Mecz zaktualizowany pomyślnie.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Błąd aktualizacji meczu: " + e.getMessage());
        }
    }

    /**
     * Usuwa mecz o podanym ID.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteMatch(@PathVariable int id) {
        try {
            matchService.deleteMatch(id);
            return ResponseEntity.ok("Mecz usunięty pomyślnie.");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Błąd usuwania meczu: " + e.getMessage());
        }
    }

    /**
     * Pobiera wszystkie mecze.
     */
    @GetMapping
    public ResponseEntity<List<Match>> getMatchesInfo() {
        try {
            return ResponseEntity.ok(matchService.getMatchesInfo());
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    /**
     * Pobiera mecze dla podanej daty (format: YYYY-MM-DD).
     */
    @GetMapping("/by-date")
    public ResponseEntity<List<Match>> getMatchesByDate(@RequestParam("date") Date date) {
        System.out.println("📌 Otrzymano żądanie: /api/matches/by-date?date=" + date); // DEBUG

        try {
            List<Match> matches = matchService.getMatchesByDate(date);
            if (matches.isEmpty()) {
                return ResponseEntity.ok(new ArrayList<>()); // Zwróć pustą listę, jeśli brak meczów
            }
            return ResponseEntity.ok(matches);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    /**
     * Pobiera unikalne daty meczów.
     */
    @GetMapping("/dates")
    public ResponseEntity<List<String>> getAllMatchDates() {
        List<String> matchDates = new ArrayList<>();
        try (Connection connection = dataSource.getConnection()) { // Pobranie połączenia
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT DISTINCT match_date FROM matches ORDER BY match_date");

            while (rs.next()) {
                matchDates.add(rs.getString("match_date"));
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
        return ResponseEntity.ok(matchDates);
    }
}
