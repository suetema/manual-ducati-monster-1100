#!/usr/bin/env python3
import os, json, re
from html.parser import HTMLParser

class TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self._parts = []
        self._skip = False
    def handle_starttag(self, tag, attrs):
        if tag.lower() in ('script', 'style'):
            self._skip = True
    def handle_endtag(self, tag):
        if tag.lower() in ('script', 'style'):
            self._skip = False
    def handle_data(self, data):
        if not self._skip:
            s = data.strip()
            if s:
                self._parts.append(s)
    def get_text(self):
        return ' '.join(self._parts)

script_dir = os.path.dirname(os.path.abspath(__file__))

with open(os.path.join(script_dir, 'toc.js'), encoding='utf-8') as f:
    toc_js = f.read()

entries = re.findall(
    r'new Array\("(\d+)",\s*"([^"]+)",\s*"([^"]+)",\s*"([^"]*)"\)',
    toc_js
)

text_cache = {}
index = []

for idx, etype, title, link in entries:
    if not link or etype == 'paragrafo_0':
        continue

    filename = link.split('#')[0]
    anchor   = link.split('#')[1] if '#' in link else ''

    if filename not in text_cache:
        fp = os.path.join(script_dir, filename)
        if os.path.exists(fp):
            with open(fp, encoding='utf-8', errors='ignore') as f:
                ex = TextExtractor()
                ex.feed(f.read())
                text_cache[filename] = ex.get_text()
        else:
            text_cache[filename] = ''

    index.append({
        'title':  title,
        'file':   filename,
        'anchor': anchor,
        'text':   text_cache[filename],
    })

out = os.path.join(script_dir, 'search-index.json')
with open(out, 'w', encoding='utf-8') as f:
    json.dump(index, f, ensure_ascii=False)

print(f'Built {len(index)} entries from {len(text_cache)} pages -> {out}')
