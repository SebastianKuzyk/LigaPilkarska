package com.example.ligapilkarska.model;

public class MatchResultStats {
    private String matchResult;
    private long matchCount;
    private double percentage;

    public MatchResultStats(String matchResult, long matchCount, double percentage) {
        this.matchResult = matchResult;
        this.matchCount = matchCount;
        this.percentage = percentage;
    }

    // Gettery i settery
    public String getMatchResult() {
        return matchResult;
    }

    public void setMatchResult(String matchResult) {
        this.matchResult = matchResult;
    }

    public long getMatchCount() {
        return matchCount;
    }

    public void setMatchCount(long matchCount) {
        this.matchCount = matchCount;
    }

    public double getPercentage() {
        return percentage;
    }

    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }
}
