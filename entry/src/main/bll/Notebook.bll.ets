import NotebooksDal from '../dal/Notebooks.dal';

import { ErrorMessage, Notebook } from '../model';

function handleSort(a: Notebook, b: Notebook) {
  // 默认未分类排在最后，其余的按文本升序排序
  if (a.name === '未分类') {
    return 1
  } else if (b.name === '未分类') {
    return -1
  } else {
    return a.name.localeCompare(b.name)
  }
}

export default class NotebookBll {
  private static _notebookDal: NotebooksDal = new NotebooksDal()

  static async getAll(): Promise<Notebook[]> {
    const notebooks = await NotebookBll._notebookDal.getAll()
    return notebooks.sort(handleSort)
  }

  static async add(name: string, color: ResourceColor): Promise<Notebook[] | boolean> {
    const newNotebook = new Notebook(name, color)
    const res = await NotebookBll._notebookDal.put(newNotebook)
    return typeof res !== 'boolean' ? res.sort(handleSort) : res
  }

  static async delete(name: string): Promise<Notebook[] | ErrorMessage | false> {
    if (NotebookBll._notebookDal.notebooks.findIndex(note => note.name === name) === -1) {
      Promise.reject({
        status: false,
        message: '当前name对应的notebook不存在！！！'
      } as ErrorMessage)
    }

    const res = await NotebookBll._notebookDal.delete(name)
    return typeof res !== 'boolean' ? res.sort(handleSort) : res
  }
}