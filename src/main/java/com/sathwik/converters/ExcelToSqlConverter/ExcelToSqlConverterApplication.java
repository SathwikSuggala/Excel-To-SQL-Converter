package com.sathwik.converters.ExcelToSqlConverter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class ExcelToSqlConverterApplication {

	private static final Logger logger = LoggerFactory.getLogger(ExcelToSqlConverterApplication.class);

	public static void main(String[] args) {
		logger.info("Starting Excel To SQL Converter Application");
		SpringApplication.run(ExcelToSqlConverterApplication.class, args);
		logger.info("Excel To SQL Converter Application started successfully");
	}

}
