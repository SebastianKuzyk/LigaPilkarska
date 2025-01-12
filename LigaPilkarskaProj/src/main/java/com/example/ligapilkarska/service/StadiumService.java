package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.Stadium;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StadiumService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Pobieranie wszystkich stadionów
    public List<Stadium> getAllStadiums() {
        String sql = "SELECT * FROM get_all_stadiums()";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Stadium(
                rs.getInt("stadium_id"),
                rs.getString("stadium_name")
        ));
    }

    // Dodawanie nowego stadionu
    public void addStadium(String stadiumName) {
        String sql = "CALL add_stadium(?)";
        jdbcTemplate.update(sql, stadiumName);
    }

    // Edytowanie stadionu
    public void editStadium(int stadiumId, String stadiumName) {
        String sql = "CALL edit_stadium(?, ?)";
        jdbcTemplate.update(sql, stadiumId, stadiumName);
    }

    // Usuwanie stadionu
    public void deleteStadium(int stadiumId) {
        String sql = "CALL delete_stadium(?)";
        jdbcTemplate.update(sql, stadiumId);
    }
}
