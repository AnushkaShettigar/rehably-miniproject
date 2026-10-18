package com.rehably.api.dto;

import java.time.LocalDate;
import java.time.LocalTime;

public record AppointmentRequestCreateRequest(
        String doctorId,
        String doctorName,
        String specialty,
        String consultationReason,
        LocalDate preferredDate,
        LocalTime preferredTime,
        String notes,
        String patientName
) {
}
