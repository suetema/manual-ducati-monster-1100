(function () {
  var input   = document.getElementById('search-input');
  var toc     = document.getElementById('toc-content');
  var results = document.getElementById('search-results');
  var index   = null;

  fetch('search-index.json')
    .then(function (r) { return r.json(); })
    .then(function (data) { index = data; });

  input.addEventListener('input', function () {
    var q = this.value.trim().toLowerCase();

    if (!q) {
      toc.style.display = '';
      results.style.display = 'none';
      results.innerHTML = '';
      return;
    }

    if (!index) return;

    toc.style.display = 'none';

    var words = q.split(/\s+/).filter(Boolean);

    var scored = index.map(function (entry) {
      var tl = entry.title.toLowerCase();
      var tx = entry.text.toLowerCase();
      var score = 0;
      words.forEach(function (w) {
        if (tl.indexOf(w) !== -1) score += 10;
        if (tx.indexOf(w) !== -1) score += 1;
      });
      return { e: entry, score: score };
    }).filter(function (r) { return r.score > 0; })
      .sort(function (a, b) { return b.score - a.score; })
      .slice(0, 30);

    if (scored.length === 0) {
      results.innerHTML = '<p style="color:#777;font-size:11px;padding:6px 2px">No results</p>';
    } else {
      var html = '';
      scored.forEach(function (r) {
        var e   = r.e;
        var href = e.file + (e.anchor ? '#' + e.anchor : '');

        var snippet = '';
        var w0 = words[0];
        var ti = e.text.toLowerCase().indexOf(w0);
        if (ti !== -1) {
          var start = Math.max(0, ti - 25);
          snippet = e.text.substring(start, ti + 70).trim()
            .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
          if (snippet.length > 90) snippet = snippet.substring(0, 90) + '…';
        }

        html += '<div style="border-bottom:1px solid #2a2a2a;padding:5px 2px">'
          + '<a href="' + href + '" target="main" '
          + 'style="color:#ddd;font-size:11px;font-weight:bold;display:block;'
          + 'text-decoration:none;line-height:1.3">' + e.title + '</a>';
        if (snippet) {
          html += '<span style="color:#666;font-size:10px">…' + snippet + '…</span>';
        }
        html += '</div>';
      });
      results.innerHTML = html;
    }
    results.style.display = '';
  });
}());
