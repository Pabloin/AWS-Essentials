package io.glaciar.elbns.helloworld;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@EnableScheduling  // Enable scheduling for background tasks
public class HelloGlaciarApp {

    public static void main(String[] args) {
        SpringApplication.run(HelloGlaciarApp.class, args);
    }

    // CommandLineRunner for standalone functionality (CLI-like or background tasks)
    @Bean
    public CommandLineRunner run(ApplicationContext ctx) {
        return args -> {
            System.out.println("Standalone functionality running alongside REST API...");
        };
    }

    // Scheduled task to simulate a background operation
    @Scheduled(fixedRate = 5000)  // Runs every 5 seconds
    public void scheduledTask() {
        System.out.println("Background task running every 5 seconds.");
    }

    // REST Controller for handling HTTP requests
    @RestController
    public static class MyController {

        @GetMapping("/hello")
        public String sayHello() {
            return "Hello, this is a REST API response from hello-glaciar-app!";
        }
    }
}
