package com.example.pestrecognition.dao;

import com.example.pestrecognition.model.entity.Pest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PestRepository extends JpaRepository<Pest, Long> {
    
    Optional<Pest> findByNameZh(String nameZh);
    
    Optional<Pest> findByNameEn(String nameEn);
    
    Optional<Pest> findByNameZhOrNameEn(String nameZh, String nameEn);
}