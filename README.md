# ExcelToSqlConverter

A Spring Boot application for converting Excel sheets to SQL insert queries.

## Features

- Convert Excel files to SQL INSERT statements
- Spring Boot web application
- Apache POI for Excel processing

## Requirements

- Java 8+
- Maven 3.6+

## Installation

1. Clone the repository
2. Navigate to the project directory
3. Run the application:

```bash
mvn spring-boot:run
```

## Configuration

The application runs on port 8081 by default. To change the port, modify `server.port` in `src/main/resources/application.properties`.

## Usage

Once the application is running, access it at `http://localhost:8081`

## Dependencies

- Spring Boot 3.5.6
- Apache POI 5.4.0
- Spring Boot Starter Web
- Spring Boot Starter Test

## Build

```bash
mvn clean install
```

## Run

```bash
java -jar target/ExcelToSqlConverter-0.0.1-SNAPSHOT.jar
```

## API Documentation

### POST /getInsertQuery

Converts an Excel file to SQL INSERT statements.

This API accepts an Excel file (.xlsx) uploaded via a multipart form request and generates a single SQL INSERT statement that can be used to populate a database table with the data from the Excel sheet. It reads the first sheet in the workbook, extracts the first row as column headers (used as the table's column names), and processes all subsequent rows as data. For each row, it collects cell values and formats them exactly as they appear in Excel, preserving formats such as dates (yyyy-MM-dd, yyyy-MM-dd HH:mm:ss, etc.) and numbers, using Apache POI's DataFormatter. Special care is taken to handle "NULL" values (whether actual nulls or the string "NULL"), escape single quotes in text, and wrap string values in single quotes for SQL compatibility. The result is a well-structured SQL INSERT INTO table_name (...) VALUES (...) statement that includes all rows from the Excel file, which can be executed in a SQL environment like MySQL to insert the data efficiently.

**Parameters:**
- `file` (multipart/form-data): Excel file to convert
- `tableName` (string): Target SQL table name

**Response:**
- Returns SQL INSERT queries as plain text

**Example:**
```bash
curl -X POST http://localhost:8081/getInsertQuery \
  -F "file=@data.xlsx" \
  -F "tableName=employees"
```