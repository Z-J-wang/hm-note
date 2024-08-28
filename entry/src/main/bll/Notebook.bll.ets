import NotebooksDal from '../dal/Notebooks.dal';

import { ErrorMessage, Notebook } from '../model';

export default class NotebookBll {
  private static _notebookDal: NotebooksDal = new NotebooksDal()

  static getAll(): Promise<Notebook[]> {
    return NotebookBll._notebookDal.getAll()
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