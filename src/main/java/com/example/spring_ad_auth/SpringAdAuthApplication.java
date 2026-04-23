package com.example.spring_ad_auth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class SpringAdAuthApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringAdAuthApplication.class, args);
	}

}
