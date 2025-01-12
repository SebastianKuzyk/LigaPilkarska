package com.example.ligapilkarska.model;

public class Stadium {
    private int stadiumId;
    private String stadiumName;

    // Konstruktor domyślny
    public Stadium() {}

    // Konstruktor z parametrami
    public Stadium(int stadiumId, String stadiumName) {
        this.stadiumId = stadiumId;
        this.stadiumName = stadiumName;
    }

    // Gettery i settery
    public int getStadiumId() {
        return stadiumId;
    }

    public void setStadiumId(int stadiumId) {
        this.stadiumId = stadiumId;
    }

    public String getStadiumName() {
        return stadiumName;
    }

    public void setStadiumName(String stadiumName) {
        this.stadiumName = stadiumName;
    }
}
