package com.bookreviewhub.backend.application.auth.service;

import com.bookreviewhub.backend.infrastructure.user.entity.UserEntity;
import com.bookreviewhub.backend.infrastructure.security.jwt.JwtService;
import com.bookreviewhub.backend.application.auth.dto.request.RegisterRequest;
import com.bookreviewhub.backend.application.auth.dto.request.LoginRequest;
import com.bookreviewhub.backend.shared.dto.response.SuccessResponse;
import com.bookreviewhub.backend.infrastructure.user.repository.UserRepository;
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
        UserEntity userEntity = UserEntity.builder()
                .username(registerRequest.getUsername())
                .password(passwordEncoder.encode(registerRequest.getPassword()))
                .email(registerRequest.getEmail())
                .role(UserEntity.Role.USER)
                .firstName(registerRequest.getFirstName())
                .middleName(registerRequest.getMiddleName())
                .lastName(registerRequest.getLastName())
                .createdAt(LocalDateTime.now())
                .status(UserEntity.Status.ACTIVE)
                .build();

        userRepository.save(userEntity);

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
