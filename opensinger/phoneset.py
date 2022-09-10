# List all phonemes from the corpus.
# Usage: edit `corpus_path` and run.


import filescan

corpus_path = 'path_to_corpus'
ext = 'lab'
phoneset = set()
for lab in filescan.scan(corpus_path, ext=ext):
    with open(lab, 'r', encoding='utf-8') as f:
        for p in f.read().split():
            phoneset.add(p)

with open('phoneset.txt', 'w', encoding='utf-8') as f:
    for p in sorted(list(phoneset)):
        print(p, file=f)
