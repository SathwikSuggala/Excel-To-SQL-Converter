<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Excel Converter - Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh; margin: 0; display: flex; flex-direction: column;
        }
        .navbar {
            background: rgba(255,255,255,0.1); backdrop-filter: blur(10px);
            padding: 15px 0; position: sticky; top: 0; z-index: 100;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; display: flex;
            justify-content: space-between; align-items: center; padding: 0 20px;
        }
        .logo { color: white; font-size: 1.5rem; font-weight: 600; text-decoration: none; }
        .nav-links { display: flex; gap: 30px; }
        .nav-links a {
            color: white; text-decoration: none; font-weight: 500;
            transition: color 0.3s ease;
        }
        .nav-links a:hover { color: #f0f0f0; }
        .main-content { display: flex; align-items: center; justify-content: center; flex: 1; }

        .container { 
            max-width: 800px; text-align: center;
            background: rgba(255,255,255,0.95); border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1); padding: 60px 40px;
            backdrop-filter: blur(10px);
        }
        .header h1 { 
            color: #2c3e50; font-size: 3rem; margin-bottom: 15px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .header p { color: #7f8c8d; font-size: 1.2rem; margin-bottom: 50px; }
        .options { display: grid; grid-template-columns: repeat(2, 1fr); gap: 30px; }
        @media (min-width: 1024px) { .options { grid-template-columns: repeat(4, 1fr); } }
        .option-card { 
            background: #fff; border-radius: 15px; padding: 40px 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1); cursor: pointer;
            transition: all 0.3s ease; text-decoration: none; color: inherit;
        }
        .option-card:hover { 
            transform: translateY(-10px); box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            text-decoration: none; color: inherit;
        }
        .option-icon { 
            width: 80px; height: 80px; border-radius: 20px; margin: 0 auto 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem; color: white;
        }
        .sql-icon { background: linear-gradient(45deg, #4CAF50, #45a049); }
        .csv-icon { background: linear-gradient(45deg, #FF9800, #F57C00); }
        .json-icon { background: linear-gradient(45deg, #2196F3, #1976D2); }
        .xml-icon { background: linear-gradient(45deg, #9C27B0, #7B1FA2); }
        .option-title { color: #2c3e50; font-size: 1.5rem; font-weight: 600; margin-bottom: 10px; }
        .option-desc { color: #7f8c8d; font-size: 1rem; line-height: 1.5; }
        @media (max-width: 768px) { 
            .options { grid-template-columns: 1fr; }
            .container { padding: 40px 20px; }
            .header h1 { font-size: 2.5rem; }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="logo"><i class="fas fa-file-excel"></i> Excel Converter</a>
            <div class="nav-links">
                <a href="/sql-generator"><i class="fas fa-database"></i> SQL Generator</a>
                <a href="/csv-extractor"><i class="fas fa-file-csv"></i> CSV Extractor</a>
                <a href="/json-viewer"><i class="fas fa-code"></i> JSON Viewer</a>
                <a href="/xml-viewer"><i class="fas fa-file-code"></i> XML Viewer</a>
            </div>
        </div>
    </nav>
    
    <div class="main-content">
        <div class="container">
        <div class="header">
            <h1><i class="fas fa-file-excel"></i> Excel Converter</h1>
            <p>Choose your conversion tool to get started</p>
        </div>
        
        <div class="options">
            <a href="/sql-generator" class="option-card">
                <div class="option-icon sql-icon">
                    <i class="fas fa-database"></i>
                </div>
                <div class="option-title">SQL Insert Generator</div>
                <div class="option-desc">Convert Excel data into SQL INSERT statements for database operations</div>
            </a>
            
            <a href="/csv-extractor" class="option-card">
                <div class="option-icon csv-icon">
                    <i class="fas fa-file-csv"></i>
                </div>
                <div class="option-title">CSV Value Extractor</div>
                <div class="option-desc">Extract specific rows from Excel files as comma-separated values</div>
            </a>
            
            <a href="/json-viewer" class="option-card">
                <div class="option-icon json-icon">
                    <i class="fas fa-code"></i>
                </div>
                <div class="option-title">JSON Viewer</div>
                <div class="option-desc">Format, validate, and visualize JSON data with syntax highlighting</div>
            </a>
            
            <a href="/xml-viewer" class="option-card">
                <div class="option-icon xml-icon">
                    <i class="fas fa-file-code"></i>
                </div>
                <div class="option-title">XML Viewer</div>
                <div class="option-desc">Format, validate, and explore XML documents with tree view</div>
            </a>
        </div>
    </div>

</body>
</html>