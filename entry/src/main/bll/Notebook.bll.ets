import NotebooksDal from '../dal/Notebooks.dal';

import { ErrorMessage, Notebook } from '../model';

export default class NotebookBll {
  private static _notebookDal: NotebooksDal = new NotebooksDal()

  static async getAll(): Promise<Notebook[]> {
    const notebooks = await NotebookBll._notebookDal.getAll()
    return notebooks.sort((a: Notebook, b: Notebook) => {
      // 默认未分类排在最后，其余的按文本升序排序
      if (a.name === '未分类') {
        return 1
      } else if (b.name === '未分类') {
        return -1
      } else {
        return a.name.localeCompare(b.name)
      }
    })
  }

  static async add(name: string, color: ResourceColor): Promise<Notebook[] | boolean> {
    const newNotebook = new Notebook(name, color)
    return NotebookBll._notebookDal.put(newNotebook)
  }

  static delete(name: string): Promise<Notebook[] | ErrorMessage | false> {
    if (NotebookBll._notebookDal.notebooks.findIndex(note => note.name === name) === -1) {
      Promise.reject({
        status: false,
        message: '当前name对应的notebook不存在！！！'
      } as ErrorMessage)
    }

    return NotebookBll._notebookDal.delete(name)
  }
}