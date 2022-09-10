# Reduce the phoneme sequences to pinyin sequences.
# Dependencies: this script requires pypinyin.
# Usage: edit `corpus_root` and `reduced_root` and run.


import os.path

from pypinyin import lazy_pinyin, pinyin as full_pinyin, Style

import filescan
from trie import Trie

tree = Trie()
mapping = {}
corpus_root = 'path_to_corpus'
reduced_root = 'path_to_reduced'


def build_tree(rules):
    for rule in rules:
        tree.store(rule[1:], rule[0])


def build_mapping(rules):
    for rule in rules:
        mapping[rule[0]] = rule[1:]


def reduce(transcription, phonemes):
    warning = None
    pinyin = lazy_pinyin(transcription)
    counts = [len(mapping[syllable]) for syllable in pinyin]
    if sum(counts) != len(phonemes):
        # fix missing last vowel
        if len(full_pinyin(transcription[-1], style=Style.NORMAL, heteronym=True)[0]) > 1:
            warning = f'Warning: fixed with a heteronym: "{transcription}({pinyin[-1]})"'
        phonemes.append(mapping[pinyin[-1]][-1])
    result = []
    idx = 0
    for count in counts:
        result.append(tree.search(phonemes[idx: idx + count]))
        idx += count
    return result, warning


def main():
    with open('mapping.txt', 'r', encoding='utf8') as f:
        lines = f.read().splitlines()
    rules = [line.split(' ') for line in lines]
    build_tree(rules)
    build_mapping(rules)
    for lab in filescan.scan(corpus_root, ext='lab'):
        path = os.path.dirname(lab)
        name = os.path.basename(lab).rsplit('.', maxsplit=1)[0]
        with open(lab, 'r', encoding='utf-8') as f:
            phonemes = f.read().split()
        while '<EOS>' in phonemes:
            phonemes.remove('<EOS>')
        txt = os.path.join(path, f'{name}.txt')
        with open(txt, 'r', encoding='utf8') as f:
            transcriptions = f.read().strip()
        try:
            pinyin, warning = reduce(transcriptions, phonemes)
            if warning is not None:
                print(f'[{lab}] {warning}')
        except Exception as e:
            print(f'Error reducing "{lab}"')
            raise e
        new_path = path.replace(corpus_root, reduced_root)
        os.makedirs(new_path, exist_ok=True)
        with open(os.path.join(new_path, f'{name}.txt'), 'w', encoding='utf8') as f:
            f.write(' '.join(pinyin))


if __name__ == '__main__':
    main()
