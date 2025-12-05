package com.sathwik.converters.ExcelToSqlConverter.service.impl;

import com.sathwik.converters.ExcelToSqlConverter.service.ExcelService;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ExcelServiceImpl implements ExcelService {

    private static final Logger logger = LoggerFactory.getLogger(ExcelServiceImpl.class);
    private final DataFormatter dataFormatter = new DataFormatter();

    @Override
    public String getInsertQuery(String tableName, MultipartFile file) {
        logger.info("Starting SQL insert query generation for table: {}", tableName);
        try (XSSFWorkbook workbook = new XSSFWorkbook(file.getInputStream())) {

            Sheet sheet = workbook.getSheetAt(0);

            // 1. Read header row
            Row headerRow = sheet.getRow(0);
            if (headerRow == null) return null;

            List<String> headers = new ArrayList<>();
            for (Cell cell : headerRow) {
                headers.add(cell.getStringCellValue());
            }

            // 2. Read body rows
            List<String> valueRows = new ArrayList<>();
            FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();

            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                List<String> values = new ArrayList<>();
                for (int j = 0; j < headers.size(); j++) {
                    Cell cell = row.getCell(j);
                    String value = "NULL";

                    if (cell != null) {
                        // Use DataFormatter to preserve original display format
                        String formattedValue = dataFormatter.formatCellValue(cell, evaluator);

                        if ("NULL".equalsIgnoreCase(formattedValue.trim())) {
                            value = "NULL";
                        } else if (formattedValue.isEmpty()) {
                            value = "NULL";
                        } else {
                            value = "'" + formattedValue.replace("'", "''") + "'";
                        }
                    }

                    values.add(value);
                }

                valueRows.add("(" + String.join(", ", values) + ")");
            }

            if (valueRows.isEmpty()) return "";

            // 3. Build single INSERT statement
            StringBuilder sql = new StringBuilder();
            sql.append("INSERT INTO ").append(tableName)
                    .append(" (").append(String.join(", ", headers)).append(")\n")
                    .append("VALUES\n")
                    .append(String.join(",\n", valueRows))
                    .append(";");

            logger.info("Successfully generated SQL insert query with {} rows", valueRows.size());
            return sql.toString();

        } catch (IOException e) {
            logger.error("Error processing Excel file for SQL generation: {}", e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    // Function to get values from 3rd column as comma-separated string
    public String getThirdColumnValues(MultipartFile file, int start, int end) {
        logger.info("Extracting CSV values from rows {} to {}", start, end);
        StringBuilder result = new StringBuilder();

        try (XSSFWorkbook workbook = new XSSFWorkbook(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);

            int count = 0;
            // Start from row 1 (skip header row at 0 if needed)
            int lastIndex = Math.min(sheet.getLastRowNum(),end);
            for (int i = start; i <= lastIndex; i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                Cell cell = row.getCell(2); // 3rd column (index 2)
                if (cell != null) {
                    switch (cell.getCellType()) {
                        case STRING:
                            result.append(cell.getStringCellValue());
                            break;
                        case NUMERIC:
                            if (DateUtil.isCellDateFormatted(cell)) {
                                result.append(cell.getDateCellValue());
                            } else {
                                result.append(cell.getNumericCellValue());
                            }
                            break;
                        case BOOLEAN:
                            result.append(cell.getBooleanCellValue());
                            break;
                        default:
                            result.append(""); // blank cell
                    }
                    result.append("','"); // add separator
                    count++;
                    if(count == 5000){
                        //result.append("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
                        count = 0;
                    }
                }
            }
        }catch (IOException e) {
            logger.error("Error extracting CSV values: {}", e.getMessage());
            e.printStackTrace();
        }
        
        logger.info("Successfully extracted CSV values");

        // Remove trailing comma if exists
        if (result.length() > 0 && result.charAt(result.length() - 1) == ',') {
            result.deleteCharAt(result.length() - 1);
        }

        return result.toString();
    }

    @Override
    public Map<Integer, String> processWordDocument(MultipartFile file, String words) {
        logger.info("Processing Word document: {}", file.getOriginalFilename());
        try {
            String content = extractTextFromWord(file);
            List<String> wordList = Arrays.stream(words.split(","))
                    .map(String::trim)
                    .filter(word -> !word.isEmpty())
                    .collect(Collectors.toList());

            Map<Integer, String> results = searchLinesByKeyWords(content, wordList);
            logger.info("Found {} lines containing keywords", results.size());
            return results;
        } catch (Exception e) {
            logger.error("Error processing Word document: {}", e.getMessage());
            Map<Integer, String> errorMap = new LinkedHashMap<>();
            errorMap.put(-1, "Error processing Word document: " + e.getMessage());
            return errorMap;
        }
    }

    private String extractTextFromWord(MultipartFile file) throws IOException {
        String filename = file.getOriginalFilename();
        
        if (filename == null) {
            throw new IOException("File name is null");
        }
        
        if (filename.toLowerCase().endsWith(".docx")) {
            try (XWPFDocument document = new XWPFDocument(file.getInputStream());
                 XWPFWordExtractor extractor = new XWPFWordExtractor(document)) {
                return extractor.getText();
            }
        } else if (filename.toLowerCase().endsWith(".doc")) {
            try (HWPFDocument document = new HWPFDocument(file.getInputStream());
                 WordExtractor extractor = new WordExtractor(document)) {
                return extractor.getText();
            }
        } else {
            throw new IOException("Unsupported file format. Please upload .doc or .docx files only.");
        }
    }

    private Map<Integer, String> searchLinesByKeyWords(String content, List<String> words) {
        Map<Integer, String> result = new LinkedHashMap<>();
        String[] lines = content.split("\n");
        
        for (int i = 0; i < lines.length; i++) {
            String line = lines[i].trim();
            if (line.isEmpty()) continue;
            
            String lowerLine = line.toLowerCase();
            
            for (String word : words) {
                if (lowerLine.contains(word.toLowerCase())) {
                    result.put(i + 1, line);
                    break;
                }
            }
        }
        
        return result;
    }
}
