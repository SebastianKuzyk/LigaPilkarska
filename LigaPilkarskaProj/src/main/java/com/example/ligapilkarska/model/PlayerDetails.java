package com.example.ligapilkarska.model;

public class PlayerDetails {
    private int playerId;
    private String firstName;
    private String lastName;
    private String statisticType;
    private int statisticValue;

    public PlayerDetails() {};

    public PlayerDetails(int playerId, String firstName, String lastName, String statisticType, int statisticValue) {
        this.playerId = playerId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.statisticType = statisticType;
        this.statisticValue = statisticValue;
    }

    // Gettery i settery
    public int getPlayerId() { return playerId; }
    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }
    public String getStatisticType() { return statisticType; }
    public int getStatisticValue() { return statisticValue; }
}
