<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Excel to SQL Converter</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh; padding: 20px;
        }
        .container { 
            max-width: 1200px; margin: 0 auto;
            background: rgba(255,255,255,0.95); border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1); padding: 40px;
            backdrop-filter: blur(10px);
        }
        .header { text-align: center; margin-bottom: 40px; }
        .header h1 { 
            color: #2c3e50; font-size: 2.5rem; margin-bottom: 10px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .header p { color: #7f8c8d; font-size: 1.1rem; }
        .cards-container { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .card { 
            background: #fff; border-radius: 15px; padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card:hover { transform: translateY(-5px); box-shadow: 0 20px 40px rgba(0,0,0,0.15); }
        .card-header { display: flex; align-items: center; margin-bottom: 25px; }
        .card-icon { 
            width: 50px; height: 50px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; color: white; margin-right: 15px;
        }
        .sql-icon { background: linear-gradient(45deg, #4CAF50, #45a049); }
        .csv-icon { background: linear-gradient(45deg, #FF9800, #F57C00); }
        .card-title { color: #2c3e50; font-size: 1.3rem; font-weight: 600; }
        .form-group { margin-bottom: 20px; }
        .form-group label { 
            display: block; margin-bottom: 8px; color: #34495e;
            font-weight: 500; font-size: 0.95rem;
        }
        .input-wrapper { position: relative; }
        .form-control { 
            width: 100%; padding: 12px 15px; border: 2px solid #e1e8ed;
            border-radius: 10px; font-size: 1rem; transition: all 0.3s ease;
            background: #f8f9fa;
        }
        .form-control:focus { 
            outline: none; border-color: #667eea; background: #fff;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .file-input { position: relative; overflow: hidden; display: inline-block; width: 100%; }
        .file-input input[type=file] { 
            position: absolute; left: -9999px; opacity: 0;
        }
        .file-input-label { 
            display: block; padding: 12px 15px; border: 2px dashed #667eea;
            border-radius: 10px; text-align: center; cursor: pointer;
            transition: all 0.3s ease; background: #f8f9fa;
        }
        .file-input-label:hover { background: #e3f2fd; border-color: #2196F3; }
        .file-input-label i { margin-right: 8px; color: #667eea; }
        .btn { 
            width: 100%; padding: 15px; border: none; border-radius: 10px;
            font-size: 1rem; font-weight: 600; cursor: pointer;
            transition: all 0.3s ease; position: relative; overflow: hidden;
        }
        .btn-primary { 
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3); }
        .btn:disabled { opacity: 0.6; cursor: not-allowed; }
        .loading { display: none; }
        .loading.active { display: inline-block; }
        .result { 
            margin-top: 25px; padding: 20px; border-radius: 10px;
            background: #f8f9fa; border-left: 4px solid #667eea;
            display: none; animation: slideIn 0.3s ease;
        }
        .result.show { display: block; }
        .result-header { 
            display: flex; justify-content: between; align-items: center;
            margin-bottom: 15px;
        }
        .result-title { color: #2c3e50; font-weight: 600; }
        .copy-btn { 
            padding: 5px 10px; background: #667eea; color: white;
            border: none; border-radius: 5px; cursor: pointer; font-size: 0.8rem;
        }
        .result-content { 
            background: #2c3e50; color: #ecf0f1; padding: 15px;
            border-radius: 8px; font-family: 'Courier New', monospace;
            font-size: 0.9rem; line-height: 1.4; max-height: 300px;
            overflow-y: auto; white-space: pre-wrap; word-wrap: break-word;
        }
        @keyframes slideIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @media (max-width: 768px) { 
            .cards-container { grid-template-columns: 1fr; }
            .container { padding: 20px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-file-excel"></i> Excel to SQL Converter</h1>
            <p>Transform your Excel data into SQL queries and CSV formats with ease</p>
        </div>
        
        <div class="cards-container">
            <div class="card">
                <div class="card-header">
                    <div class="card-icon sql-icon">
                        <i class="fas fa-database"></i>
                    </div>
                    <div class="card-title">SQL Insert Generator</div>
                </div>
                <form id="insertForm" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="insertFile">Excel File</label>
                        <div class="file-input">
                            <input type="file" id="insertFile" name="file" accept=".xlsx,.xls" required>
                            <label for="insertFile" class="file-input-label">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span class="file-text">Choose Excel file...</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="tableName">Table Name</label>
                        <input type="text" id="tableName" name="tableName" class="form-control" placeholder="Enter table name" required>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <span class="btn-text">Generate SQL Query</span>
                        <i class="fas fa-spinner fa-spin loading"></i>
                    </button>
                </form>
                <div id="insertResult" class="result">
                    <div class="result-header">
                        <span class="result-title">SQL Insert Query</span>
                        <button class="copy-btn" onclick="copyToClipboard('insertOutput')">Copy</button>
                    </div>
                    <div id="insertOutput" class="result-content"></div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-icon csv-icon">
                        <i class="fas fa-file-csv"></i>
                    </div>
                    <div class="card-title">CSV Value Extractor</div>
                </div>
                <form id="csvForm" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="csvFile">Excel File</label>
                        <div class="file-input">
                            <input type="file" id="csvFile" name="file" accept=".xlsx,.xls" required>
                            <label for="csvFile" class="file-input-label">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <span class="file-text">Choose Excel file...</span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="startRow">Start Row</label>
                        <input type="number" id="startRow" name="start" class="form-control" min="1" placeholder="1" required>
                    </div>
                    <div class="form-group">
                        <label for="endRow">End Row</label>
                        <input type="number" id="endRow" name="end" class="form-control" min="1" placeholder="10" required>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <span class="btn-text">Extract CSV Values</span>
                        <i class="fas fa-spinner fa-spin loading"></i>
                    </button>
                </form>
                <div id="csvResult" class="result">
                    <div class="result-header">
                        <span class="result-title">Comma Separated Values</span>
                        <button class="copy-btn" onclick="copyToClipboard('csvOutput')">Copy</button>
                    </div>
                    <div id="csvOutput" class="result-content"></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function updateFileName(input, textElement) {
            const fileName = input.files[0]?.name || 'Choose Excel file...';
            textElement.textContent = fileName;
        }

        function toggleLoading(form, show) {
            const btn = form.querySelector('button[type="submit"]');
            const loading = btn.querySelector('.loading');
            const text = btn.querySelector('.btn-text');
            
            if (show) {
                loading.classList.add('active');
                text.style.display = 'none';
                btn.disabled = true;
            } else {
                loading.classList.remove('active');
                text.style.display = 'inline';
                btn.disabled = false;
            }
        }

        function showResult(resultId, content) {
            const result = document.getElementById(resultId);
            const output = result.querySelector('.result-content');
            output.textContent = content;
            result.classList.add('show');
        }

        function copyToClipboard(elementId) {
            const element = document.getElementById(elementId);
            navigator.clipboard.writeText(element.textContent).then(() => {
                const btn = event.target;
                const originalText = btn.textContent;
                btn.textContent = 'Copied!';
                setTimeout(() => btn.textContent = originalText, 2000);
            });
        }

        document.getElementById('insertFile').addEventListener('change', function() {
            updateFileName(this, this.parentElement.querySelector('.file-text'));
        });

        document.getElementById('csvFile').addEventListener('change', function() {
            updateFileName(this, this.parentElement.querySelector('.file-text'));
        });

        document.getElementById('insertForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            toggleLoading(this, true);
            
            fetch('/getInsertQuery', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                showResult('insertResult', data);
            })
            .catch(error => {
                showResult('insertResult', 'Error: ' + error);
            })
            .finally(() => {
                toggleLoading(this, false);
            });
        });

        document.getElementById('csvForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            toggleLoading(this, true);
            
            fetch('/getCamaSeparatedValue', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                showResult('csvResult', data);
            })
            .catch(error => {
                showResult('csvResult', 'Error: ' + error);
            })
            .finally(() => {
                toggleLoading(this, false);
            });
        });
    </script>
</body>
</html>