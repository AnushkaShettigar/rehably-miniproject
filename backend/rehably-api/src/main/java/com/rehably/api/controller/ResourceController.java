package com.rehably.api.controller;

import com.rehably.api.dto.ResourceResponse;
import com.rehably.api.entity.Resource;
import com.rehably.api.repository.ResourceRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class ResourceController {

    private final ResourceRepository resourceRepository;

    public ResourceController(ResourceRepository resourceRepository) {
        this.resourceRepository = resourceRepository;
    }

    @GetMapping("/api/resources")
    public ResponseEntity<List<ResourceResponse>> getResources(@RequestParam(required = false) String category,
                                                             @RequestParam(required = false) String type) {
        List<Resource> resources = resourceRepository.findAllByOrderByCategoryAscNameAsc();
        if (category != null && !category.isBlank()) {
            resources = resources.stream()
                    .filter(item -> item.getCategory().equalsIgnoreCase(category))
                    .toList();
        }
        if (type != null && !type.isBlank()) {
            resources = resources.stream()
                    .filter(item -> item.getResourceType().name().equalsIgnoreCase(type))
                    .toList();
        }

        List<ResourceResponse> response = resources.stream()
                .map(item -> new ResourceResponse(
                        item.getId(),
                        item.getResourceType().name(),
                        item.getCategory(),
                        item.getName(),
                        item.getBodyArea(),
                        item.getPurpose(),
                        item.getEquipmentRequired(),
                        item.getInstructions(),
                        item.getDifficulty(),
                        item.getSafetyNotes()))
                .toList();

        return ResponseEntity.ok(response);
    }
}
