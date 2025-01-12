package com.example.ligapilkarska.model;

public class PlayerStatistics {
    private int playerId;
    private String playerName;
    private int goals;
    private int assists;
    private int yellowCards;
    private int redCards;
    private int cleanSheet;

    // Konstruktor domyślny
    public PlayerStatistics() {}

    // Konstruktor z parametrami
    public PlayerStatistics(int playerId, String playerName, int goals, int assists, int yellowCards, int redCards, int cleanSheet) {
        this.playerId = playerId;
        this.playerName = playerName;
        this.goals = goals;
        this.assists = assists;
        this.yellowCards = yellowCards;
        this.redCards = redCards;
        this.cleanSheet = cleanSheet;
    }

    // Gettery i settery
    public int getPlayerId() {
        return playerId;
    }

    public void setPlayerId(int playerId) {
        this.playerId = playerId;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public int getGoals() {
        return goals;
    }

    public void setGoals(int goals) {
        this.goals = goals;
    }

    public int getAssists() {
        return assists;
    }

    public void setAssists(int assists) {
        this.assists = assists;
    }

    public int getYellowCards() {
        return yellowCards;
    }

    public void setYellowCards(int yellowCards) {
        this.yellowCards = yellowCards;
    }

    public int getRedCards() {
        return redCards;
    }

    public void setRedCards(int redCards) {
        this.redCards = redCards;
    }

    public int getCleanSheet() {
        return cleanSheet;
    }

    public void setCleanSheet(int cleanSheet) {
        this.cleanSheet = cleanSheet;
    }
}
