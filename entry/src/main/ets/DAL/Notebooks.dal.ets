import { Notebook } from '../../model';
import { DefaultNotebookList, KvmUtil } from '../../utils';

export default class Notebooks {
  // kv 的 key
  private _kvKey: string = 'notebook'

  constructor() {
    this.getAll().then(async () => {
      // 如果kv数据库不存在notebook数据，则初始化notebooks数据
      if (!this._notebooks.length) {
        this._init()
      }
    })
  }

  private _notebooks: Notebook[] = []

  public get notebooks(): Notebook[] {
    return this._notebooks
  }

  public async put(notebook: Notebook) {
    const newNotebooks = this._notebooks.slice() // 复制数组
    newNotebooks.push(notebook)
    try {
      await KvmUtil.put(this._kvKey, JSON.stringify(this._notebooks)) // 更新数据到kvthis.notebooks = newNotebooks
      this._notebooks = newNotebooks
      return newNotebooks
    } catch (e) {
      return false
    }
  }

  public async delete(name: string) {
    try {
      const newNotebooks = this._notebooks.filter(notebook => notebook.name !== name) // 过滤出要删除的notebook
      await KvmUtil.put(this._kvKey, JSON.stringify(this._notebooks)) // 更新数据到kv
      this._notebooks = newNotebooks // 覆盖_notebooks
      return newNotebooks
    } catch (e) {
      return false // 数据库操作失败，返回false
    }
  }

  private async getAll() {
    try {
      const dataString = await KvmUtil.getData(this._kvKey)
      if (typeof dataString !== 'string') {
        // 存储的数据类型错误，初始化数据库数据
        this._init()
      } else {
        for (let item of JSON.parse(dataString) as Notebook[]) {
          this._notebooks.push(new Notebook(item.name, item.color))
        }
      }
      return this._notebooks
    } catch (e) {
      return false
    }
  }

  /**
   * 初始化数据库的Notebooks
   */
  private async _init() {
    // 读取defaultNotebookList并存入数据库
    const newNotebooks = DefaultNotebookList.defaultNotebookList
    await KvmUtil.put(this._kvKey, JSON.stringify(newNotebooks))
  }
}