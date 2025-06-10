package com.example.pestrecognition.service;

import com.example.pestrecognition.model.vo.PestVO;

import java.util.List;

public interface PestService {
    List<PestVO> getCommonPests();
    PestVO getPestById(Long id);
}