package com.bookreviewhub.backend.auth.service;

import com.bookreviewhub.backend.common.security.jwt.JwtService;
import com.bookreviewhub.backend.auth.dto.request.RegisterRequest;
import com.bookreviewhub.backend.auth.dto.request.LoginRequest;
import com.bookreviewhub.backend.common.dto.response.SuccessResponse;
import com.bookreviewhub.backend.auth.entity.User;
import com.bookreviewhub.backend.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;

    public SuccessResponse<Void> register(RegisterRequest registerRequest) {
        // Check if username or email already exists
        if (userRepository.findByUsername(registerRequest.getUsername()).isPresent()) {
            throw new IllegalArgumentException("Username is already taken");
        }
        if (userRepository.findByEmail(registerRequest.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email is already registered");
        }

        // Create new User entity
        User user = User.builder()
                .username(registerRequest.getUsername())
                .password(passwordEncoder.encode(registerRequest.getPassword()))
                .email(registerRequest.getEmail())
                .role(User.Role.USER)
                .firstName(registerRequest.getFirstName())
                .middleName(registerRequest.getMiddleName())
                .lastName(registerRequest.getLastName())
                .createdAt(LocalDateTime.now())
                .status(User.Status.ACTIVE)
                .build();

        userRepository.save(user);

        return SuccessResponse.<Void>builder()
                .timestamp(LocalDateTime.now())
                .status(201)
                .message("User registered successfully!")
                .data(null)
                .build();
    }

    private final JwtService jwtService;

    public SuccessResponse<Map<String, String>> login(LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getUsername(),
                        loginRequest.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtService.generateToken(loginRequest.getUsername());

        Map<String, String> responseData = new HashMap<>();
        responseData.put("token", jwt);

        return SuccessResponse.<Map<String, String>>builder()
                .timestamp(LocalDateTime.now())
                .status(200)
                .message("Login successful!")
                .data(responseData)
                .build();
    }
}
