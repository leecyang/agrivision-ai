package com.example.pestrecognition.controller;

import com.example.pestrecognition.model.entity.Pest;
import com.example.pestrecognition.model.vo.ApiResponse;
import com.example.pestrecognition.model.vo.PestVO;
import com.example.pestrecognition.service.PestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pests")
public class PestController {

    @Autowired
    private PestService pestService;

    @GetMapping("/common")
    public ResponseEntity<ApiResponse<List<PestVO>>> getCommonPests() {
        // 返回常见害虫列表
        List<PestVO> commonPests = pestService.getCommonPests();
        return ResponseEntity.ok(ApiResponse.success(commonPests));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<PestVO>> getPestInfo(@PathVariable Long id) {
        // 返回害虫详细信息
        PestVO pest = pestService.getPestById(id);
        if (pest != null) {
            return ResponseEntity.ok(ApiResponse.success(pest));
        } else {
            return ResponseEntity.status(404).body(ApiResponse.error(404, "Pest not found"));
        }
    }
}