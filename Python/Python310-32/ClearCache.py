import shutil
import sys
import os


def remove_cache(root):
    for child in os.listdir(root):
        child_root = os.path.join(root, child)
        if os.path.isdir(child_root):
            # Python3 会生成 __pycache__ 文件夹，因此直接删除整个文件夹即可
            if child == '__pycache__':
                print(f'remove {child_root}')
                shutil.rmtree(child_root)
            # 非 __pycache__ 文件夹则递归搜索子目录
            else:
                remove_cache(child_root)
        elif os.path.isfile(child_root):
            # 匹配后缀 pyc/pyo
            if child.endswith(('.pyc', '.pyo')):
                py_path = os.path.join(root, child.rsplit('.', 1)[0] + '.py')
                # 如果匹配到的 pyc/pyo 文件有对应的 py 文件，则删除 pyc/pyo
                # 这里的判断主要是避免部分特殊的 package 只发布 pyc文件导致误删除的情况发生
                if os.path.isfile(py_path):
                    print(f'remove {child_root} because {py_path} exists')
                    os.remove(child_root)


if __name__ == '__main__':
    
    path_need_to_remove = sys.argv[1]
    remove_cache(path_need_to_remove)