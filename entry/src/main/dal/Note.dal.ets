import { ErrorMessage, Note, Notebook } from '../model';
import { DefaultNotebookList, KvmUtil } from '../utils';
import { BusinessError } from '@kit.BasicServicesKit';

export default class NoteDal {
  // kv 的 key
  private _kvKey: string = 'notes'

  constructor() {
    this.getAll()
  }

  private _notes: Note[] = []

  public get notes(): Note[] {
    return this._notes
  }

  public getNote(id: string): Promise<Note | ErrorMessage> {
    if (this._notes.findIndex(note => note.id === id) === -1) {
      Promise.reject({
        status: false,
        message: '当前ID对应的note不存在！！！'
      } as ErrorMessage)
    }
    return Promise.resolve(this._notes.find(note => note.id === id) as Note)
  }

  /**
   * 新增
   * @param note
   * @returns
   */
  public async put(note: Note) {
    const newNotes = this._notes.slice() // 复制数组
    newNotes.push(note)
    try {
      KvmUtil.put(this._kvKey, JSON.stringify(newNotes)) // kv数据库
      this._notes = newNotes
      return newNotes
    } catch (e) {
      console.log('e', JSON.stringify(e))
      return false
    }
  }

  /**
   * 更新
   * @param newNote
   * @returns
   */
  public async update(newNote: Note) {
    const newNotes = this._notes.slice() // 复制数组
    const index = this._notes.findIndex(note => note.id === newNote.id)
    newNotes.splice(index, 1, newNote) // 替换指定元素
    try {
      await KvmUtil.put(this._kvKey, JSON.stringify(this._notes)) // kv数据库
      this._notes = newNotes
      return newNotes
    } catch (e) {
      return false
    }
  }

  /**
   * 删除
   * @param id
   * @returns
   */
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

  /**
   * 获取全部
   * @returns
   */
  public async getAll(): Promise<Note[]> {
    try {
      const result = await KvmUtil.getData(this._kvKey)
      if (typeof result === 'object') {
        // result 类型为 object，则数据库操作错误
        if ((result as BusinessError).code === 15100004) {
          // 错误类型为：key 不存在。则初始kv数据库
          const initNote =
            new Note('1', '欢迎使用Note', "欢迎使用Note", new Date(), DefaultNotebookList.defaultNotebookList[0])
          this.put(initNote)
          return [initNote]
        } else {
          // 其他错误类型 直接返回数组
          return []
        }
      } else {
        if (typeof result !== 'string') {
          // 存储的数据类型错误，初始化数据库数据
          return []
        } else {
          this._notes = []
          for (let item of JSON.parse(result) as Note[]) {
            const notebook = item.notebook as Notebook
            this._notes.push(new Note(item.id, item.title, item.content, new Date(item.createdTime),
              new Notebook(notebook.name, notebook.color)))
          }
        }
        return this._notes
      }
    } catch (e) {
      console.log('e', e)
      return []
    }
  }
}