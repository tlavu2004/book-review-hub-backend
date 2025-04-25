package com.bookreviewhub.backend.config;

import com.bookreviewhub.backend.model.Book;
import com.bookreviewhub.backend.repository.BookRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataLoader {

    @Bean
    CommandLineRunner loadData(BookRepository bookRepository) {
        return args -> {
            bookRepository.save(new Book(null, "Clean Code", "Robert C. Martin"));
            bookRepository.save(new Book(null, "Effective Java", "Joshua Bloch"));
        };
    }
}
