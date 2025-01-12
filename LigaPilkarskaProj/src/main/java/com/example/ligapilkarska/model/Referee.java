package com.example.ligapilkarska.model;

public class Referee {
    private int refereeId;
    private String firstName;
    private String lastName;

    // Konstruktor domyślny
    public Referee() {}

    // Konstruktor z parametrami
    public Referee(int refereeId, String firstName, String lastName) {
        this.refereeId = refereeId;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    // Gettery i settery
    public int getRefereeId() {
        return refereeId;
    }

    public void setRefereeId(int refereeId) {
        this.refereeId = refereeId;
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
}
