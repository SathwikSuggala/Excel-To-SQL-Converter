<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>CSV Value Extractor</title>
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
        .nav-links a.active { color: #FF9800; font-weight: 600; }
        .main-content { padding: 20px; flex: 1; }

        .container { 
            max-width: 600px; margin: 20px auto;
            background: rgba(255,255,255,0.95); border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1); padding: 40px;
            backdrop-filter: blur(10px);
        }
        .header { text-align: center; margin-bottom: 30px; }
        .header h1 { color: #2c3e50; font-size: 2rem; margin-bottom: 10px; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #34495e; font-weight: 500; }
        .form-control { 
            width: 100%; padding: 12px 15px; border: 2px solid #e1e8ed;
            border-radius: 10px; font-size: 1rem; transition: all 0.3s ease;
        }
        .form-control:focus { outline: none; border-color: #667eea; }
        .file-input { position: relative; overflow: hidden; display: inline-block; width: 100%; }
        .file-input input[type=file] { position: absolute; left: -9999px; opacity: 0; }
        .file-input-label { 
            display: block; padding: 12px 15px; border: 2px dashed #667eea;
            border-radius: 10px; text-align: center; cursor: pointer; transition: all 0.3s ease;
        }
        .file-input-label:hover { background: #e3f2fd; }
        .row-inputs { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .btn { 
            width: 100%; padding: 15px; border: none; border-radius: 10px;
            font-size: 1rem; font-weight: 600; cursor: pointer;
            background: linear-gradient(45deg, #FF9800, #F57C00); color: white;
            transition: all 0.3s ease;
        }
        .btn:hover { transform: translateY(-2px); }
        .btn:disabled { opacity: 0.6; cursor: not-allowed; }
        .loading { display: none; }
        .loading.active { display: inline-block; }
        
        .modal { 
            display: none; position: fixed; z-index: 1000; left: 0; top: 0;
            width: 100%; height: 100%; background: rgba(0,0,0,0.5);
        }
        .modal-content { 
            background: #fff; margin: 5% auto; padding: 30px; width: 90%; max-width: 800px;
            border-radius: 15px; position: relative; max-height: 80vh; overflow-y: auto;
        }
        .close { 
            position: absolute; right: 20px; top: 20px; font-size: 28px;
            font-weight: bold; cursor: pointer; color: #aaa;
        }
        .close:hover { color: #000; }
        .result-content { 
            background: #2c3e50; color: #ecf0f1; padding: 20px; border-radius: 8px;
            font-family: 'Courier New', monospace; font-size: 0.9rem; line-height: 1.4;
            white-space: pre-wrap; word-wrap: break-word; margin-top: 15px;
        }
        .copy-btn { 
            margin-top: 15px; padding: 10px 20px; background: #667eea; color: white;
            border: none; border-radius: 5px; cursor: pointer;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="logo"><i class="fas fa-file-excel"></i> Excel Converter</a>
            <div class="nav-links">
                <a href="/sql-generator"><i class="fas fa-database"></i> SQL Generator</a>
                <a href="/csv-extractor" class="active"><i class="fas fa-file-csv"></i> CSV Extractor</a>
            </div>
        </div>
    </nav>
    
    <div class="main-content">
        <div class="container">
        <div class="header">
            <h1><i class="fas fa-file-csv"></i> CSV Value Extractor</h1>
            <p>Extract specific rows as comma-separated values</p>
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
            <div class="row-inputs">
                <div class="form-group">
                    <label for="startRow">Start Row</label>
                    <input type="number" id="startRow" name="start" class="form-control" min="1" placeholder="1" required>
                </div>
                <div class="form-group">
                    <label for="endRow">End Row</label>
                    <input type="number" id="endRow" name="end" class="form-control" min="1" placeholder="10" required>
                </div>
            </div>
            <button type="submit" class="btn">
                <span class="btn-text">Extract CSV Values</span>
                <i class="fas fa-spinner fa-spin loading"></i>
            </button>
        </form>
        </div>
    </div>


    <div id="resultModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Comma Separated Values</h2>
            <div id="csvOutput" class="result-content"></div>
            <button class="copy-btn" onclick="copyToClipboard('csvOutput')">Copy to Clipboard</button>
        </div>
    </div>

    <script>
        const modal = document.getElementById('resultModal');
        const closeBtn = document.querySelector('.close');
        
        document.getElementById('csvFile').addEventListener('change', function() {
            const fileName = this.files[0]?.name || 'Choose Excel file...';
            document.querySelector('.file-text').textContent = fileName;
        });

        document.getElementById('csvForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const btn = this.querySelector('button[type="submit"]');
            const loading = btn.querySelector('.loading');
            const text = btn.querySelector('.btn-text');
            
            loading.classList.add('active');
            text.style.display = 'none';
            btn.disabled = true;
            
            fetch('/getCamaSeparatedValue', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                document.getElementById('csvOutput').textContent = data;
                modal.style.display = 'block';
            })
            .catch(error => {
                document.getElementById('csvOutput').textContent = 'Error: ' + error;
                modal.style.display = 'block';
            })
            .finally(() => {
                loading.classList.remove('active');
                text.style.display = 'inline';
                btn.disabled = false;
            });
        });

        closeBtn.onclick = () => modal.style.display = 'none';
        window.onclick = (e) => { if (e.target === modal) modal.style.display = 'none'; };

        function copyToClipboard(elementId) {
            const element = document.getElementById(elementId);
            navigator.clipboard.writeText(element.textContent).then(() => {
                const btn = event.target;
                const originalText = btn.textContent;
                btn.textContent = 'Copied!';
                setTimeout(() => btn.textContent = originalText, 2000);
            });
        }
    </script>
</body>
</html>