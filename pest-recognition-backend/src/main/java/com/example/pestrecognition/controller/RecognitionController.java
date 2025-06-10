package com.example.pestrecognition.controller;

import com.example.pestrecognition.ml.DjlModelService;
import com.example.pestrecognition.model.dto.ClassificationResult;
import com.example.pestrecognition.model.dto.RecognitionResponse;
import com.example.pestrecognition.model.entity.Pest;
import com.example.pestrecognition.model.entity.RecognitionHistory;
import com.example.pestrecognition.model.vo.HistoryVO;
import com.example.pestrecognition.model.vo.PestVO;
import com.example.pestrecognition.dao.PestRepository;
import com.example.pestrecognition.dao.HistoryRepository;
import com.example.pestrecognition.util.FileUtil;
import com.example.pestrecognition.util.Result;
import com.example.pestrecognition.util.ResultUtil;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/recognition")
public class RecognitionController {

    @Autowired
    private DjlModelService modelService;

    @Autowired
    private PestRepository pestRepository;

    @Autowired
    private HistoryRepository historyRepository;

    @Autowired
    private ModelMapper modelMapper;

    @Value("${app.upload.path}")
    private String uploadPath;

    @PostMapping("/upload")
    public Result<RecognitionResponse> recognizePest(@RequestParam("image") MultipartFile file) {
        if (file.isEmpty()) {
            return ResultUtil.error("File is empty");
        }

        try {
            // Save the uploaded file
            String originalFilename = file.getOriginalFilename();
            String fileExtension = FileUtil.getFileExtension(originalFilename);
            String savedFileName = System.currentTimeMillis() + "." + fileExtension;
            String fullSavePath = uploadPath + File.separator + savedFileName;
            FileUtil.saveFile(file.getBytes(), fullSavePath);
            String imageUrl = "/images/" + savedFileName; // Assuming /images is mapped to uploadPath

            // Read the image for model prediction
            File imageFile = new File(uploadPath + File.separator + savedFileName);
            BufferedImage image = ImageIO.read(imageFile);

            if (image == null) {
                 // Clean up the saved file if it's not a valid image
                FileUtil.deleteFile(uploadPath + File.separator + savedFileName);
                return ResultUtil.error("Invalid image file");
            }

            // Perform prediction using the model service
            List<ClassificationResult> results = modelService.predict(image);

            if (results == null || results.isEmpty()) {
                 // Clean up the saved file if prediction fails or returns no results
                FileUtil.deleteFile(uploadPath + File.separator + savedFileName);
                return ResultUtil.error("Prediction failed or returned no results");
            }

            // Assuming the first result is the most confident one
            ClassificationResult topResult = results.get(0);

            // Find the pest information from the database
            Optional<Pest> pestOptional = pestRepository.findById(topResult.getPestId());

            if (!pestOptional.isPresent()) {
                 // Clean up the saved file if pest not found
                FileUtil.deleteFile(uploadPath + File.separator + savedFileName);
                return ResultUtil.error("Pest with ID " + topResult.getPestId() + " not found");
            }

            Pest recognizedPest = pestOptional.get();

            // Save recognition history
            RecognitionHistory history = new RecognitionHistory();
            history.setImagePath(savedFileName);
            history.setPest(recognizedPest);
            history.setConfidence(topResult.getConfidence());
            history.setCreateTime(LocalDateTime.now());
            historyRepository.save(history);

            // Prepare the response DTO
            RecognitionResponse response = new RecognitionResponse();
            response.setPestId(recognizedPest.getId());
            response.setPestName(recognizedPest.getNameZh());
            response.setPestNameEn(recognizedPest.getNameEn());
            response.setConfidence(topResult.getConfidence());
            response.setDescription(recognizedPest.getDescription());
            response.setImageUrl(imageUrl);
            response.setHarmLevel(recognizedPest.getHarmLevel());
            response.setPreventionMethods(recognizedPest.getPreventionMethods());

            return ResultUtil.success(response);

        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("Error during recognition: " + e.getMessage());
        }
    }

    @GetMapping("/history")
    public Result<Map<String, Object>> getRecognitionHistory(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Pageable pageable = PageRequest.of(page - 1, size, Sort.by("createTime").descending());
            Page<RecognitionHistory> historyPage = historyRepository.findAll(pageable);

            List<HistoryVO> historyVOList = historyPage.getContent().stream()
                    .map(history -> {
                        HistoryVO vo = new HistoryVO();
                        vo.setId(history.getId());
                        vo.setPestId(history.getPest().getId());
                        vo.setPestName(history.getPest().getNameZh());
                        vo.setConfidence(history.getConfidence());
                        vo.setImageUrl("/images/" + history.getImagePath());
                        vo.setCreateTime(history.getCreateTime());
                        return vo;
                    })
                    .collect(Collectors.toList());

            Map<String, Object> response = new HashMap<>();
            response.put("records", historyVOList);
            response.put("total", historyPage.getTotalElements());
            return ResultUtil.success(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("Error retrieving history: " + e.getMessage());
        }
    }

    @GetMapping("/pests")
    public Result<List<PestVO>> getAllPests() {
        try {
            List<Pest> pests = pestRepository.findAll();
            List<PestVO> pestVOs = pests.stream()
                    .map(pest -> modelMapper.map(pest, PestVO.class))
                    .collect(Collectors.toList());
            return ResultUtil.success(pestVOs);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("Error retrieving pests: " + e.getMessage());
        }
    }

    @GetMapping("/pests/common")
    public Result<List<PestVO>> getCommonPests() {
        try {
            List<Pest> pests = pestRepository.findAll(); // Assuming all pests are considered 'common' for now
            List<PestVO> pestVOs = pests.stream()
                    .map(pest -> modelMapper.map(pest, PestVO.class))
                    .collect(Collectors.toList());
            return ResultUtil.success(pestVOs);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("Error retrieving common pests: " + e.getMessage());
        }
    }

    @GetMapping("/pests/{id}")
    public Result<PestVO> getPestById(@PathVariable Long id) {
        try {
            Optional<Pest> pestOptional = pestRepository.findById(id);
            if (pestOptional.isPresent()) {
                PestVO pestVO = modelMapper.map(pestOptional.get(), PestVO.class);
                return ResultUtil.success(pestVO);
            } else {
                return ResultUtil.error("Pest with ID " + id + " not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("Error retrieving pest: " + e.getMessage());
        }
    }
}