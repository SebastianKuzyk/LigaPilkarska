package com.example.ligapilkarska.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Player {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String firstName;
    private String lastName;
    private String positionName; // Nowe pole: nazwa pozycji zamiast ID
    private String teamName; // Nowe pole: nazwa drużyny zamiast ID
    private int statistic; // Może przechowywać wartości dla "goals", "assists", "clean_sheets"

    // Konstruktory
    public Player() {}

    public Player(int id, String firstName, String lastName, String positionName, String teamName) {
        this.id = id;  // 🔹 Teraz obsługuje ID gracza
        this.firstName = firstName;
        this.lastName = lastName;
        this.positionName = positionName;
        this.teamName = teamName;
    }

    // Gettery i settery
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

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

    public String getPositionName() {
        return positionName;
    }

    public void setPositionName(String positionName) {
        this.positionName = positionName;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public int getStatistic() {
        return statistic;
    }

    public void setStatistic(int statistic) {
        this.statistic = statistic;
    }
}
