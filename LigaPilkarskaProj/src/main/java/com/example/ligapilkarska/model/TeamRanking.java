package com.example.ligapilkarska.model;

public class TeamRanking {
    private int teamId;
    private String teamName;
    private int ranking;

    // ✅ Konstruktor
    public TeamRanking(int teamId, String teamName, int ranking) {
        this.teamId = teamId;
        this.teamName = teamName;
        this.ranking = ranking;
    }

    // ✅ Gettery
    public int getTeamId() {
        return teamId;
    }

    public String getTeamName() {
        return teamName;
    }

    public int getRanking() {
        return ranking;
    }
}
