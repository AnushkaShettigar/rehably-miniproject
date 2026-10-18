package com.rehably.api.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "resources")
public class Resource {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ResourceType resourceType;

    @Column(nullable = false)
    private String category;

    @Column(nullable = false)
    private String name;

    @Column(name = "body_area")
    private String bodyArea;

    @Column(length = 2000)
    private String purpose;

    @Column(name = "equipment_required", length = 1000)
    private String equipmentRequired;

    @Column(length = 2000)
    private String instructions;

    @Column(length = 1000)
    private String difficulty;

    @Column(name = "safety_notes", length = 2000)
    private String safetyNotes;

    public Resource() {
    }

    public Resource(ResourceType resourceType, String category, String name, String bodyArea, String purpose,
                    String equipmentRequired, String instructions, String difficulty, String safetyNotes) {
        this.resourceType = resourceType;
        this.category = category;
        this.name = name;
        this.bodyArea = bodyArea;
        this.purpose = purpose;
        this.equipmentRequired = equipmentRequired;
        this.instructions = instructions;
        this.difficulty = difficulty;
        this.safetyNotes = safetyNotes;
    }

    public Long getId() {
        return id;
    }

    public ResourceType getResourceType() {
        return resourceType;
    }

    public void setResourceType(ResourceType resourceType) {
        this.resourceType = resourceType;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBodyArea() {
        return bodyArea;
    }

    public void setBodyArea(String bodyArea) {
        this.bodyArea = bodyArea;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getEquipmentRequired() {
        return equipmentRequired;
    }

    public void setEquipmentRequired(String equipmentRequired) {
        this.equipmentRequired = equipmentRequired;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public String getSafetyNotes() {
        return safetyNotes;
    }

    public void setSafetyNotes(String safetyNotes) {
        this.safetyNotes = safetyNotes;
    }
}
