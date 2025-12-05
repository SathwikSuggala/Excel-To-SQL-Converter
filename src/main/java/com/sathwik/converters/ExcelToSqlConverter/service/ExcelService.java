package com.sathwik.converters.ExcelToSqlConverter.service;

import org.springframework.web.multipart.MultipartFile;

public interface ExcelService {

    String getInsertQuery(String tableName, MultipartFile file);

    String getThirdColumnValues(MultipartFile file, int start, int end);

    java.util.Map<Integer, String> processWordDocument(MultipartFile file, String words);
}
