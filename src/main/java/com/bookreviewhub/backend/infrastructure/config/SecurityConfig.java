package com.bookreviewhub.backend.infrastructure.config;

import com.bookreviewhub.backend.infrastructure.security.handler.CustomAccessDeniedHandler;
import com.bookreviewhub.backend.infrastructure.security.handler.CustomAuthenticationEntryPoint;
import com.bookreviewhub.backend.infrastructure.security.filter.JwtAuthenticationFilter;
import com.bookreviewhub.backend.infrastructure.CustomUserDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig implements WebMvcConfigurer {
    private final CustomUserDetailsService customUserDetailsService;
    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final CustomAuthenticationEntryPoint customAuthenticationEntryPoint;
    private final CustomAccessDeniedHandler customAccessDeniedHandler;

    // Inject the frontend URL from the environment
    @Value("${app.cors.allowed-origin}")
    private String frontendUrl;

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // Allow CORS for frontend
        registry.addMapping("/**")
                .allowedOrigins(frontendUrl)  // Frontend URL
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .allowedHeaders("*")
                .allowCredentials(true);  // Allow credentials (cookies, etc)
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        httpSecurity
                // Disable CSRF for stateless APIs
                .csrf(AbstractHttpConfigurer::disable)
                // Set session management to stateless for JWT-based authentication
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // Permit public access to authentication APIs
                        .requestMatchers("/api/auth/**").permitAll()
                        // Secure all other endpoints
                        .anyRequest().authenticated()
                )
                // Handle authentication and access denial errors
                .exceptionHandling(exception -> exception
                        .authenticationEntryPoint(customAuthenticationEntryPoint)
                        .accessDeniedHandler(customAccessDeniedHandler)
                )
                // Add JWT filter before UsernamePasswordAuthenticationFilter
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                // Register the custom user details service for authentication
                .userDetailsService(customUserDetailsService);

        return httpSecurity.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
