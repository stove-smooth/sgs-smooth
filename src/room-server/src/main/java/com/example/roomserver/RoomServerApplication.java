package com.example.roomserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@EnableFeignClients
@SpringBootApplication
public class RoomServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(RoomServerApplication.class, args);
	}

}
