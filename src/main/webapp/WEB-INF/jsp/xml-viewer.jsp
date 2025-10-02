<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>XML Viewer</title>
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
        .nav-links a.active { color: #9C27B0; font-weight: 600; }
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
        .btn-primary { background: #9C27B0; color: white; }
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
        .xml-tree {
            font-family: 'Courier New', monospace; font-size: 13px;
            line-height: 1.6;
        }
        .xml-tag { color: #0066cc; font-weight: bold; }
        .xml-attr-name { color: #cc6600; }
        .xml-attr-value { color: #008000; }
        .xml-text { color: #333; }
        .xml-comment { color: #999; font-style: italic; }
        .xml-indent { margin-left: 20px; }
        .xml-children { margin-left: 20px; }
        .collapsible { cursor: pointer; user-select: none; }
        .collapsible:hover { background: #f0f0f0; }
        .collapsed { display: none; }
        .xpath-input {
            width: 200px; padding: 6px; border: 1px solid #ddd;
            border-radius: 4px; font-size: 0.9rem;
        }
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
                <a href="/json-viewer"><i class="fas fa-code"></i> JSON Viewer</a>
                <a href="/xml-viewer" class="active"><i class="fas fa-file-code"></i> XML Viewer</a>
            </div>
        </div>
    </nav>
    
    <div class="main-content">
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-file-code"></i> XML Viewer & Formatter</h1>
                <p>Format, validate, and explore XML documents</p>
            </div>
            
            <div class="toolbar">
                <div class="toolbar-left">
                    <button class="btn btn-primary" onclick="formatXml()">
                        <i class="fas fa-magic"></i> Format
                    </button>
                    <button class="btn btn-success" onclick="validateXml()">
                        <i class="fas fa-check-circle"></i> Validate
                    </button>
                    <button class="btn btn-warning" onclick="minifyXml()">
                        <i class="fas fa-compress"></i> Minify
                    </button>
                    <button class="btn btn-secondary" onclick="clearAll()">
                        <i class="fas fa-trash"></i> Clear
                    </button>
                    <input type="text" class="xpath-input" id="xpathInput" placeholder="XPath query...">
                    <button class="btn btn-secondary" onclick="executeXPath()">
                        <i class="fas fa-search"></i> XPath
                    </button>
                    <button class="btn btn-secondary" onclick="convertToJson()">
                        <i class="fas fa-exchange-alt"></i> To JSON
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
                    <input type="file" id="fileInput" accept=".xml" style="display:none" onchange="loadFile(event)">
                    <button class="btn btn-secondary" onclick="document.getElementById('fileInput').click()">
                        <i class="fas fa-upload"></i> Load File
                    </button>
                </div>
            </div>
            
            <div class="editor-container">
                <div class="editor-panel">
                    <div class="panel-header">
                        <span>XML Input</span>
                        <span id="inputStats">0 characters</span>
                    </div>
                    <textarea id="xmlInput" class="editor" placeholder="Paste your XML here..."></textarea>
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
        let xmlDoc = null;
        let nodeIdCounter = 0;

        document.getElementById('xmlInput').addEventListener('input', function() {
            updateStats();
            validateXml();
        });

        function updateStats() {
            const input = document.getElementById('xmlInput').value;
            const charCount = input.length;
            const byteSize = new Blob([input]).size;
            
            document.getElementById('inputStats').textContent = charCount + ' characters';
            document.getElementById('inputSize').textContent = 'Size: ' + byteSize + ' bytes';
        }

        function formatXml() {
            const input = document.getElementById('xmlInput').value.trim();
            if (!input) return;

            try {
                const parser = new DOMParser();
                xmlDoc = parser.parseFromString(input, 'text/xml');
                
                const errorNode = xmlDoc.querySelector('parsererror');
                if (errorNode) {
                    throw new Error(errorNode.textContent);
                }

                const formatted = formatXmlString(input);
                document.getElementById('output').textContent = formatted;
                document.getElementById('validationStatus').innerHTML = '<span class="valid"><i class="fas fa-check"></i> Valid XML</span>';
                document.getElementById('outputInfo').textContent = 'Formatted successfully';
                updateOutputStats(formatted);
                currentView = 'formatted';
                document.getElementById('viewToggle').textContent = 'Tree View';
            } catch (error) {
                document.getElementById('output').textContent = 'Error: ' + error.message;
                document.getElementById('validationStatus').innerHTML = '<span class="invalid"><i class="fas fa-times"></i> Invalid XML</span>';
                document.getElementById('outputInfo').textContent = 'Format failed';
            }
        }

        function formatXmlString(xml) {
            const PADDING = '  ';
            const reg = /(>)(<)(\/*)/g;
            let formatted = xml.replace(reg, '$1\r\n$2$3');
            let pad = 0;
            
            return formatted.split('\r\n').map(line => {
                let indent = 0;
                if (line.match(/.+<\/\w[^>]*>$/)) {
                    indent = 0;
                } else if (line.match(/^<\/\w/) && pad > 0) {
                    pad -= 1;
                } else if (line.match(/^<\w[^>]*[^\/]>.*$/)) {
                    indent = 1;
                } else {
                    indent = 0;
                }
                
                const padding = PADDING.repeat(pad);
                pad += indent;
                return padding + line;
            }).join('\r\n');
        }

        function validateXml() {
            const input = document.getElementById('xmlInput').value.trim();
            if (!input) {
                document.getElementById('validationStatus').textContent = 'Ready';
                return;
            }

            try {
                const parser = new DOMParser();
                const doc = parser.parseFromString(input, 'text/xml');
                const errorNode = doc.querySelector('parsererror');
                
                if (errorNode) {
                    throw new Error(errorNode.textContent);
                }
                
                document.getElementById('validationStatus').innerHTML = '<span class="valid"><i class="fas fa-check"></i> Valid XML</span>';
            } catch (error) {
                document.getElementById('validationStatus').innerHTML = '<span class="invalid"><i class="fas fa-times"></i> Invalid: ' + error.message + '</span>';
            }
        }

        function minifyXml() {
            const input = document.getElementById('xmlInput').value.trim();
            if (!input) return;

            try {
                const parser = new DOMParser();
                const doc = parser.parseFromString(input, 'text/xml');
                
                const errorNode = doc.querySelector('parsererror');
                if (errorNode) {
                    throw new Error(errorNode.textContent);
                }

                const minified = input.replace(/>\s+</g, '><').replace(/\s+/g, ' ').trim();
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
            if (!xmlDoc) {
                formatXml();
                if (!xmlDoc) return;
            }

            if (currentView === 'formatted') {
                showTreeView();
                currentView = 'tree';
                document.getElementById('viewToggle').textContent = 'XML View';
            } else {
                const formatted = formatXmlString(document.getElementById('xmlInput').value);
                document.getElementById('output').textContent = formatted;
                currentView = 'formatted';
                document.getElementById('viewToggle').textContent = 'Tree View';
            }
        }

        function showTreeView() {
            nodeIdCounter = 0;
            const treeHtml = xmlToTree(xmlDoc.documentElement);
            document.getElementById('output').innerHTML = treeHtml;
        }

        function xmlToTree(node, indent = 0) {
            let html = '';
            const indentClass = indent > 0 ? 'xml-indent' : '';
            const nodeId = 'node-' + (++nodeIdCounter);

            if (node.nodeType === Node.ELEMENT_NODE) {
                const hasChildren = node.childNodes.length > 0 && Array.from(node.childNodes).some(child => 
                    child.nodeType === Node.ELEMENT_NODE || (child.nodeType === Node.TEXT_NODE && child.textContent.trim())
                );
                
                html += '<div class="' + indentClass + '" id="' + nodeId + '">';
                if (hasChildren) {
                    html += '<span class="collapsible" onclick="toggleNode(\'' + nodeId + '\')">▼ </span>';
                } else {
                    html += '<span style="margin-left: 16px;"></span>';
                }
                html += '<span class="xml-tag">&lt;' + node.tagName + '</span>';
                
                // Attributes
                if (node.attributes.length > 0) {
                    for (let attr of node.attributes) {
                        html += ' <span class="xml-attr-name">' + attr.name + '</span>=<span class="xml-attr-value">"' + attr.value + '"</span>';
                    }
                }
                
                if (!hasChildren) {
                    html += '<span class="xml-tag">/&gt;</span>';
                } else {
                    html += '<span class="xml-tag">&gt;</span>';
                }
                html += '</div>';
                
                if (hasChildren) {
                    html += '<div class="xml-children" id="children-' + nodeId + '">';
                    // Child nodes
                    for (let child of node.childNodes) {
                        if (child.nodeType === Node.TEXT_NODE) {
                            const text = child.textContent.trim();
                            if (text) {
                                html += '<div><span class="xml-text">' + text + '</span></div>';
                            }
                        } else if (child.nodeType === Node.ELEMENT_NODE) {
                            html += xmlToTree(child, indent + 1);
                        } else if (child.nodeType === Node.COMMENT_NODE) {
                            html += '<div><span class="xml-comment">&lt;!-- ' + child.textContent + ' --&gt;</span></div>';
                        }
                    }
                    
                    html += '<div><span class="xml-tag">&lt;/' + node.tagName + '&gt;</span></div>';
                    html += '</div>';
                }
            }

            return html;
        }

        function toggleNode(nodeId) {
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
            const allChildren = document.querySelectorAll('.xml-children');
            const allToggles = document.querySelectorAll('.collapsible');
            
            allChildren.forEach(child => {
                child.style.display = 'none';
            });
            
            allToggles.forEach(toggle => {
                toggle.textContent = '▶ ';
            });
        }

        function expandAll() {
            const allChildren = document.querySelectorAll('.xml-children');
            const allToggles = document.querySelectorAll('.collapsible');
            
            allChildren.forEach(child => {
                child.style.display = 'block';
            });
            
            allToggles.forEach(toggle => {
                toggle.textContent = '▼ ';
            });
        }

        function executeXPath() {
            const xpath = document.getElementById('xpathInput').value.trim();
            if (!xpath || !xmlDoc) return;

            try {
                const result = xmlDoc.evaluate(xpath, xmlDoc, null, XPathResult.ANY_TYPE, null);
                let output = 'XPath Results:\n\n';
                let node;
                let count = 0;

                while (node = result.iterateNext()) {
                    count++;
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        output += '[' + count + '] Element: <' + node.tagName + '>\n';
                        output += '    Text: ' + node.textContent.trim() + '\n';
                    } else if (node.nodeType === Node.ATTRIBUTE_NODE) {
                        output += '[' + count + '] Attribute: ' + node.name + ' = "' + node.value + '"\n';
                    } else {
                        output += '[' + count + '] ' + node.textContent + '\n';
                    }
                }

                if (count === 0) {
                    output += 'No matches found.';
                } else {
                    output += '\nTotal matches: ' + count;
                }

                document.getElementById('output').textContent = output;
                document.getElementById('outputInfo').textContent = 'XPath executed: ' + count + ' matches';
                currentView = 'xpath';
                document.getElementById('viewToggle').textContent = 'XML View';
            } catch (error) {
                document.getElementById('output').textContent = 'XPath Error: ' + error.message;
                document.getElementById('outputInfo').textContent = 'XPath failed';
            }
        }

        function convertToJson() {
            if (!xmlDoc) {
                formatXml();
                if (!xmlDoc) return;
            }
            
            try {
                const jsonObj = xmlToJson(xmlDoc.documentElement);
                const jsonStr = JSON.stringify(jsonObj, null, 2);
                document.getElementById('output').textContent = jsonStr;
                document.getElementById('outputInfo').textContent = 'Converted to JSON successfully';
                updateOutputStats(jsonStr);
                currentView = 'json';
                document.getElementById('viewToggle').textContent = 'XML View';
            } catch (error) {
                document.getElementById('output').textContent = 'Conversion Error: ' + error.message;
                document.getElementById('outputInfo').textContent = 'JSON conversion failed';
            }
        }
        
        function xmlToJson(node) {
            let obj = {};
            
            if (node.nodeType === Node.ELEMENT_NODE) {
                // Handle attributes
                if (node.attributes.length > 0) {
                    obj['@attributes'] = {};
                    for (let attr of node.attributes) {
                        obj['@attributes'][attr.name] = attr.value;
                    }
                }
                
                // Handle child nodes
                if (node.childNodes.length > 0) {
                    for (let child of node.childNodes) {
                        if (child.nodeType === Node.TEXT_NODE) {
                            const text = child.textContent.trim();
                            if (text) {
                                if (Object.keys(obj).length === 0 || (Object.keys(obj).length === 1 && obj['@attributes'])) {
                                    return text;
                                } else {
                                    obj['#text'] = text;
                                }
                            }
                        } else if (child.nodeType === Node.ELEMENT_NODE) {
                            const childName = child.tagName;
                            const childObj = xmlToJson(child);
                            
                            if (obj[childName]) {
                                if (!Array.isArray(obj[childName])) {
                                    obj[childName] = [obj[childName]];
                                }
                                obj[childName].push(childObj);
                            } else {
                                obj[childName] = childObj;
                            }
                        }
                    }
                }
                
                return obj;
            }
            
            return null;
        }

        function clearAll() {
            document.getElementById('xmlInput').value = '';
            document.getElementById('output').textContent = '';
            document.getElementById('xpathInput').value = '';
            document.getElementById('validationStatus').textContent = 'Ready';
            document.getElementById('outputInfo').textContent = 'No output';
            updateStats();
            updateOutputStats('');
            xmlDoc = null;
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
                    document.getElementById('xmlInput').value = e.target.result;
                    updateStats();
                    validateXml();
                };
                reader.readAsText(file);
            }
        }

        function updateOutputStats(output) {
            const byteSize = new Blob([output]).size;
            document.getElementById('outputSize').textContent = 'Size: ' + byteSize + ' bytes';
        }

        // Sample XML for demo
        document.getElementById('xmlInput').value = `<?xml version="1.0" encoding="UTF-8"?>
<bookstore>
    <book id="1" category="fiction">
        <title>The Great Gatsby</title>
        <author>F. Scott Fitzgerald</author>
        <price currency="USD">12.99</price>
        <published>1925</published>
    </book>
    <book id="2" category="science">
        <title>A Brief History of Time</title>
        <author>Stephen Hawking</author>
        <price currency="USD">15.99</price>
        <published>1988</published>
    </book>
</bookstore>`;
        updateStats();
        validateXml();
    </script>
</body>
</html>