package com.rehably.api.repository;

import com.rehably.api.entity.AppointmentRequest;
import com.rehably.api.entity.Doctor;
import com.rehably.api.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AppointmentRequestRepository extends JpaRepository<AppointmentRequest, Long> {
    List<AppointmentRequest> findByPatientOrderBySubmittedAtDesc(User patient);

    List<AppointmentRequest> findByDoctorOrderBySubmittedAtDesc(Doctor doctor);
}
