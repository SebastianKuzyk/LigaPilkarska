package com.example.ligapilkarska.service;

import com.example.ligapilkarska.model.Referee;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RefereeService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Pobieranie wszystkich sędziów
    public List<Referee> getAllReferees() {
        String sql = "SELECT * FROM get_all_referees()";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Referee(
                rs.getInt("referee_id"),
                rs.getString("first_name"),
                rs.getString("last_name")
        ));
    }

    // Dodawanie nowego sędziego
    public void addReferee(String firstName, String lastName) {
        String sql = "CALL add_referee(?, ?)";
        jdbcTemplate.update(sql, firstName, lastName);
    }

    // Edytowanie sędziego
    public void editReferee(int refereeId, String firstName, String lastName) {
        String sql = "CALL edit_referee(?, ?, ?)";
        jdbcTemplate.update(sql, refereeId, firstName, lastName);
    }

    // Usuwanie sędziego
    public void deleteReferee(int refereeId) {
        String sql = "CALL delete_referee(?)";
        jdbcTemplate.update(sql, refereeId);
    }
}
