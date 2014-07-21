var elCode = document.querySelector('pre').innerText, trimmed;
trimmed = elCode.trim();
document.querySelector('pre').innerText = trimmed;

var codeLen = trimmed.split(/\r\n|\r|\n/).length
    , iterator = '' 
;

for (var i = 1; i <= codeLen; i++) {
    iterator += i + '\n';		
}

document.querySelector('#numbers').innerText = iterator;

hljs.highlightBlock(document.querySelector('pre'));
