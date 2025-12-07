<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Word Processor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
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
        .nav-links a.active { color: #FF5722; font-weight: 600; }
        .main-content { padding: 20px; flex: 1; }
        .container { 
            max-width: 1200px; margin: 0 auto;
            background: rgba(255,255,255,0.95); border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1); padding: 30px;
            backdrop-filter: blur(10px);
        }
        .header { text-align: center; margin-bottom: 30px; }
        .header h1 { color: #2c3e50; font-size: 2rem; margin-bottom: 10px; }
        .form-container {
            background: #f8f9fa; padding: 20px; border-radius: 10px;
            margin-bottom: 20px;
        }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; }
        .form-control {
            width: 100%; padding: 10px; border: 1px solid #ddd;
            border-radius: 5px; font-size: 14px;
        }
        .btn {
            padding: 10px 20px; border: none; border-radius: 5px;
            font-size: 14px; cursor: pointer; transition: all 0.3s ease;
        }
        .btn-primary { background: #FF5722; color: white; }
        .btn:hover { transform: translateY(-1px); opacity: 0.9; }
        .result-container {
            background: #f8f9fa; padding: 20px; border-radius: 10px;
            min-height: 200px; font-family: 'Courier New', monospace;
            white-space: pre-wrap; border: 1px solid #ddd;
        }
        .loading { text-align: center; color: #666; }
        .line-result {
            margin-bottom: 10px; padding: 8px; background: #fff;
            border-left: 3px solid #FF5722; border-radius: 4px;
        }
        .line-number {
            font-weight: bold; color: #FF5722; margin-right: 10px;
        }
        .line-content {
            font-family: 'Courier New', monospace; color: #333;
        }
        .highlight {
            background-color: #ffeb3b; padding: 2px 4px; border-radius: 3px;
            font-weight: bold; color: #d84315;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="logo"><i class="fas fa-file-excel"></i> Converters </a>
            <div class="nav-links">
                <a href="/sql-generator"><i class="fas fa-database"></i> SQL Generator</a>
                <a href="/csv-extractor"><i class="fas fa-file-csv"></i> CSV Extractor</a>
                <a href="/json-viewer"><i class="fas fa-code"></i> JSON Viewer</a>
                <a href="/xml-viewer"><i class="fas fa-file-code"></i> XML Viewer</a>
                <a href="/word-processor" class="active"><i class="fas fa-file-word"></i> Word Processor</a>
            </div>
        </div>
    </nav>
    
    <div class="main-content">
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-file-word"></i> Word Document Processor</h1>
                <p>Upload a Word document and search for specific words</p>
            </div>
            
            <form id="wordForm" enctype="multipart/form-data">
                <div class="form-container">
                    <div class="form-group">
                        <label for="wordFile">Select Word Document (.doc or .docx):</label>
                        <input type="file" id="wordFile" name="file" class="form-control" accept=".doc,.docx" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="searchWords">Words to Search (comma-separated):</label>
                        <input type="text" id="searchWords" name="words" class="form-control" 
                               placeholder="e.g., hello, world, document" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Process Document
                    </button>
                </div>
            </form>
            
            <div class="result-container" id="result">
                Select a Word document and enter words to search...
            </div>
            
            <div id="downloadSection" style="display: none; margin-top: 15px; text-align: center;">
                <button class="btn btn-primary" onclick="downloadResults()">
                    <i class="fas fa-download"></i> Download Results as TXT
                </button>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('wordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData();
            const fileInput = document.getElementById('wordFile');
            const wordsInput = document.getElementById('searchWords');
            
            if (!fileInput.files[0]) {
                alert('Please select a Word document');
                return;
            }
            
            if (!wordsInput.value.trim()) {
                alert('Please enter words to search');
                return;
            }
            
            formData.append('file', fileInput.files[0]);
            formData.append('words', wordsInput.value);
            
            searchKeywords = wordsInput.value.split(',').map(word => word.trim()).filter(word => word);
            document.getElementById('result').innerHTML = '<div class="loading">Processing document...</div>';
            
            fetch('/processWordDocument', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.text();
            })
            .then(text => {
                try {
                    const data = JSON.parse(text);
                    displayResults(data);
                } catch (e) {
                    document.getElementById('result').innerHTML = '<div class="loading">' + text + '</div>';
                    document.getElementById('downloadSection').style.display = 'none';
                }
            })
            .catch(error => {
                document.getElementById('result').innerHTML = '<div class="loading">Error: ' + error.message + '</div>';
                document.getElementById('downloadSection').style.display = 'none';
            });
        });
        
        let searchResults = {};
        let searchKeywords = [];
        
        function displayResults(data) {
            const resultDiv = document.getElementById('result');
            const downloadSection = document.getElementById('downloadSection');
            
            if (typeof data === 'string') {
                resultDiv.innerHTML = '<div class="loading">' + data + '</div>';
                downloadSection.style.display = 'none';
                return;
            }
            
            searchResults = data;
            
            if (Object.keys(data).length === 0) {
                resultDiv.innerHTML = '<div class="loading">No lines found containing the specified words.</div>';
                downloadSection.style.display = 'none';
                return;
            }
            
            let html = '<div style="margin-bottom: 15px; font-weight: bold; color: #FF5722;">Found ' + Object.keys(data).length + ' lines containing the keywords:</div>';
            
            for (const [lineNumber, lineContent] of Object.entries(data)) {
                html += '<div class="line-result">';
                html += '<span class="line-number">Line ' + lineNumber + ':</span>';
                html += '<div class="line-content">' + highlightKeywords(escapeHtml(lineContent), searchKeywords) + '</div>';
                html += '</div>';
            }
            
            resultDiv.innerHTML = html;
            downloadSection.style.display = 'block';
        }
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        function highlightKeywords(text, keywords) {
            let highlightedText = text;
            keywords.forEach(keyword => {
                if (keyword.trim()) {
                    const regex = new RegExp('(' + keyword.replace(/[.*+?^\${}()|[\]\\]/g, '\\\$&') + ')', 'gi');
                    highlightedText = highlightedText.replace(regex, '<span class="highlight">\$1</span>');
                }
            });
            return highlightedText;
        }
        
        function downloadResults() {
            if (Object.keys(searchResults).length === 0) {
                alert('No results to download');
                return;
            }
            
            let content = 'Word Search Results\n';
            content += '===================\n\n';
            content += 'Found ' + Object.keys(searchResults).length + ' lines containing the keywords:\n\n';
            
            for (const [lineNumber, lineContent] of Object.entries(searchResults)) {
                content += 'Line ' + lineNumber + ': ' + lineContent + '\n';
            }
            
            const blob = new Blob([content], { type: 'text/plain' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'word-search-results.txt';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        }
    </script>
</body>
</html>