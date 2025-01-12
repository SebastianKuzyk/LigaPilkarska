package com.example.ligapilkarska.model;

public class Coach {
    private int id;
    private String firstName;
    private String lastName;
    private String teamName;
    private int teamId;

    public Coach() {}
    
    public Coach(int id, String firstName, String lastName, String teamName) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.teamName = teamName;
    }

    public Coach(int id, String firstName, String lastName, String teamName, int teamId) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.teamName = teamName;
        this.teamId = teamId;
    }

    // Gettery i settery
    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public int getTeamId() {
        return teamId;
    }

    public void setTeamId(int teamId) {
        this.teamId = teamId;
    }

    public int getId() {
        return id;
    }
}
