package com.example.pestrecognition.model.dto;

public class ClassificationResult {
    private Long pestId;
    private String pestName;
    private double confidence;

    // Getters and Setters
    public Long getPestId() {
        return pestId;
    }

    public void setPestId(Long pestId) {
        this.pestId = pestId;
    }

    public String getPestName() {
        return pestName;
    }

    public void setPestName(String pestName) {
        this.pestName = pestName;
    }

    public double getConfidence() {
        return confidence;
    }

    public void setConfidence(double confidence) {
        this.confidence = confidence;
    }
}