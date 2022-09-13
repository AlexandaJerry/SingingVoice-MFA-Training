import os.path


def _get_ext(filename: str):
    if '.' not in filename:
        return ''
    else:
        return filename.rsplit('.', maxsplit=1)[-1]


def scan(root: str, ext: str):
    result = []
    root = os.path.abspath(root)
    for child in [os.path.join(root, c) for c in os.listdir(root)]:
        if os.path.isdir(child):
            result += scan(child, ext)
        elif os.path.isfile(child) and _get_ext(os.path.basename(child)) == ext:
            result.append(child)
    return result

