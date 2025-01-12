package com.example.ligapilkarska.model;

import java.sql.Date;

public class MatchDetails {
    private int matchId;
    private String homeTeamName;
    private String awayTeamName;
    private int homeTeamScore;
    private int awayTeamScore;
    private Date matchDate;
    private String stadiumName;
    private String locationType;

    // 🔹 Konstruktor domyślny (wymagany dla niektórych operacji Springa)
    public MatchDetails() {}

    // 🔹 Konstruktor główny
    public MatchDetails(int matchId, String homeTeamName, String awayTeamName, int homeTeamScore, int awayTeamScore, Date matchDate, String stadiumName, String locationType) {
        this.matchId = matchId;
        this.homeTeamName = homeTeamName;
        this.awayTeamName = awayTeamName;
        this.homeTeamScore = homeTeamScore;
        this.awayTeamScore = awayTeamScore;
        this.matchDate = matchDate;
        this.stadiumName = stadiumName;
        this.locationType = locationType;
    }

    // 🔹 Gettery i Settery
    public int getMatchId() {
        return matchId;
    }

    public void setMatchId(int matchId) {
        this.matchId = matchId;
    }

    public String getHomeTeamName() {
        return homeTeamName;
    }

    public void setHomeTeamName(String homeTeamName) {
        this.homeTeamName = homeTeamName;
    }

    public String getAwayTeamName() {
        return awayTeamName;
    }

    public void setAwayTeamName(String awayTeamName) {
        this.awayTeamName = awayTeamName;
    }

    public int getHomeTeamScore() {
        return homeTeamScore;
    }

    public void setHomeTeamScore(int homeTeamScore) {
        this.homeTeamScore = homeTeamScore;
    }

    public int getAwayTeamScore() {
        return awayTeamScore;
    }

    public void setAwayTeamScore(int awayTeamScore) {
        this.awayTeamScore = awayTeamScore;
    }

    public Date getMatchDate() {
        return matchDate;
    }

    public void setMatchDate(Date matchDate) {
        this.matchDate = matchDate;
    }

    public String getStadiumName() {
        return stadiumName;
    }

    public void setStadiumName(String stadiumName) {
        this.stadiumName = stadiumName;
    }

    public String getLocationType() {
        return locationType;
    }

    public void setLocationType(String locationType) {
        this.locationType = locationType;
    }

    // 🔹 Metoda toString() dla łatwego debugowania
    @Override
    public String toString() {
        return "MatchDetails{" +
                "matchId=" + matchId +
                ", homeTeamName='" + homeTeamName + '\'' +
                ", awayTeamName='" + awayTeamName + '\'' +
                ", homeTeamScore=" + homeTeamScore +
                ", awayTeamScore=" + awayTeamScore +
                ", matchDate=" + matchDate +
                ", stadiumName='" + stadiumName + '\'' +
                ", locationType='" + locationType + '\'' +
                '}';
    }
}
