package com.example.signalingserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.net.InetAddress;
import java.net.UnknownHostException;

@SpringBootApplication
public class SignalingServerApplication {

	public static String IP;

	public static void main(String[] args) {
		SpringApplication.run(SignalingServerApplication.class, args);

		try {
			IP = InetAddress.getLocalHost().getHostAddress();
		} catch (UnknownHostException e) {
			e.printStackTrace();
			IP = "unknown";
		}
	}

}
