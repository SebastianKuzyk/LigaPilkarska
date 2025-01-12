package com.example.ligapilkarska.model;

import jakarta.persistence.*;

@Entity
@Table(name = "teams") // Nazwa tabeli w bazie danych
public class Team {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "team_id") // Mapowanie kolumny ID
    private Long teamId;

    @Column(name = "team_name", nullable = false, length = 50)
    private String teamName;

    @Column(name = "stadium_name", nullable = false, length = 100)
    private String stadiumName;

    @Column(name = "city", nullable = false, length = 50)
    private String city;

    @Column(name = "points", nullable = false)
    private int points;

    @Column(name = "matches_played", nullable = false)
    private int matchesPlayed;

    @Column(name = "wins", nullable = false)
    private int wins;

    @Column(name = "draws", nullable = false)
    private int draws;

    @Column(name = "losses", nullable = false)
    private int losses;

    @Column(name = "goals_scored", nullable = false)
    private int goalsScored;

    @Column(name = "goals_conceded", nullable = false)
    private int goalsConceded;

    @Column(name = "ranking")
    private int ranking;

    // Konstruktor domyślny
    public Team() {}

    // Konstruktor z parametrami
    public Team(Long teamId, String teamName, String stadiumName, String city, int points, int matchesPlayed, int wins, int draws, int losses, int goalsScored, int goalsConceded) {
        this.teamId = teamId;
        this.teamName = teamName;
        this.stadiumName = stadiumName;
        this.city = city;
        this.points = points;
        this.matchesPlayed = matchesPlayed;
        this.wins = wins;
        this.draws = draws;
        this.losses = losses;
        this.goalsScored = goalsScored;
        this.goalsConceded = goalsConceded;
    }

    public Team(Long teamId, String teamName, int points, int goal_difference, int yellow_cards, int red_cards, int ranking) {}

    // Gettery i settery
    public Long getTeamId() {
        return teamId;
    }

    public void setTeamId(Long teamId) {
        this.teamId = teamId;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getStadiumName() {
        return stadiumName;
    }

    public void setStadiumName(String stadiumName) {
        this.stadiumName = stadiumName;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public int getMatchesPlayed() {
        return matchesPlayed;
    }

    public void setMatchesPlayed(int matchesPlayed) {
        this.matchesPlayed = matchesPlayed;
    }

    public int getWins() {
        return wins;
    }

    public void setWins(int wins) {
        this.wins = wins;
    }

    public int getDraws() {
        return draws;
    }

    public void setDraws(int draws) {
        this.draws = draws;
    }

    public int getLosses() {
        return losses;
    }

    public void setLosses(int losses) {
        this.losses = losses;
    }

    public int getGoalsScored() {
        return goalsScored;
    }

    public void setGoalsScored(int goalsScored) {
        this.goalsScored = goalsScored;
    }

    public int getGoalsConceded() {
        return goalsConceded;
    }

    public void setGoalsConceded(int goalsConceded) {
        this.goalsConceded = goalsConceded;
    }

    public int getRanking() {
        return ranking;
    }

    public void setRanking(int ranking) {
        this.ranking = ranking;
    }

}