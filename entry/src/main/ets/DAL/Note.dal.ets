import { Note, Notebook } from '../../model';
import { KvmUtil } from '../../utils';

export default class Notes {
  // kv 的 key
  private _kvKey: string = 'notes'

  constructor() {
    this.getAll()
  }

  private _notes: Note[] = []

  public get notes(): Note[] {
    return this._notes
  }

  public async put(note: Note) {
    const newNotes = this._notes.slice() // 复制数组
    newNotes.push(note)
    try {
      await KvmUtil.put(this._kvKey, JSON.stringify(this._notes)) // kv数据库
      this._notes = newNotes
      return newNotes
    } catch (e) {
      return false
    }
  }

  public async delete(id: string) {
    try {
      const newNotes = this._notes.filter(note => note.id !== id) // 过滤出要删除的note
      await KvmUtil.put(this._kvKey, JSON.stringify(newNotes)) // 更新数据到kv
      this._notes = newNotes // 覆盖_notes
      return newNotes
    } catch (e) {
      return false // 数据库操作失败，返回false
    }
  }

  public async getAll() {
    try {
      const dataString = await KvmUtil.getData(this._kvKey)
      if (typeof dataString !== 'string') {
        // 存储的数据类型错误，初始化数据库数据
        return []
      } else {
        for (let item of JSON.parse(dataString) as Note[]) {
          const notebook = item.notebook as Notebook
          this._notes.push(new Note(item.id, item.title, item.createdTime, item.content,
            new Notebook(notebook.name, notebook.color)))
        }
      }
      return this._notes
    } catch (e) {
      return false
    }
  }
}