package com.rehably.api.dto;

public record ResourceResponse(
        Long id,
        String type,
        String category,
        String name,
        String bodyArea,
        String purpose,
        String equipmentRequired,
        String instructions,
        String difficulty,
        String safetyNotes
) {
}
