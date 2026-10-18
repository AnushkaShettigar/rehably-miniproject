package com.rehably.api.controller;

import com.rehably.api.entity.AppointmentRequest;
import com.rehably.api.entity.Doctor;
import com.rehably.api.entity.User;
import com.rehably.api.entity.UserRole;
import com.rehably.api.repository.AppointmentRequestRepository;
import com.rehably.api.repository.DoctorRepository;
import com.rehably.api.repository.UserRepository;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class DoctorController {

    private final DoctorRepository doctorRepository;
    private final UserRepository userRepository;
    private final AppointmentRequestRepository appointmentRequestRepository;

    public DoctorController(DoctorRepository doctorRepository,
                           UserRepository userRepository,
                           AppointmentRequestRepository appointmentRequestRepository) {
        this.doctorRepository = doctorRepository;
        this.userRepository = userRepository;
        this.appointmentRequestRepository = appointmentRequestRepository;
    }

    @GetMapping("/api/doctors")
    public ResponseEntity<List<Doctor>> getDoctors() {
        return ResponseEntity.ok(doctorRepository.findAll(Sort.by("doctorId")));
    }

    @GetMapping("/api/doctor/appointments")
    public ResponseEntity<List<AppointmentRequestResponse>> getDoctorAppointments() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).build();
        }

        String username = authentication.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + username));

        if (user.getRole() != UserRole.DOCTOR || user.getDoctorId() == null) {
            return ResponseEntity.status(403).build();
        }

        Doctor doctor = doctorRepository.findById(user.getDoctorId())
                .orElseThrow(() -> new IllegalArgumentException("Doctor not found: " + user.getDoctorId()));

        List<AppointmentRequestResponse> responses = appointmentRequestRepository.findByDoctorOrderBySubmittedAtDesc(doctor)
                .stream()
                .map(request -> new AppointmentRequestResponse(
                        request.getRequestId(),
                        request.getPatientName(),
                        request.getConsultationReason(),
                        request.getPreferredDate(),
                        request.getPreferredTime(),
                        request.getNotes(),
                        request.getSubmittedAt(),
                        request.getStatus().name(),
                        request.getDoctorName()))
                .toList();

        return ResponseEntity.ok(responses);
    }

    public record AppointmentRequestResponse(
            Long requestId,
            String patientName,
            String consultationReason,
            java.time.LocalDate preferredDate,
            java.time.LocalTime preferredTime,
            String notes,
            java.time.LocalDateTime submittedAt,
            String status,
            String doctorName
    ) {
    }
}
