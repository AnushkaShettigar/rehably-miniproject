package com.rehably.api.controller;

import com.rehably.api.dto.AppointmentRequestCreateRequest;
import com.rehably.api.dto.AppointmentStatusUpdateRequest;
import com.rehably.api.entity.AppointmentRequest;
import com.rehably.api.entity.AppointmentStatus;
import com.rehably.api.entity.Doctor;
import com.rehably.api.entity.User;
import com.rehably.api.entity.UserRole;
import com.rehably.api.repository.AppointmentRequestRepository;
import com.rehably.api.repository.DoctorRepository;
import com.rehably.api.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
public class AppointmentController {

    private final UserRepository userRepository;
    private final DoctorRepository doctorRepository;
    private final AppointmentRequestRepository appointmentRequestRepository;

    public AppointmentController(UserRepository userRepository,
                                DoctorRepository doctorRepository,
                                AppointmentRequestRepository appointmentRequestRepository) {
        this.userRepository = userRepository;
        this.doctorRepository = doctorRepository;
        this.appointmentRequestRepository = appointmentRequestRepository;
    }

    @PostMapping("/api/appointment-requests")
    public ResponseEntity<?> createAppointment(@RequestBody AppointmentRequestCreateRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).body(Map.of("message", "Authentication required"));
        }

        User patient = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new IllegalArgumentException("Patient account not found."));

        if (patient.getRole() != UserRole.PATIENT) {
            return ResponseEntity.status(403).body(Map.of("message", "Patient account required to book an appointment."));
        }

        Doctor doctor = doctorRepository.findById(request.doctorId())
                .orElseThrow(() -> new IllegalArgumentException("Doctor not found: " + request.doctorId()));

        AppointmentRequest appointmentRequest = new AppointmentRequest();
        appointmentRequest.setPatient(patient);
        appointmentRequest.setDoctor(doctor);
        appointmentRequest.setPatientName(request.patientName() == null || request.patientName().isBlank() ? patient.getUsername() : request.patientName());
        appointmentRequest.setDoctorName(request.doctorName() == null || request.doctorName().isBlank() ? doctor.getName() : request.doctorName());
        appointmentRequest.setSpecialty(request.specialty() == null || request.specialty().isBlank() ? doctor.getSpecialty() : request.specialty());
        appointmentRequest.setConsultationReason(request.consultationReason());
        appointmentRequest.setPreferredDate(request.preferredDate());
        appointmentRequest.setPreferredTime(request.preferredTime());
        appointmentRequest.setNotes(request.notes());
        appointmentRequest.setSubmittedAt(LocalDateTime.now());
        appointmentRequest.setStatus(AppointmentStatus.PENDING);

        AppointmentRequest saved = appointmentRequestRepository.save(appointmentRequest);
        return ResponseEntity.ok(Map.of("message", "Appointment request submitted successfully", "requestId", saved.getRequestId()));
    }

    @GetMapping("/api/appointment-requests/my")
    public ResponseEntity<List<AppointmentRequestResponse>> getMyAppointments() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(401).build();
        }

        User patient = userRepository.findByUsername(authentication.getName())
                .orElseThrow(() -> new IllegalArgumentException("Patient not found."));

        List<AppointmentRequestResponse> responses = appointmentRequestRepository.findByPatientOrderBySubmittedAtDesc(patient)
                .stream()
                .map(item -> new AppointmentRequestResponse(
                        item.getRequestId(),
                        item.getDoctorName(),
                        item.getSpecialty(),
                        item.getConsultationReason(),
                        item.getPreferredDate(),
                        item.getPreferredTime(),
                        item.getNotes(),
                        item.getSubmittedAt(),
                        item.getStatus().name()))
                .toList();

        return ResponseEntity.ok(responses);
    }

    @PatchMapping("/api/appointment-requests/{id}/status")
    @PreAuthorize("hasRole('DOCTOR')")
    public ResponseEntity<?> updateStatus(@PathVariable Long id,
                                         @RequestBody AppointmentStatusUpdateRequest request) {
        AppointmentRequest appointmentRequest = appointmentRequestRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Appointment request not found: " + id));

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Doctor account not found."));

        if (user.getRole() != UserRole.DOCTOR || user.getDoctorId() == null) {
            return ResponseEntity.status(403).body(Map.of("message", "Doctor access required."));
        }

        if (!appointmentRequest.getDoctor().getDoctorId().equals(user.getDoctorId())) {
            return ResponseEntity.status(403).body(Map.of("message", "This request is not assigned to your doctor ID."));
        }

        appointmentRequest.setStatus(request.status());
        appointmentRequestRepository.save(appointmentRequest);
        return ResponseEntity.ok(Map.of("message", "Status updated", "requestId", appointmentRequest.getRequestId(), "status", appointmentRequest.getStatus().name()));
    }

    public record AppointmentRequestResponse(
            Long requestId,
            String doctorName,
            String specialty,
            String consultationReason,
            java.time.LocalDate preferredDate,
            java.time.LocalTime preferredTime,
            String notes,
            java.time.LocalDateTime submittedAt,
            String status
    ) {
    }
}
