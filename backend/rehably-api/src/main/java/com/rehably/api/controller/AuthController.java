package com.rehably.api.controller;

import com.rehably.api.dto.AuthResponse;
import com.rehably.api.dto.LoginRequest;
import com.rehably.api.entity.Doctor;
import com.rehably.api.entity.User;
import com.rehably.api.entity.UserRole;
import com.rehably.api.repository.DoctorRepository;
import com.rehably.api.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final DoctorRepository doctorRepository;

    public AuthController(AuthenticationManager authenticationManager,
                         UserRepository userRepository,
                         DoctorRepository doctorRepository) {
        this.authenticationManager = authenticationManager;
        this.userRepository = userRepository;
        this.doctorRepository = doctorRepository;
    }

    @PostMapping("/api/auth/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest loginRequest,
                                             HttpServletRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.username(), loginRequest.password())
        );

        SecurityContext context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(authentication);
        SecurityContextHolder.setContext(context);
        request.getSession(true).setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, context);

        User user = userRepository.findByUsername(loginRequest.username())
                .orElseThrow(() -> new IllegalArgumentException("User not found after successful authentication."));

        String dashboard = user.getRole() == UserRole.PATIENT ? "patient-home.html" : "doctor-dashboard.html";
        String displayName = user.getRole() == UserRole.DOCTOR
                ? doctorRepository.findById(user.getDoctorId()).map(Doctor::getName).orElse("Doctor")
                : "Patient";

        return ResponseEntity.ok(new AuthResponse(user.getUsername(), user.getRole().name(), dashboard, displayName));
    }

    @PostMapping("/api/auth/logout")
    public ResponseEntity<Map<String, String>> logout(HttpServletRequest request, HttpServletResponse response) {
        SecurityContextHolder.clearContext();
        request.getSession(false).invalidate();
        return ResponseEntity.ok(Map.of("message", "Logged out successfully"));
    }

    @GetMapping("/api/auth/me")
    public ResponseEntity<AuthResponse> currentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return ResponseEntity.status(401).build();
        }

        String username = auth.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + username));

        String dashboard = user.getRole() == UserRole.PATIENT ? "patient-home.html" : "doctor-dashboard.html";
        String displayName = user.getRole() == UserRole.DOCTOR
                ? doctorRepository.findById(user.getDoctorId()).map(Doctor::getName).orElse("Doctor")
                : "Patient";

        return ResponseEntity.ok(new AuthResponse(user.getUsername(), user.getRole().name(), dashboard, displayName));
    }

    @GetMapping("/api/health")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of("status", "UP"));
    }
}
