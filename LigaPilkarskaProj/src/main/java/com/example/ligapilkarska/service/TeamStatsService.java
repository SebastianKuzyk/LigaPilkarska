package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.MatchResultStats;
import com.example.ligapilkarska.model.TeamStats;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class TeamStatsService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<TeamStats> getAllTeamsRanking() {
        String sql = "SELECT * FROM GetAllTeamsRanking()";
        return jdbcTemplate.query(sql, (rs, rowNum) ->
                new TeamStats(
                        rs.getLong("team_id"),
                        rs.getString("team_name"),
                        rs.getLong("points"),
                        rs.getLong("goal_difference"),
                        rs.getLong("yellow_cards"),
                        rs.getLong("red_cards"),
                        rs.getLong("ranking")
                ));
    }

    public List<TeamStats> getBestAttackingTeams() {
        String sql = "SELECT * FROM GetBestAttackingTeams()";
        return jdbcTemplate.query(sql, (rs, rowNum) ->
                new TeamStats(
                        rs.getLong("team_id"),
                        rs.getString("team_name"),
                        rs.getLong("goals_scored"),
                        rs.getDouble("attack_percentage"),
                        "offense"
                ));
    }

    public List<TeamStats> getBestDefensiveTeams() {
        String sql = "SELECT * FROM GetBestDefensiveTeams()";
        return jdbcTemplate.query(sql, (rs, rowNum) ->
                new TeamStats(
                        rs.getLong("team_id"),
                        rs.getString("team_name"),
                        rs.getLong("goals_conceded"),
                        rs.getDouble("defense_percentage"),
                        "defense"
                ));
    }

    public List<TeamStats> getAveragePointsPerMatch() {
        String sql = "SELECT * FROM GetAveragePointsPerMatch()";
        return jdbcTemplate.query(sql, (rs, rowNum) ->
                new TeamStats(
                        rs.getLong("team_id"),
                        rs.getString("team_name"),
                        rs.getLong("matches_played"),
                        rs.getLong("total_points"),
                        rs.getDouble("avg_points_per_match")
                ));
    }

    public List<TeamStats> getHomeAwayPerformance() {
        String sql = "SELECT * FROM GetHomeAwayPerformance()";
        return jdbcTemplate.query(sql, (rs, rowNum) ->
                new TeamStats(
                        rs.getLong("team_id"),
                        rs.getString("team_name"),
                        rs.getLong("home_matches"),
                        rs.getLong("home_points"),
                        rs.getDouble("avg_home_points"),
                        rs.getLong("away_matches"),
                        rs.getLong("away_points"),
                        rs.getDouble("avg_away_points"),
                        rs.getDouble("home_advantage")
                ));
    }

    // 📌 Obsługa najczęstszych wyników meczów
    public List<MatchResultStats> getMostCommonMatchResults() {
        String sql = "SELECT * FROM GetMostCommonMatchResults()";
        return jdbcTemplate.query(sql, (rs, rowNum) ->
                new MatchResultStats(
                        rs.getString("match_result"),
                        rs.getLong("match_count"),
                        rs.getDouble("percentage")
                ));
    }

}
