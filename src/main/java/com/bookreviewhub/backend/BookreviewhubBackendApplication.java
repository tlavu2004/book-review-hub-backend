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

		setIfPresent("DB_HOST", dotenv);
		setIfPresent("DB_PORT", dotenv);
		setIfPresent("DB_NAME", dotenv);
		setIfPresent("DB_USERNAME", dotenv);
		setIfPresent("DB_PASSWORD", dotenv);
		setIfPresent("APP_JWT_SECRET", dotenv);
		setIfPresent("APP_JWT_EXPIRATION", dotenv);
		setIfPresent("ALLOWED_ORIGIN", dotenv);

		SpringApplication.run(BookreviewhubBackendApplication.class, args);
	}
}
