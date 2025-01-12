package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.Stadium;
import com.example.ligapilkarska.service.StadiumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stadiums")
public class StadiumController {

    @Autowired
    private StadiumService stadiumService;

    // Endpoint do pobierania wszystkich stadionów
    @GetMapping
    public List<Stadium> getAllStadiums() {
        return stadiumService.getAllStadiums();
    }

    // Endpoint do dodawania nowego stadionu
    @PostMapping
    public void addStadium(@RequestBody Stadium stadium) {
        stadiumService.addStadium(stadium.getStadiumName());
    }

    // Endpoint do edytowania stadionu
    @PutMapping("/{stadiumId}")
    public void editStadium(@PathVariable int stadiumId, @RequestBody Stadium stadium) {
        stadiumService.editStadium(stadiumId, stadium.getStadiumName());
    }

    // Endpoint do usuwania stadionu
    @DeleteMapping("/{stadiumId}")
    public void deleteStadium(@PathVariable int stadiumId) {
        stadiumService.deleteStadium(stadiumId);
    }
}
