package com.example.pestrecognition.dao;

import com.example.pestrecognition.model.entity.RecognitionHistory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface HistoryRepository extends JpaRepository<RecognitionHistory, Long> {
    
    @Query("SELECT h FROM RecognitionHistory h JOIN FETCH h.pest ORDER BY h.createTime DESC")
    Page<RecognitionHistory> findAllWithPest(Pageable pageable);
}