package com.example.ligapilkarska;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LigaPilkarskaApplication {

    public static void main(String[] args) {
        SpringApplication.run(LigaPilkarskaApplication.class, args);
        System.out.println("Application has started successfully and connected to the database!");
    }
}
