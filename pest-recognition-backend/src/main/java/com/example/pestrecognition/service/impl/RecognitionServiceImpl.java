package com.example.pestrecognition.service.impl;

import com.example.pestrecognition.dao.HistoryRepository;
import com.example.pestrecognition.dao.PestRepository;
import com.example.pestrecognition.model.entity.RecognitionHistory;
import com.example.pestrecognition.model.vo.RecognitionResponse;
import com.example.pestrecognition.service.RecognitionService;
import com.example.pestrecognition.util.ImageUtil; // 假设存在ImageUtil工具类
import com.example.pestrecognition.ml.ModelService; // 假设存在ModelService
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Qualifier;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class RecognitionServiceImpl implements RecognitionService {

    @Autowired
    private PestRepository pestRepository;

    @Autowired
    private HistoryRepository historyRepository;

    @Autowired
    @Qualifier("djlModelService")
    private ModelService modelService; // 注入模型服务

    private final String UPLOAD_DIR = "./uploads/"; // 图片上传目录

    @Override
    public RecognitionResponse recognizePest(MultipartFile file) {
        // 1. 保存图片
        String filePath = saveImage(file);

        // 2. 图像预处理 (示例，实际需要根据模型要求实现)
        // byte[] processedImage = ImageUtil.preprocess(filePath);

        // 3. 调用模型服务进行识别
        // 假设modelService.predict返回一个包含害虫ID和置信度的结果
        // ModelService.RecognitionResult result = modelService.predict(processedImage);
        // 为了演示，这里使用模拟结果
        Long recognizedPestId = 1L; // 模拟识别出的害虫ID
        double confidence = 0.95; // 模拟置信度

        // 4. 根据识别结果查询害虫信息
        return pestRepository.findById(recognizedPestId).map(pest -> {
            // 5. 保存识别历史
            RecognitionHistory history = new RecognitionHistory();
            history.setImagePath(filePath);
            history.setPest(pest);
            history.setConfidence(confidence);
            historyRepository.save(history);

            // 6. 构建响应对象
            RecognitionResponse response = new RecognitionResponse();
            response.setPestId(pest.getId());
            response.setPestName(pest.getNameZh());
            response.setPestNameEn(pest.getNameEn());
            response.setConfidence(confidence);
            response.setDescription(pest.getDescription());
            response.setImageUrl(filePath); // 或者使用pest.getImageUrl()
            response.setHarmLevel(String.valueOf(pest.getHarmLevel()));
            response.setPreventionMethods(pest.getPreventionMethods());
            return response;
        }).orElse(null); // 如果未找到害虫，返回null或抛出异常
    }

    private String saveImage(MultipartFile file) {
        try {
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath);
            return filePath.toString();
        } catch (IOException e) {
            throw new RuntimeException("Failed to save image", e);
        }
    }
}