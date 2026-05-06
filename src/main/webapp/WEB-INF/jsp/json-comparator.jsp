<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSON Comparator</title>
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
        .nav-links a.active { color: #2196F3; font-weight: 600; }
        .hamburger { display: none; flex-direction: column; cursor: pointer; }
        .hamburger span { width: 25px; height: 3px; background: white; margin: 3px 0; transition: 0.3s; }
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
            align-items: center; justify-content: center;
        }
        .filter-container {
            background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px;
            border: 1px solid #ddd;
        }
        .filter-row {
            display: flex; gap: 10px; align-items: center; margin-bottom: 10px;
            flex-wrap: wrap;
        }
        .filter-input {
            padding: 6px 10px; border: 1px solid #ddd; border-radius: 4px;
            font-size: 0.9rem; min-width: 200px;
        }
        .maximize-container {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: white; z-index: 1000; display: none; flex-direction: column;
        }
        .maximize-header {
            background: #2196F3; color: white; padding: 15px;
            display: flex; justify-content: space-between; align-items: center;
            height: 70px; box-sizing: border-box;
        }
        .maximize-content {
            flex: 1; display: grid; grid-template-columns: 1fr 1fr;
            gap: 0; height: calc(100vh - 70px);
        }
        .maximize-panel {
            border-right: 1px solid #ddd; display: flex; flex-direction: column;
        }
        .maximize-panel:last-child { border-right: none; }
        .maximize-editor {
            flex: 1; padding: 15px; font-family: 'Courier New', monospace;
            font-size: 14px; line-height: 1.4; border: none; outline: none;
            resize: none; background: #fff; overflow-y: auto;
        }
        .search-container {
            padding: 10px; background: #f8f9fa; border-bottom: 1px solid #ddd;
            display: flex; gap: 10px; align-items: center;
        }
        .search-input {
            padding: 6px 10px; border: 1px solid #ddd; border-radius: 4px;
            font-size: 0.9rem; flex: 1;
        }
        .search-results {
            font-size: 0.85rem; color: #666;
        }
        .highlight {
            background: #ffeb3b; color: #000; padding: 1px 2px;
        }
        .diff-highlight-added { background: #c8e6c9; }
        .diff-highlight-removed { background: #ffcdd2; }
        .diff-highlight-modified { background: #fff3e0; }
        .btn {
            padding: 8px 16px; border: none; border-radius: 6px;
            font-size: 0.9rem; cursor: pointer; transition: all 0.3s ease;
        }
        .btn-primary { background: #2196F3; color: white; }
        .btn-success { background: #4CAF50; color: white; }
        .btn-danger { background: #f44336; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn:hover { transform: translateY(-1px); opacity: 0.9; }
        .editor-container {
            display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px;
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
        .diff-added { background: #d4edda; color: #155724; padding: 2px 4px; }
        .diff-removed { background: #f8d7da; color: #721c24; padding: 2px 4px; }
        .diff-modified { background: #fff3cd; color: #856404; padding: 2px 4px; }
        .diff-line { margin: 2px 0; }
        .summary { 
            background: #e3f2fd; padding: 15px; border-radius: 8px; 
            margin-bottom: 15px; border-left: 4px solid #2196F3;
        }
        .summary-item { margin: 5px 0; }
        @media (max-width: 768px) {
            .hamburger { display: flex; }
            .nav-links { 
                position: fixed; top: 60px; right: -100%; flex-direction: column;
                background: rgba(102, 126, 234, 0.98); width: 250px; padding: 20px;
                box-shadow: -2px 0 10px rgba(0,0,0,0.2); transition: 0.3s;
                height: calc(100vh - 60px);
            }
            .nav-links.active { right: 0; }
            .editor-container { grid-template-columns: 1fr; height: auto; }
            .toolbar { flex-direction: column; align-items: stretch; }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="logo"><i class="fas fa-file-excel"></i> Converters </a>
            <div class="hamburger" onclick="document.querySelector('.nav-links').classList.toggle('active')">
                <span></span><span></span><span></span>
            </div>
            <div class="nav-links">
                <a href="/sql-generator"><i class="fas fa-database"></i> SQL Generator</a>
                <a href="/csv-extractor"><i class="fas fa-file-csv"></i> CSV Extractor</a>
                <a href="/json-viewer"><i class="fas fa-code"></i> JSON Viewer</a>
                <a href="/json-comparator" class="active"><i class="fas fa-code-compare"></i> JSON Comparator</a>
                <a href="/xml-viewer"><i class="fas fa-file-code"></i> XML Viewer</a>
                <a href="/word-processor"><i class="fas fa-file-word"></i> Word Processor</a>
            </div>
        </div>
    </nav>
    
    <div class="main-content">
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-code-compare"></i> JSON Comparator</h1>
                <p>Compare two JSON objects and find differences</p>
            </div>
            
            <div class="filter-container">
                <div class="filter-row">
                    <label><strong>Filter Variables:</strong></label>
                    <input type="text" id="filterInput" class="filter-input" placeholder="Enter variable names (comma-separated)" onchange="applyFilter()">
                    <button class="btn btn-secondary" onclick="clearFilter()">
                        <i class="fas fa-times"></i> Clear Filter
                    </button>
                    <button class="btn btn-primary" onclick="toggleMaximize()">
                        <i class="fas fa-expand"></i> Maximize
                    </button>
                </div>
            </div>
            
            <div class="toolbar">
                <button class="btn btn-primary" onclick="compareJson()">
                    <i class="fas fa-exchange-alt"></i> Compare
                </button>
                <button class="btn btn-success" onclick="formatBoth()">
                    <i class="fas fa-magic"></i> Format Both
                </button>
                <button class="btn btn-secondary" onclick="clearAll()">
                    <i class="fas fa-trash"></i> Clear All
                </button>
                <button class="btn btn-secondary" onclick="swapJson()">
                    <i class="fas fa-arrows-alt-h"></i> Swap
                </button>
            </div>
            
            <div class="editor-container">
                <div class="editor-panel">
                    <div class="panel-header">
                        <span>JSON 1</span>
                    </div>
                    <div class="search-container">
                        <input type="text" id="search1" class="search-input" placeholder="Search in JSON 1..." oninput="searchInEditor('json1', this.value)">
                        <span id="searchResults1" class="search-results"></span>
                    </div>
                    <textarea id="json1" class="editor" placeholder="Paste first JSON here..."></textarea>
                    <div class="status-bar">
                        <span id="status1">Ready</span>
                    </div>
                </div>
                
                <div class="editor-panel">
                    <div class="panel-header">
                        <span>JSON 2</span>
                    </div>
                    <div class="search-container">
                        <input type="text" id="search2" class="search-input" placeholder="Search in JSON 2..." oninput="searchInEditor('json2', this.value)">
                        <span id="searchResults2" class="search-results"></span>
                    </div>
                    <textarea id="json2" class="editor" placeholder="Paste second JSON here..."></textarea>
                    <div class="status-bar">
                        <span id="status2">Ready</span>
                    </div>
                </div>
                
                <div class="editor-panel">
                    <div class="panel-header">
                        <span>Differences</span>
                        <button class="btn btn-secondary" onclick="copyDiff()" style="padding: 4px 8px; font-size: 0.8rem;">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                    </div>
                    <div class="search-container">
                        <input type="text" id="searchDiff" class="search-input" placeholder="Search in differences..." oninput="searchInDiff(this.value)">
                        <span id="searchResultsDiff" class="search-results"></span>
                    </div>
                    <div id="output" class="output">No comparison yet</div>
                </div>
            </div>
            
            <div id="maximizeContainer" class="maximize-container">
                <div class="maximize-header">
                    <h3><i class="fas fa-code-compare"></i> JSON Comparator - Maximized View</h3>
                    <button class="btn btn-secondary" onclick="toggleMaximize()">
                        <i class="fas fa-compress"></i> Minimize
                    </button>
                </div>
                <div class="maximize-content">
                    <div class="maximize-panel">
                        <div class="panel-header">
                            <span>JSON 1</span>
                        </div>
                        <div class="search-container">
                            <input type="text" id="searchMax1" class="search-input" placeholder="Search in JSON 1..." oninput="searchInEditor('jsonMax1', this.value)">
                            <span id="searchResultsMax1" class="search-results"></span>
                        </div>
                        <div id="jsonMax1" class="maximize-editor" style="white-space: pre-wrap; overflow-y: auto;" onscroll="syncScroll('jsonMax1', 'jsonMax2')">Paste first JSON here...</div>
                    </div>
                    <div class="maximize-panel">
                        <div class="panel-header">
                            <span>JSON 2</span>
                        </div>
                        <div class="search-container">
                            <input type="text" id="searchMax2" class="search-input" placeholder="Search in JSON 2..." oninput="searchInEditor('jsonMax2', this.value)">
                            <span id="searchResultsMax2" class="search-results"></span>
                        </div>
                        <div id="jsonMax2" class="maximize-editor" style="white-space: pre-wrap; overflow-y: auto;" onscroll="syncScroll('jsonMax2', 'jsonMax1')">Paste second JSON here...</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentFilter = [];
        let lastDifferences = [];
        let isMaximized = false;
        
        function compareJson() {
            const input1 = document.getElementById('json1').value.trim();
            const input2 = document.getElementById('json2').value.trim();
            
            if (!input1 || !input2) {
                document.getElementById('output').textContent = 'Please provide both JSON inputs';
                return;
            }

            try {
                let obj1 = JSON.parse(input1);
                let obj2 = JSON.parse(input2);
                
                // Apply filter if active
                if (currentFilter.length > 0) {
                    obj1 = filterObject(obj1, currentFilter);
                    obj2 = filterObject(obj2, currentFilter);
                }
                
                document.getElementById('status1').innerHTML = '<span class="valid"><i class="fas fa-check"></i> Valid</span>';
                document.getElementById('status2').innerHTML = '<span class="valid"><i class="fas fa-check"></i> Valid</span>';
                
                const differences = findDifferences(obj1, obj2);
                lastDifferences = differences;
                displayDifferences(differences);
                
                // Highlight differences in maximized view if active
                if (isMaximized) {
                    highlightDifferencesInMaxView();
                }
            } catch (error) {
                document.getElementById('output').textContent = 'Error: ' + error.message;
                if (input1) {
                    try { JSON.parse(input1); } 
                    catch { document.getElementById('status1').innerHTML = '<span class="invalid"><i class="fas fa-times"></i> Invalid</span>'; }
                }
                if (input2) {
                    try { JSON.parse(input2); } 
                    catch { document.getElementById('status2').innerHTML = '<span class="invalid"><i class="fas fa-times"></i> Invalid</span>'; }
                }
            }
        }
        
        function filterObject(obj, filterKeys) {
            if (typeof obj !== 'object' || obj === null) return obj;
            
            const filtered = {};
            filterKeys.forEach(key => {
                if (obj.hasOwnProperty(key)) {
                    filtered[key] = obj[key];
                }
            });
            
            // Also check nested objects
            Object.keys(obj).forEach(key => {
                if (typeof obj[key] === 'object' && obj[key] !== null) {
                    const nestedFiltered = filterObject(obj[key], filterKeys);
                    if (Object.keys(nestedFiltered).length > 0) {
                        if (!filtered[key]) filtered[key] = {};
                        Object.assign(filtered[key], nestedFiltered);
                    }
                }
            });
            
            return filtered;
        }
        
        function applyFilter() {
            const filterInput = document.getElementById('filterInput').value.trim();
            if (filterInput) {
                currentFilter = filterInput.split(',').map(s => s.trim()).filter(s => s);
            } else {
                currentFilter = [];
            }
            
            // Re-run comparison if we have data
            const input1 = document.getElementById('json1').value.trim();
            const input2 = document.getElementById('json2').value.trim();
            if (input1 && input2) {
                compareJson();
            }
        }
        
        function clearFilter() {
            document.getElementById('filterInput').value = '';
            currentFilter = [];
            
            // Re-run comparison if we have data
            const input1 = document.getElementById('json1').value.trim();
            const input2 = document.getElementById('json2').value.trim();
            if (input1 && input2) {
                compareJson();
            }
        }
        
        function toggleMaximize() {
            const container = document.getElementById('maximizeContainer');
            isMaximized = !isMaximized;
            
            if (isMaximized) {
                container.style.display = 'flex';
                highlightDifferencesInMaxView();
            } else {
                container.style.display = 'none';
            }
        }
        
        function syncScroll(sourceId, targetId) {
            const source = document.getElementById(sourceId);
            const target = document.getElementById(targetId);
            
            const scrollPercentage = source.scrollTop / (source.scrollHeight - source.clientHeight);
            target.scrollTop = scrollPercentage * (target.scrollHeight - target.clientHeight);
        }
        
        function formatJsonInEditor(editorId) {
            const editor = document.getElementById(editorId);
            const input = editor.value.trim();
            if (!input) return;
            
            try {
                const parsed = JSON.parse(input);
                editor.value = JSON.stringify(parsed, null, 2);
            } catch (error) {
                // Keep original if invalid
            }
        }
        
        function highlightDifferencesInMaxView() {
            const input1 = document.getElementById('json1').value.trim();
            const input2 = document.getElementById('json2').value.trim();
            
            if (!input1 || !input2) return;
            
            try {
                let obj1 = JSON.parse(input1);
                let obj2 = JSON.parse(input2);
                
                if (currentFilter.length > 0) {
                    obj1 = filterObject(obj1, currentFilter);
                    obj2 = filterObject(obj2, currentFilter);
                }
                
                const formatted1 = JSON.stringify(obj1, null, 2);
                const formatted2 = JSON.stringify(obj2, null, 2);
                
                document.getElementById('jsonMax1').innerHTML = highlightJsonDifferences(formatted1, lastDifferences, 'old');
                document.getElementById('jsonMax2').innerHTML = highlightJsonDifferences(formatted2, lastDifferences, 'new');
            } catch (error) {
                document.getElementById('jsonMax1').textContent = input1;
                document.getElementById('jsonMax2').textContent = input2;
            }
        }
        
        function highlightJsonDifferences(jsonStr, differences, type) {
            let highlighted = jsonStr.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
            
            differences.forEach(diff => {
                const value = type === 'old' ? diff.old : diff.newVal;
                
                if (value !== undefined) {
                    const valueStr = JSON.stringify(value);
                    const escapedValue = valueStr.replace(/[.*+?^\$\{\}()|[\]\\]/g, '\\$&');
                    
                    let className = '';
                    if (diff.type === 'added' && type === 'new') className = 'diff-highlight-added';
                    else if (diff.type === 'removed' && type === 'old') className = 'diff-highlight-removed';
                    else if (diff.type === 'modified') className = 'diff-highlight-modified';
                    
                    if (className) {
                        highlighted = highlighted.replace(
                            new RegExp('(' + escapedValue + ')', 'g'),
                            '<span class="' + className + '">$1</span>'
                        );
                    }
                }
            });
            
            return highlighted;
        }
        
        function searchInEditor(editorId, searchTerm) {
            const editor = document.getElementById(editorId);
            const content = editor.value;
            const resultsId = editorId.includes('Max') ? 'searchResultsMax' + editorId.slice(-1) : 'searchResults' + editorId.slice(-1);
            const resultsSpan = document.getElementById(resultsId);
            
            if (!searchTerm) {
                resultsSpan.textContent = '';
                return;
            }
            
            const regex = new RegExp(searchTerm, 'gi');
            const matches = content.match(regex);
            const count = matches ? matches.length : 0;
            
            resultsSpan.textContent = count > 0 ? count + ' matches' : 'No matches';
            
            // Highlight first match
            if (count > 0) {
                const firstMatch = content.search(regex);
                if (firstMatch !== -1) {
                    editor.focus();
                    editor.setSelectionRange(firstMatch, firstMatch + searchTerm.length);
                }
            }
        }
        
        function searchInDiff(searchTerm) {
            const output = document.getElementById('output');
            const resultsSpan = document.getElementById('searchResultsDiff');
            
            if (!searchTerm) {
                resultsSpan.textContent = '';
                // Restore original content without highlights
                if (window.originalDiffContent) {
                    output.innerHTML = window.originalDiffContent;
                }
                return;
            }
            
            // Store original content if not already stored
            if (!window.originalDiffContent) {
                window.originalDiffContent = output.innerHTML;
            }
            
            const content = output.textContent;
            const regex = new RegExp(searchTerm, 'gi');
            const matches = content.match(regex);
            const count = matches ? matches.length : 0;
            
            resultsSpan.textContent = count > 0 ? count + ' matches' : 'No matches';
            
            // Highlight matches in the original content
            if (count > 0) {
                let highlightedContent = window.originalDiffContent;
                // Escape special regex characters in search term
                const escapedTerm = searchTerm.replace(/[.*+?^\$\{\}()|[\]\\]/g, '\\$&');
                // Highlight text content only, not HTML tags
                highlightedContent = highlightedContent.replace(
                    new RegExp('(>[^<]*?)(' + escapedTerm + ')([^<]*?<)', 'gi'),
                    '$1<mark class="highlight">$2</mark>$3'
                );
                output.innerHTML = highlightedContent;
            } else {
                output.innerHTML = window.originalDiffContent;
            }
        }

        function findDifferences(obj1, obj2, path) {
            path = path || '';
            const diffs = [];
            
            const keys1 = obj1 && typeof obj1 === 'object' ? Object.keys(obj1) : [];
            const keys2 = obj2 && typeof obj2 === 'object' ? Object.keys(obj2) : [];
            const allKeys = new Set([...keys1, ...keys2]);
            
            if (typeof obj1 !== typeof obj2) {
                diffs.push({ path: path || 'root', type: 'modified', old: obj1, newVal: obj2 });
                return diffs;
            }
            
            if (typeof obj1 !== 'object' || obj1 === null || obj2 === null) {
                if (obj1 !== obj2) {
                    diffs.push({ path: path || 'root', type: 'modified', old: obj1, newVal: obj2 });
                }
                return diffs;
            }
            
            allKeys.forEach(key => {
                const newPath = path ? path + '.' + key : key;
                const has1 = keys1.includes(key);
                const has2 = keys2.includes(key);
                
                if (has1 && !has2) {
                    diffs.push({ path: newPath, type: 'removed', old: obj1[key] });
                } else if (!has1 && has2) {
                    diffs.push({ path: newPath, type: 'added', newVal: obj2[key] });
                } else {
                    const subDiffs = findDifferences(obj1[key], obj2[key], newPath);
                    diffs.push(...subDiffs);
                }
            });
            
            return diffs;
        }

        function displayDifferences(diffs) {
            const output = document.getElementById('output');
            
            if (diffs.length === 0) {
                output.innerHTML = '<div class="summary"><strong>✓ JSONs are identical</strong></div>';
                // Clear stored original content
                window.originalDiffContent = null;
                return;
            }
            
            const added = diffs.filter(d => d.type === 'added').length;
            const removed = diffs.filter(d => d.type === 'removed').length;
            const modified = diffs.filter(d => d.type === 'modified').length;
            
            let html = '<div class="summary">';
            html += '<strong>Found ' + diffs.length + ' difference(s):</strong><br>';
            if (added) html += '<div class="summary-item"><span class="diff-added">+ ' + added + ' added</span></div>';
            if (removed) html += '<div class="summary-item"><span class="diff-removed">- ' + removed + ' removed</span></div>';
            if (modified) html += '<div class="summary-item"><span class="diff-modified">~ ' + modified + ' modified</span></div>';
            html += '</div>';
            
            diffs.forEach(diff => {
                html += '<div class="diff-line">';
                if (diff.type === 'added') {
                    html += '<span class="diff-added">+ ' + diff.path + '</span>: ' + JSON.stringify(diff.newVal);
                } else if (diff.type === 'removed') {
                    html += '<span class="diff-removed">- ' + diff.path + '</span>: ' + JSON.stringify(diff.old);
                } else {
                    html += '<span class="diff-modified">~ ' + diff.path + '</span><br>';
                    html += '  Old: ' + JSON.stringify(diff.old) + '<br>';
                    html += '  New: ' + JSON.stringify(diff.newVal);
                }
                html += '</div>';
            });
            
            output.innerHTML = html;
            // Clear stored original content to refresh it
            window.originalDiffContent = null;
        }

        function formatBoth() {
            formatJson('json1', 'status1');
            formatJson('json2', 'status2');
        }

        function formatJson(inputId, statusId) {
            const input = document.getElementById(inputId).value.trim();
            if (!input) return;

            try {
                const parsed = JSON.parse(input);
                document.getElementById(inputId).value = JSON.stringify(parsed, null, 2);
                document.getElementById(statusId).innerHTML = '<span class="valid"><i class="fas fa-check"></i> Valid</span>';
            } catch (error) {
                document.getElementById(statusId).innerHTML = '<span class="invalid"><i class="fas fa-times"></i> Invalid</span>';
            }
        }

        function clearAll() {
            document.getElementById('json1').value = '';
            document.getElementById('json2').value = '';
            document.getElementById('jsonMax1').innerHTML = 'Paste first JSON here...';
            document.getElementById('jsonMax2').innerHTML = 'Paste second JSON here...';
            document.getElementById('output').textContent = 'No comparison yet';
            document.getElementById('status1').textContent = 'Ready';
            document.getElementById('status2').textContent = 'Ready';
            document.getElementById('filterInput').value = '';
            document.getElementById('search1').value = '';
            document.getElementById('search2').value = '';
            document.getElementById('searchDiff').value = '';
            document.getElementById('searchMax1').value = '';
            document.getElementById('searchMax2').value = '';
            currentFilter = [];
            lastDifferences = [];
            window.originalDiffContent = null;
        }

        function swapJson() {
            const temp = document.getElementById('json1').value;
            document.getElementById('json1').value = document.getElementById('json2').value;
            document.getElementById('json2').value = temp;
        }

        function copyDiff() {
            const output = document.getElementById('output');
            let textToCopy;
            
            // If we have filtered differences, copy only those
            if (currentFilter.length > 0) {
                textToCopy = 'Filtered Differences (Variables: ' + currentFilter.join(', ') + ')\n\n';
                textToCopy += output.textContent;
            } else {
                textToCopy = output.textContent;
            }
            
            navigator.clipboard.writeText(textToCopy).then(() => {
                const btn = event.target.closest('button');
                const originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-check"></i> Copied!';
                setTimeout(() => btn.innerHTML = originalText, 2000);
            });
        }

        document.getElementById('json1').value = '{\n  "name": "John Doe",\n  "age": 30,\n  "city": "New York",\n  "hobbies": ["reading", "swimming"]\n}';

        document.getElementById('json2').value = '{\n  "name": "John Doe",\n  "age": 31,\n  "city": "Boston",\n  "hobbies": ["reading", "coding"]\n}';
    </script>
</body>
</html>
