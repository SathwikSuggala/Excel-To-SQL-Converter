package com.sathwik.converters.ExcelToSqlConverter.service.impl;

import com.sathwik.converters.ExcelToSqlConverter.service.ExcelService;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public class ExcelServiceImpl implements ExcelService {

    private final DataFormatter dataFormatter = new DataFormatter(); // <-- Add this

    @Override
    public String getInsertQuery(String tableName, MultipartFile file) {
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

            return sql.toString();

        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Function to get values from 3rd column as comma-separated string
    public String getThirdColumnValues(MultipartFile file, int start, int end) {
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
            e.printStackTrace();
        }

        // Remove trailing comma if exists
        if (result.length() > 0 && result.charAt(result.length() - 1) == ',') {
            result.deleteCharAt(result.length() - 1);
        }

        return result.toString();
    }
}
