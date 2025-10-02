package com.sathwik.converters.ExcelToSqlConverter.controller;

import com.sathwik.converters.ExcelToSqlConverter.service.ExcelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class ExcelController {

    private final ExcelService excelService;

    public ExcelController(ExcelService excelService) {
        this.excelService = excelService;
    }

    @GetMapping("/")
    public String home() {
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

    @GetMapping("/xml-viewer")
    public String xmlViewer() {
        return "xml-viewer";
    }

    @PostMapping("/getInsertQuery")
    @ResponseBody
    public String getInsertQuery(@RequestParam("file")MultipartFile file, @RequestParam("tableName") String tableName) {

        return excelService.getInsertQuery(tableName, file);
    }

    @PostMapping("/getCamaSeparatedValue")
    @ResponseBody
    public String getCamaSeparatedValue(@RequestParam("file")MultipartFile file, @RequestParam("start") int start, @RequestParam("end") int end) {

        return excelService.getThirdColumnValues(file, start, end);
    }
}
