# ExcelToSqlConverter

A Spring Boot web application that provides multiple document processing utilities including Excel to SQL conversion, JSON/XML viewing, and Word document processing.

## Features

- **SQL Generator**: Convert Excel files (.xlsx) to SQL INSERT statements
- **JSON Viewer**: View and format JSON data with search functionality
- **JSON Comparator**: Compare two JSON objects with filtering, maximized view, and synchronized scrolling
- **XML Viewer**: View and format XML data with search functionality
- **Word Processor**: Search for keywords in Word documents and extract matching lines

## Requirements

- Java 8+
- Maven 3.6+

## Installation

1. Clone the repository
2. Navigate to the project directory
3. Build the application:

```bash
mvn clean install
```

4. Run the application:

```bash
mvn spring-boot:run
```

Or run the WAR file:

```bash
java -jar target/ExcelToSqlConverter-0.0.1-SNAPSHOT.war
```

## Configuration

The application runs on port 8081 by default. Configuration can be modified in `src/main/resources/application.properties`:

- `server.port`: Application port (default: 8081)
- `spring.servlet.multipart.max-file-size`: Maximum file upload size (default: 50MB)
- `spring.servlet.multipart.max-request-size`: Maximum request size (default: 50MB)

## Usage

Once the application is running, access it at `http://localhost:8081`

The home page provides navigation to all available tools.

## API Documentation

### 1. SQL Generator

**POST** `/getInsertQuery`

Converts an Excel file to SQL INSERT statements.

Reads the first sheet of the Excel workbook, uses the first row as column headers, and generates a single SQL INSERT statement with all data rows. Handles NULL values, date formatting (yyyy-MM-dd, yyyy-MM-dd HH:mm:ss), escapes single quotes, and preserves Excel cell formatting.

**Parameters:**
- `file` (multipart/form-data): Excel file (.xlsx) to convert
- `tableName` (string): Target SQL table name

**Response:**
- Returns SQL INSERT query as plain text

**Example:**
```bash
curl -X POST http://localhost:8081/getInsertQuery \
  -F "file=@data.xlsx" \
  -F "tableName=employees"
```

**Sample Response:**
```sql
INSERT INTO employees (id, name, hire_date, salary) VALUES 
(1, 'John Doe', '2023-01-15', 50000),
(2, 'Jane Smith', '2023-02-20', 55000);
```

### 2. Word Processor

**POST** `/processWordDocument`

Searches for specific keywords in a Word document and returns the line numbers where they are found.

**Parameters:**
- `file` (multipart/form-data): Word document (.doc or .docx)
- `words` (string): Comma-separated keywords to search for

**Response:**
- Returns a JSON map with line numbers as keys and matching lines as values

**Example:**
```bash
curl -X POST http://localhost:8081/processWordDocument \
  -F "file=@document.docx" \
  -F "words=error,warning,exception"
```

**Sample Response:**
```json
{
  "5": "An error occurred during processing",
  "12": "Warning: deprecated method used",
  "23": "Exception thrown in module"
}
```

## Web Interface

The application provides a user-friendly web interface accessible at `http://localhost:8081` with the following tools:

- **SQL Generator** (`/sql-generator`): Upload Excel files and generate SQL INSERT statements
- **JSON Viewer** (`/json-viewer`): View and format JSON data with search functionality
- **JSON Comparator** (`/json-comparator`): Compare two JSON objects with advanced features:
  - Variable filtering: Select specific variables to compare
  - Maximized view: Full-screen comparison with synchronized scrolling
  - Difference highlighting: Visual indicators for different types of changes
  - Copy differences: Export comparison results
  - Search functionality: Find specific content in JSON data
- **XML Viewer** (`/xml-viewer`): View and format XML data with search functionality
- **Word Processor** (`/word-processor`): Search for keywords in Word documents

## Dependencies

- Spring Boot 3.5.6
- Spring Boot Starter Web
- Spring Boot Starter Test
- Apache POI 5.4.0 (Excel processing)
- Apache POI Scratchpad 5.4.0 (Word document processing)
- Tomcat Embed Jasper (JSP support)
- Jakarta Servlet JSP JSTL

## Project Structure

```
ExcelToSqlConverter/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/sathwik/converters/ExcelToSqlConverter/
│   │   │       ├── controller/
│   │   │       │   └── ExcelController.java
│   │   │       └── service/
│   │   │           └── ExcelService.java
│   │   ├── resources/
│   │   │   └── application.properties
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           └── jsp/
│   └── test/
├── pom.xml
└── README.md
```

## Build

```bash
mvn clean install
```

## Run

```bash
mvn spring-boot:run
```

Or:

```bash
java -jar target/ExcelToSqlConverter-0.0.1-SNAPSHOT.war
```

## Logging

The application includes comprehensive logging:
- Console logging with timestamp and message
- File logging with thread, level, logger, and message
- Configurable log levels in `application.properties`

## License

This project is available for use under standard software licensing terms.

## Author

Sathwik

## Support

For issues or questions, please refer to the project repository or contact the development team.
