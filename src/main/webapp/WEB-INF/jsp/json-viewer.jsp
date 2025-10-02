<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSON Viewer</title>
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
        .nav-links a.active { color: #2196F3; font-weight: 600; }
        .main-content { padding: 20px; flex: 1; }
        .container { 
            max-width: 1400px; margin: 0 auto;
            background: rgba(255,255,255,0.95); border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1); padding: 30px;
            backdrop-filter: blur(10px);
        }
        .header { text-align: center; margin-bottom: 30px; }
        .header h1 { color: #2c3e50; font-size: 2rem; margin-bottom: 10px; }
        .toolbar {
            display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap;
            align-items: center; justify-content: space-between;
        }
        .toolbar-left { display: flex; gap: 15px; flex-wrap: wrap; }
        .toolbar-right { display: flex; gap: 10px; }
        .btn {
            padding: 8px 16px; border: none; border-radius: 6px;
            font-size: 0.9rem; cursor: pointer; transition: all 0.3s ease;
        }
        .btn-primary { background: #2196F3; color: white; }
        .btn-success { background: #4CAF50; color: white; }
        .btn-warning { background: #FF9800; color: white; }
        .btn-danger { background: #f44336; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn:hover { transform: translateY(-1px); opacity: 0.9; }
        .editor-container {
            display: grid; grid-template-columns: 1fr 1fr; gap: 20px;
            height: 600px;
        }
        .editor-panel {
            border: 1px solid #ddd; border-radius: 8px; overflow: hidden;
            display: flex; flex-direction: column;
        }
        .panel-header {
            background: #f8f9fa; padding: 10px 15px; border-bottom: 1px solid #ddd;
            font-weight: 600; color: #495057; display: flex; justify-content: space-between;
            align-items: center;
        }
        .editor {
            flex: 1; padding: 15px; font-family: 'Courier New', monospace;
            font-size: 14px; line-height: 1.4; border: none; outline: none;
            resize: none; background: #fff;
        }
        .output {
            flex: 1; padding: 15px; font-family: 'Courier New', monospace;
            font-size: 14px; line-height: 1.4; background: #f8f9fa;
            overflow-y: auto; white-space: pre-wrap;
        }
        .status-bar {
            background: #e9ecef; padding: 8px 15px; font-size: 0.85rem;
            border-top: 1px solid #ddd; display: flex; justify-content: space-between;
        }
        .valid { color: #28a745; }
        .invalid { color: #dc3545; }
        .tree-view {
            font-family: 'Courier New', monospace; font-size: 13px;
            line-height: 1.6;
        }
        .tree-key { color: #0066cc; font-weight: bold; }
        .tree-string { color: #008000; }
        .tree-number { color: #ff6600; }
        .tree-boolean { color: #cc0066; }
        .tree-null { color: #999; font-style: italic; }
        .tree-bracket { color: #666; font-weight: bold; }
        .tree-indent { margin-left: 20px; }
        .json-children { margin-left: 20px; }
        .collapsible { cursor: pointer; user-select: none; }
        .collapsible:hover { background: #f0f0f0; }
        .collapsed { display: none; }
        @media (max-width: 768px) {
            .editor-container { grid-template-columns: 1fr; height: auto; }
            .toolbar { flex-direction: column; align-items: stretch; }
            .toolbar-left, .toolbar-right { justify-content: center; }
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
                <a href="/json-viewer" class="active"><i class="fas fa-code"></i> JSON Viewer</a>
                <a href="/xml-viewer"><i class="fas fa-file-code"></i> XML Viewer</a>
            </div>
        </div>
    </nav>
    
    <div class="main-content">
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-code"></i> JSON Viewer & Formatter</h1>
                <p>Format, validate, and visualize JSON data</p>
            </div>
            
            <div class="toolbar">
                <div class="toolbar-left">
                    <button class="btn btn-primary" onclick="formatJson()">
                        <i class="fas fa-magic"></i> Format
                    </button>
                    <button class="btn btn-success" onclick="validateJson()">
                        <i class="fas fa-check-circle"></i> Validate
                    </button>
                    <button class="btn btn-warning" onclick="minifyJson()">
                        <i class="fas fa-compress"></i> Minify
                    </button>
                    <button class="btn btn-secondary" onclick="clearAll()">
                        <i class="fas fa-trash"></i> Clear
                    </button>
                    <button class="btn btn-secondary" onclick="collapseAll()">
                        <i class="fas fa-minus-square"></i> Collapse All
                    </button>
                    <button class="btn btn-secondary" onclick="expandAll()">
                        <i class="fas fa-plus-square"></i> Expand All
                    </button>
                </div>
                <div class="toolbar-right">
                    <button class="btn btn-secondary" onclick="copyToClipboard('output')">
                        <i class="fas fa-copy"></i> Copy
                    </button>
                    <input type="file" id="fileInput" accept=".json" style="display:none" onchange="loadFile(event)">
                    <button class="btn btn-secondary" onclick="document.getElementById('fileInput').click()">
                        <i class="fas fa-upload"></i> Load File
                    </button>
                </div>
            </div>
            
            <div class="editor-container">
                <div class="editor-panel">
                    <div class="panel-header">
                        <span>JSON Input</span>
                        <span id="inputStats">0 characters</span>
                    </div>
                    <textarea id="jsonInput" class="editor" placeholder="Paste your JSON here..."></textarea>
                    <div class="status-bar">
                        <span id="validationStatus">Ready</span>
                        <span id="inputSize">Size: 0 bytes</span>
                    </div>
                </div>
                
                <div class="editor-panel">
                    <div class="panel-header">
                        <span>Formatted Output</span>
                        <div>
                            <button class="btn btn-secondary" onclick="toggleView()" style="padding: 4px 8px; font-size: 0.8rem;">
                                <span id="viewToggle">Tree View</span>
                            </button>
                        </div>
                    </div>
                    <div id="output" class="output"></div>
                    <div class="status-bar">
                        <span id="outputInfo">No output</span>
                        <span id="outputSize">Size: 0 bytes</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentView = 'formatted';
        let jsonData = null;
        let nodeIdCounter = 0;

        document.getElementById('jsonInput').addEventListener('input', function() {
            updateStats();
            validateJson();
        });

        function updateStats() {
            const input = document.getElementById('jsonInput').value;
            const charCount = input.length;
            const byteSize = new Blob([input]).size;
            
            document.getElementById('inputStats').textContent = charCount + ' characters';
            document.getElementById('inputSize').textContent = 'Size: ' + byteSize + ' bytes';
        }

        function formatJson() {
            const input = document.getElementById('jsonInput').value.trim();
            if (!input) return;

            try {
                jsonData = JSON.parse(input);
                const formatted = JSON.stringify(jsonData, null, 2);
                document.getElementById('output').textContent = formatted;
                document.getElementById('validationStatus').innerHTML = '<span class="valid"><i class="fas fa-check"></i> Valid JSON</span>';
                document.getElementById('outputInfo').textContent = 'Formatted successfully';
                updateOutputStats(formatted);
                currentView = 'formatted';
                document.getElementById('viewToggle').textContent = 'Tree View';
            } catch (error) {
                document.getElementById('output').textContent = 'Error: ' + error.message;
                document.getElementById('validationStatus').innerHTML = '<span class="invalid"><i class="fas fa-times"></i> Invalid JSON</span>';
                document.getElementById('outputInfo').textContent = 'Format failed';
            }
        }

        function validateJson() {
            const input = document.getElementById('jsonInput').value.trim();
            if (!input) {
                document.getElementById('validationStatus').textContent = 'Ready';
                return;
            }

            try {
                JSON.parse(input);
                document.getElementById('validationStatus').innerHTML = '<span class="valid"><i class="fas fa-check"></i> Valid JSON</span>';
            } catch (error) {
                document.getElementById('validationStatus').innerHTML = '<span class="invalid"><i class="fas fa-times"></i> Invalid: ' + error.message + '</span>';
            }
        }

        function minifyJson() {
            const input = document.getElementById('jsonInput').value.trim();
            if (!input) return;

            try {
                const parsed = JSON.parse(input);
                const minified = JSON.stringify(parsed);
                document.getElementById('output').textContent = minified;
                document.getElementById('outputInfo').textContent = 'Minified successfully';
                updateOutputStats(minified);
                currentView = 'formatted';
                document.getElementById('viewToggle').textContent = 'Tree View';
            } catch (error) {
                document.getElementById('output').textContent = 'Error: ' + error.message;
                document.getElementById('outputInfo').textContent = 'Minify failed';
            }
        }

        function toggleView() {
            if (!jsonData) {
                formatJson();
                if (!jsonData) return;
            }

            if (currentView === 'formatted') {
                showTreeView();
                currentView = 'tree';
                document.getElementById('viewToggle').textContent = 'JSON View';
            } else {
                const formatted = JSON.stringify(jsonData, null, 2);
                document.getElementById('output').textContent = formatted;
                currentView = 'formatted';
                document.getElementById('viewToggle').textContent = 'Tree View';
            }
        }

        function showTreeView() {
            nodeIdCounter = 0;
            const treeHtml = jsonToTree(jsonData);
            document.getElementById('output').innerHTML = treeHtml;
        }

        function jsonToTree(obj, indent = 0) {
            let html = '';
            const nodeId = 'json-node-' + (++nodeIdCounter);

            if (Array.isArray(obj)) {
                if (obj.length > 0) {
                    html += '<div class="json-children" id="children-' + nodeId + '">';
                    obj.forEach((item, index) => {
                        const hasChildren = typeof item === 'object' && item !== null;
                        if (hasChildren) {
                            const childNodeId = nodeId + '-' + index;
                            html += '<div id="' + childNodeId + '">';
                            html += '<span class="collapsible" onclick="toggleJsonNode(\'' + childNodeId + '\')">▼ </span>';
                            html += '<span class="tree-key">[' + index + ']:</span> </div>';
                            const childHtml = jsonToTree(item, indent + 1);
                            html += childHtml.replace('id="children-json-node-' + nodeIdCounter + '"', 'id="children-' + childNodeId + '"');
                        } else {
                            html += '<div>';
                            html += '<span class="tree-key">[' + index + ']:</span> ';
                            html += formatValue(item) + '</div>';
                        }
                    });
                    html += '</div>';
                }
            } else if (typeof obj === 'object' && obj !== null) {
                const keys = Object.keys(obj);
                if (keys.length > 0) {
                    html += '<div class="json-children" id="children-' + nodeId + '">';
                    keys.forEach(key => {
                        const hasChildren = typeof obj[key] === 'object' && obj[key] !== null;
                        if (hasChildren) {
                            const childNodeId = nodeId + '-' + key;
                            html += '<div id="' + childNodeId + '">';
                            html += '<span class="collapsible" onclick="toggleJsonNode(\'' + childNodeId + '\')">▼ </span>';
                            html += '<span class="tree-key">"' + key + '":</span> </div>';
                            const childHtml = jsonToTree(obj[key], indent + 1);
                            html += childHtml.replace('id="children-json-node-' + nodeIdCounter + '"', 'id="children-' + childNodeId + '"');
                        } else {
                            html += '<div>';
                            html += '<span class="tree-key">"' + key + '":</span> ';
                            html += formatValue(obj[key]) + '</div>';
                        }
                    });
                    html += '</div>';
                }
            } else {
                html += '<div>' + formatValue(obj) + '</div>';
            }

            return html;
        }

        function formatValue(value) {
            if (typeof value === 'string') {
                return '<span class="tree-string">"' + value + '"</span>';
            } else if (typeof value === 'number') {
                return '<span class="tree-number">' + value + '</span>';
            } else if (typeof value === 'boolean') {
                return '<span class="tree-boolean">' + value + '</span>';
            } else if (value === null) {
                return '<span class="tree-null">null</span>';
            }
            return value;
        }

        function toggleJsonNode(nodeId) {
            const toggleElement = document.querySelector('#' + nodeId + ' .collapsible');
            const childrenContainer = document.getElementById('children-' + nodeId);
            
            if (!toggleElement || !childrenContainer) return;
            
            const isCollapsed = childrenContainer.style.display === 'none';
            
            if (isCollapsed) {
                childrenContainer.style.display = 'block';
                toggleElement.textContent = '▼ ';
            } else {
                childrenContainer.style.display = 'none';
                toggleElement.textContent = '▶ ';
            }
        }

        function collapseAll() {
            const allChildren = document.querySelectorAll('.json-children');
            const allToggles = document.querySelectorAll('.collapsible');
            
            allChildren.forEach(child => {
                child.style.display = 'none';
            });
            
            allToggles.forEach(toggle => {
                toggle.textContent = '▶ ';
            });
        }

        function expandAll() {
            const allChildren = document.querySelectorAll('.json-children');
            const allToggles = document.querySelectorAll('.collapsible');
            
            allChildren.forEach(child => {
                child.style.display = 'block';
            });
            
            allToggles.forEach(toggle => {
                toggle.textContent = '▼ ';
            });
        }

        function clearAll() {
            document.getElementById('jsonInput').value = '';
            document.getElementById('output').textContent = '';
            document.getElementById('validationStatus').textContent = 'Ready';
            document.getElementById('outputInfo').textContent = 'No output';
            updateStats();
            updateOutputStats('');
            jsonData = null;
            nodeIdCounter = 0;
        }

        function copyToClipboard(elementId) {
            const element = document.getElementById(elementId);
            const text = element.textContent || element.innerText;
            navigator.clipboard.writeText(text).then(() => {
                const btn = event.target.closest('button');
                const originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                setTimeout(() => btn.innerHTML = originalText, 2000);
            });
        }

        function loadFile(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('jsonInput').value = e.target.result;
                    updateStats();
                    validateJson();
                };
                reader.readAsText(file);
            }
        }

        function updateOutputStats(output) {
            const byteSize = new Blob([output]).size;
            document.getElementById('outputSize').textContent = 'Size: ' + byteSize + ' bytes';
        }

        // Sample JSON for demo
        document.getElementById('jsonInput').value = `{
  "name": "John Doe",
  "age": 30,
  "city": "New York",
  "hobbies": ["reading", "swimming", "coding"],
  "address": {
    "street": "123 Main St",
    "zipcode": "10001"
  },
  "active": true
}`;
        updateStats();
        validateJson();
    </script>
</body>
</html>