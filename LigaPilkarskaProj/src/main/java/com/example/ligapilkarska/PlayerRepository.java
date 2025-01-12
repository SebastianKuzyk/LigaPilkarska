package com.example.ligapilkarska;

import com.example.ligapilkarska.model.Player;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PlayerRepository extends JpaRepository<Player, Long> {
}
