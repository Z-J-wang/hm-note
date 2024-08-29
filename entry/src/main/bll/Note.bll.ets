import NoteDal from '../dal/Note.dal';
import { DefaultNotebookList } from '../utils';

import { ErrorMessage, Note } from '../model';
import NoteBook from '../model/Notebook';

export default class NoteBll {
  private static _noteDal: NoteDal = new NoteDal()
  private static _defaultNotebook = DefaultNotebookList.defaultNotebookList[0]

  static async getAll(): Promise<Note[]> {
    const notes = await NoteBll._noteDal.getAll()

    return notes
  }

  static getNote(id: string) {
    return NoteBll._noteDal.getNote(id)
  }

  static delete(id: string): Promise<Note[] | boolean | ErrorMessage> {
    if (NoteBll._noteDal.notes.findIndex(note => note.id === id) === -1) {
      Promise.reject({
        status: false,
        message: '当前ID对应的note不存在！！！'
      } as ErrorMessage)
    }

    return NoteBll._noteDal.delete(id)
  }

  static async add(title: string, content: string,
    notebook: NoteBook = NoteBll._defaultNotebook): Promise<Note[] | boolean> {
    // notes 为空，则先从数据库读取数据
    if (NoteBll._noteDal.notes.length === 0) {
      await NoteBll.getAll()
    }
    const id = (NoteBll._noteDal.notes.length + 1).toString()
    const createTime = new Date()
    const newNote = new Note(id, title, content, createTime, notebook)
    return NoteBll._noteDal.put(newNote)
  }

  static update(newNote: Note): Promise<Note[] | boolean> {
    if (NoteBll._noteDal.notes.findIndex(note => note.id === newNote.id) === -1) {
      Promise.reject({
        status: false,
        message: '当前ID对应的note不存在！！！'
      } as ErrorMessage)
    }
    newNote.createdTime = new Date() // 更新createdTime时间
    return NoteBll._noteDal.update(newNote)
  }
}