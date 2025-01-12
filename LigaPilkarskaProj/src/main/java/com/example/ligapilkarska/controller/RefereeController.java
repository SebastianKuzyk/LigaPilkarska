package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.Referee;
import com.example.ligapilkarska.service.RefereeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/referees")
public class RefereeController {

    @Autowired
    private RefereeService refereeService;

    // Endpoint do pobierania wszystkich sędziów
    @GetMapping
    public List<Referee> getAllReferees() {
        return refereeService.getAllReferees();
    }

    // Endpoint do dodawania nowego sędziego
    @PostMapping
    public void addReferee(@RequestBody Referee referee) {
        refereeService.addReferee(referee.getFirstName(), referee.getLastName());
    }

    // Endpoint do edytowania sędziego
    @PutMapping("/{refereeId}")
    public void editReferee(@PathVariable int refereeId, @RequestBody Referee referee) {
        refereeService.editReferee(refereeId, referee.getFirstName(), referee.getLastName());
    }

    // Endpoint do usuwania sędziego
    @DeleteMapping("/{refereeId}")
    public void deleteReferee(@PathVariable int refereeId) {
        refereeService.deleteReferee(refereeId);
    }
}
