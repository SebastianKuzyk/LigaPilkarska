package com.example.ligapilkarska.controller;

import com.example.ligapilkarska.model.Coach;
import com.example.ligapilkarska.service.CoachService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class CoachController {

    @Autowired
    private CoachService coachService;

    @GetMapping("/api/coaches")
    public List<Coach> getAllCoaches() {
        return coachService.getAllCoaches();
    }

    @PostMapping("/api/coaches")
    public void addCoach(@RequestBody Coach coach) {
        coachService.addCoach(coach.getFirstName(), coach.getLastName(), coach.getTeamName());
    }

    @DeleteMapping("/api/coaches/{id}")
    public void deleteCoach(@PathVariable int id) {
        coachService.deleteCoach(id);
    }

    @PutMapping("/api/coaches/{id}")
    public void editCoach(@PathVariable int id, @RequestBody Coach coach) {
        coachService.editCoach(id, coach.getFirstName(), coach.getLastName(), coach.getTeamName());
    }
}
