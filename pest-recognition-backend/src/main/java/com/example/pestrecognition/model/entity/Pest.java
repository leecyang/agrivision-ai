package com.example.pestrecognition.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "pest_info")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Pest {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "name_zh", nullable = false, length = 100)
    private String nameZh;
    
    @Column(name = "name_en", nullable = false, length = 100)
    private String nameEn;
    
    @Column(name = "category", length = 50)
    private String category;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "harm_level")
    private Integer harmLevel;
    
    @Column(name = "symptoms", columnDefinition = "TEXT")
    private String symptoms;
    
    @Column(name = "prevention_methods", columnDefinition = "TEXT")
    private String preventionMethods;
    
    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "family", length = 100)
    private String family;

    @Column(name = "distribution", columnDefinition = "TEXT")
    private String distribution;

    @Column(name = "host", columnDefinition = "TEXT")
    private String host;

    @Column(name = "morphology", columnDefinition = "TEXT")
    private String morphology;

    @Column(name = "habits", columnDefinition = "TEXT")
    private String habits;
    
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
    
    @UpdateTimestamp
    @Column(name = "update_time")
    private LocalDateTime updateTime;
}