package com.example.pestrecognition.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "recognition_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecognitionHistory {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "image_path", nullable = false)
    private String imagePath;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pest_id")
    private Pest pest;
    
    @Column(name = "confidence")
    private Double confidence;
    
    @CreationTimestamp
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;
}