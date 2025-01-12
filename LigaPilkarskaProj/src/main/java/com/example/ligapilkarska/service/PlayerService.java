package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.Player;
import com.example.ligapilkarska.PlayerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.jdbc.core.JdbcTemplate;


import java.util.List;

@Service
public class PlayerService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private PlayerRepository playerRepository;

    public List<Player> getAllPlayers() {
        return playerRepository.findAll();
    }

    public Player savePlayer(Player player) {
        return playerRepository.save(player);
    }

    public Player getPlayerById(int id) {
        return playerRepository.findById((long) id).orElse(null);
    }

    public void deletePlayer(int id) {
        playerRepository.deleteById((long) id);
    }

    public List<Player> getPlayersWithDetails() {
        String sql = "SELECT player_id, first_name, last_name, name, team_name FROM get_players_info()";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Player(
                rs.getInt("player_id"),
                rs.getString("first_name").trim(),
                rs.getString("last_name").trim(),
                rs.getString("name").trim(),
                rs.getString("team_name").trim()
        ));
    }

    // Nowa metoda do dodawania gracza (po nazwie pozycji i drużyny)
    public void addPlayerWithDetails(String firstName, String lastName, String positionName, String teamName) {
        String sql = "CALL add_player(?, ?, ?, ?)";
        jdbcTemplate.update(sql, firstName, lastName, positionName, teamName);
    }

    // Nowa metoda do edycji gracza (po nazwie pozycji i drużyny)
    public void editPlayerWithDetails(int playerId, String firstName, String lastName, String positionName, String teamName) {
        String sql = "CALL edit_player(?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, playerId, firstName, lastName, positionName, teamName);
    }

    // Nowa metoda do usuwania gracza
    public void deletePlayerById(int playerId) {
        String sql = "CALL delete_player(?)";
        jdbcTemplate.update(sql, playerId);
    }
}
