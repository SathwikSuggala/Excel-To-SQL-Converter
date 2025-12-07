package com.sathwik.converters.ExcelToSqlConverter.controller;

import com.sathwik.converters.ExcelToSqlConverter.service.ExcelService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class ExcelController {

    private static final Logger logger = LoggerFactory.getLogger(ExcelController.class);
    private final ExcelService excelService;

    public ExcelController(ExcelService excelService) {
        this.excelService = excelService;
    }

    @GetMapping("/")
    public String home() {
        logger.info("Home page accessed");
        return "home";
    }

    @GetMapping("/sql-generator")
    public String sqlGenerator() {
        return "sql-generator";
    }

    @GetMapping("/csv-extractor")
    public String csvExtractor() {
        return "csv-extractor";
    }

    @GetMapping("/json-viewer")
    public String jsonViewer() {
        return "json-viewer";
    }

    @GetMapping("/json-comparator")
    public String jsonComparator() {
        return "json-comparator";
    }

    @GetMapping("/xml-viewer")
    public String xmlViewer() {
        return "xml-viewer";
    }

    @GetMapping("/word-processor")
    public String wordProcessor() {
        return "word-processor";
    }

    @PostMapping("/getInsertQuery")
    @ResponseBody
    public String getInsertQuery(@RequestParam("file")MultipartFile file, @RequestParam("tableName") String tableName) {
        logger.info("SQL Insert query requested for table: {} with file: {}", tableName, file.getOriginalFilename());
        return excelService.getInsertQuery(tableName, file);
    }

    @PostMapping("/getCamaSeparatedValue")
    @ResponseBody
    public String getCamaSeparatedValue(@RequestParam("file")MultipartFile file, @RequestParam("start") int start, @RequestParam("end") int end) {
        logger.info("CSV extraction requested for file: {} from row {} to {}", file.getOriginalFilename(), start, end);
        return excelService.getThirdColumnValues(file, start, end);
    }

    @PostMapping("/processWordDocument")
    @ResponseBody
    public java.util.Map<Integer, String> processWordDocument(@RequestParam("file") MultipartFile file, @RequestParam("words") String words) {
        logger.info("Word document processing requested for file: {} with keywords: {}", file.getOriginalFilename(), words);
        return excelService.processWordDocument(file, words);
    }
}
