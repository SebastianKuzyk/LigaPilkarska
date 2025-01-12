package com.example.ligapilkarska.model;

public class TeamDetails {
    private int playerId;
    private String firstName;
    private String lastName;
    private String positionName;
    private int goals;
    private int assists;
    private int cleanSheets;
    private int yellowCards;
    private int redCards;
    private int teamId;
    private String teamName;
    private String stadiumName;
    private String city;
    private String coachName;

    public TeamDetails() {};

    public TeamDetails(int teamId, String teamName, String stadiumName, String city, String coachName) {
        this.teamId = teamId;
        this.teamName = teamName;
        this.stadiumName = stadiumName;
        this.city = city;
        this.coachName = coachName;
    }

    public TeamDetails(int playerId, String firstName, String lastName, String positionName,
                       int goals, int assists, int cleanSheets, int yellowCards, int redCards) {
        this.playerId = playerId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.positionName = positionName;
        this.goals = goals;
        this.assists = assists;
        this.cleanSheets = cleanSheets;
        this.yellowCards = yellowCards;
        this.redCards = redCards;
    }

    // Gettery i settery
    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public int getPlayerId() {
        return playerId;
    }

    public void setPlayerId(int playerId) {
        this.playerId = playerId;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPositionName() {
        return positionName;
    }

    public void setPositionName(String positionName) {
        this.positionName = positionName;
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

    public int getCleanSheets() {
        return cleanSheets;
    }

    public void setCleanSheets(int cleanSheets) {
        this.cleanSheets = cleanSheets;
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

    public int getTeamId() {
        return teamId;
    }

    public void setTeamId(int teamId) {
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

    public String getCoachName() {
        return coachName;
    }

    public void setCoachName(String coachName) {
        this.coachName = coachName;
    }
}
