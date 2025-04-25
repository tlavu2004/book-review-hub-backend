package com.bookreviewhub.backend;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class BookreviewhubBackendApplication {
	private static void setIfPresent(String key, Dotenv dotenv) {
		String value = dotenv.get(key);
		if (value != null) {
			System.setProperty(key, value);
		}
	}

	public static void main(String[] args) {
		// Load .env
		Dotenv dotenv = Dotenv.configure()
				.directory("./") // Where .env file placed
				.ignoreIfMalformed()
				.ignoreIfMissing()
				.load();

//		System.setProperty("DB_HOST", dotenv.get("DB_HOST"));
//		System.setProperty("DB_PORT", dotenv.get("DB_PORT"));
//		System.setProperty("DB_NAME", dotenv.get("DB_NAME"));
//		System.setProperty("DB_USERNAME", dotenv.get("DB_USERNAME"));
//		System.setProperty("DB_PASSWORD", dotenv.get("DB_PASSWORD"));

		setIfPresent("DB_HOST", dotenv);
		setIfPresent("DB_PORT", dotenv);
		setIfPresent("DB_NAME", dotenv);
		setIfPresent("DB_USERNAME", dotenv);
		setIfPresent("DB_PASSWORD", dotenv);

		SpringApplication.run(BookreviewhubBackendApplication.class, args);
	}
}
