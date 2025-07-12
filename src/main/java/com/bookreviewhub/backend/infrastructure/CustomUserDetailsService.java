package com.bookreviewhub.backend.infrastructure;

import com.bookreviewhub.backend.infrastructure.user.entity.UserEntity;
import com.bookreviewhub.backend.infrastructure.user.repository.UserRepository;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

import java.util.Collections;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {
    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException{
        UserEntity userEntity = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));

        return org.springframework.security.core.userdetails.User
                .withUsername(userEntity.getUsername())
                .password(userEntity.getPassword())
                .authorities(Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + userEntity.getRole().name())))
                .build();
    }
}
