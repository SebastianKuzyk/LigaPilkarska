package com.example.ligapilkarska.model;

public class TeamStats {
    private long teamId;
    private String teamName;
    private long points;
    private long goalDifference;
    private long yellowCards;
    private long redCards;
    private long ranking;
    private long goalsScored;
    private double attackPercentage;
    private long goalsConceded;
    private double defensePercentage;
    private long matchesPlayed;
    private long totalPoints;
    private double avgPointsPerMatch;
    private long homeMatches;
    private long homePoints;
    private double avgHomePoints;
    private long awayMatches;
    private long awayPoints;
    private double avgAwayPoints;
    private double homeAdvantage;

    public TeamStats() {}

    public TeamStats(long teamId, String teamName, long points, long goalDifference, long yellowCards, long redCards, long ranking) {
        this.teamId = teamId;
        this.teamName = teamName;
        this.points = points;
        this.goalDifference = goalDifference;
        this.yellowCards = yellowCards;
        this.redCards = redCards;
        this.ranking = ranking;
    }

    public TeamStats(long teamId, String teamName, long goals, double percentage, String statType) {
        this.teamId = teamId;
        this.teamName = teamName;

        if ("offense".equals(statType)) {
            this.goalsScored = goals;
            this.attackPercentage = percentage;
        } else if ("defense".equals(statType)) {
            this.goalsConceded = goals;
            this.defensePercentage = percentage;
        }
    }

    public TeamStats(long teamId, String teamName, long matchesPlayed, long totalPoints, double avgPointsPerMatch) {
        this.teamId = teamId;
        this.teamName = teamName;
        this.matchesPlayed = matchesPlayed;
        this.totalPoints = totalPoints;
        this.avgPointsPerMatch = avgPointsPerMatch;
    }

    public TeamStats(long teamId, String teamName, long homeMatches, long homePoints, double avgHomePoints, long awayMatches, long awayPoints, double avgAwayPoints, double homeAdvantage) {
        this.teamId = teamId;
        this.teamName = teamName;
        this.homeMatches = homeMatches;
        this.homePoints = homePoints;
        this.avgHomePoints = avgHomePoints;
        this.awayMatches = awayMatches;
        this.awayPoints = awayPoints;
        this.avgAwayPoints = avgAwayPoints;
        this.homeAdvantage = homeAdvantage;
    }

    // Gettery i settery

    public long getPoints() {
        return points;
    }

    public void setPoints(long points) {
        this.points = points;
    }

    public long getTeamId() {
        return teamId;
    }

    public void setTeamId(long teamId) {
        this.teamId = teamId;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public long getGoalDifference() {
        return goalDifference;
    }

    public void setGoalDifference(long goalDifference) {
        this.goalDifference = goalDifference;
    }

    public long getYellowCards() {
        return yellowCards;
    }

    public void setYellowCards(long yellowCards) {
        this.yellowCards = yellowCards;
    }

    public long getRedCards() {
        return redCards;
    }

    public void setRedCards(long redCards) {
        this.redCards = redCards;
    }

    public long getRanking() {
        return ranking;
    }

    public void setRanking(long ranking) {
        this.ranking = ranking;
    }

    public long getGoalsScored() {
        return goalsScored;
    }

    public void setGoalsScored(long goalsScored) {
        this.goalsScored = goalsScored;
    }

    public double getAttackPercentage() {
        return attackPercentage;
    }

    public void setAttackPercentage(double attackPercentage) {
        this.attackPercentage = attackPercentage;
    }

    public long getGoalsConceded() {
        return goalsConceded;
    }

    public void setGoalsConceded(long goalsConceded) {
        this.goalsConceded = goalsConceded;
    }

    public double getDefensePercentage() {
        return defensePercentage;
    }

    public void setDefensePercentage(double defensePercentage) {
        this.defensePercentage = defensePercentage;
    }

    public long getMatchesPlayed() {
        return matchesPlayed;
    }

    public void setMatchesPlayed(long matchesPlayed) {
        this.matchesPlayed = matchesPlayed;
    }

    public long getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(long totalPoints) {
        this.totalPoints = totalPoints;
    }

    public double getAvgPointsPerMatch() {
        return avgPointsPerMatch;
    }

    public void setAvgPointsPerMatch(double avgPointsPerMatch) {
        this.avgPointsPerMatch = avgPointsPerMatch;
    }

    public long getHomeMatches() {
        return homeMatches;
    }

    public void setHomeMatches(long homeMatches) {
        this.homeMatches = homeMatches;
    }

    public long getHomePoints() {
        return homePoints;
    }

    public void setHomePoints(long homePoints) {
        this.homePoints = homePoints;
    }

    public double getAvgHomePoints() {
        return avgHomePoints;
    }

    public void setAvgHomePoints(double avgHomePoints) {
        this.avgHomePoints = avgHomePoints;
    }

    public long getAwayMatches() {
        return awayMatches;
    }

    public void setAwayMatches(long awayMatches) {
        this.awayMatches = awayMatches;
    }

    public long getAwayPoints() {
        return awayPoints;
    }

    public void setAwayPoints(long awayPoints) {
        this.awayPoints = awayPoints;
    }

    public double getAvgAwayPoints() {
        return avgAwayPoints;
    }

    public void setAvgAwayPoints(double avgAwayPoints) {
        this.avgAwayPoints = avgAwayPoints;
    }

    public double getHomeAdvantage() {
        return homeAdvantage;
    }

    public void setHomeAdvantage(double homeAdvantage) {
        this.homeAdvantage = homeAdvantage;
    }
}
