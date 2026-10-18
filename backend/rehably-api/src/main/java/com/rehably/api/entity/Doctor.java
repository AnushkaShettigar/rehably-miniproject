package com.rehably.api.entity;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "doctors")
public class Doctor {

    @Id
    @Column(name = "doctor_id")
    private String doctorId;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String specialty;

    @Column(length = 1000)
    private String description;

    @Column(length = 1000)
    private String qualifications;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "doctor_tags", joinColumns = @JoinColumn(name = "doctor_id"))
    @Column(name = "tag")
    private List<String> tags = new ArrayList<>();

    public Doctor() {
    }

    public Doctor(String doctorId, String name, String specialty, String description, String qualifications, List<String> tags) {
        this.doctorId = doctorId;
        this.name = name;
        this.specialty = specialty;
        this.description = description;
        this.qualifications = qualifications;
        this.tags = tags;
    }

    public String getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(String doctorId) {
        this.doctorId = doctorId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getQualifications() {
        return qualifications;
    }

    public void setQualifications(String qualifications) {
        this.qualifications = qualifications;
    }

    public List<String> getTags() {
        return tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }
}
