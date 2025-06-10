package com.example.pestrecognition.service.impl;

import com.example.pestrecognition.dao.PestRepository;
import com.example.pestrecognition.model.entity.Pest;
import com.example.pestrecognition.model.vo.PestVO;
import com.example.pestrecognition.service.PestService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PestServiceImpl implements PestService {

    @Autowired
    private PestRepository pestRepository;

    @Override
    public List<PestVO> getCommonPests() {
        // 假设从数据库或其他地方获取常见害虫列表
        List<Pest> commonPests = pestRepository.findAll(); // 示例：获取所有害虫
        return commonPests.stream()
                .map(this::convertToPestVO)
                .collect(Collectors.toList());
    }

    @Override
    public PestVO getPestById(Long id) {
        Pest pest = pestRepository.findById(id).orElse(null);
        return pest != null ? convertToPestVO(pest) : null;
    }

    private PestVO convertToPestVO(Pest pest) {
        PestVO pestVO = new PestVO();
        BeanUtils.copyProperties(pest, pestVO);
        pestVO.setFamily(pest.getFamily());
        pestVO.setDistribution(pest.getDistribution());
        pestVO.setHost(pest.getHost());
        pestVO.setMorphology(pest.getMorphology());
        pestVO.setHabits(pest.getHabits());
        return pestVO;
    }
}