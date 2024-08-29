import Notebook from './Notebook'

/**
 * @class 笔记类
 */
export default class Note {
  id: string
  title: string
  content: string
  createdTime: Date
  notebook: Notebook

  constructor(id: string, title: string, content: string, createdTime: Date,
    notebook: Notebook) {
    this.id = id
    this.title = title
    this.content = content
    this.createdTime = createdTime
    this.notebook = notebook
  }

  /**
   * 获取note创建更新时间，格式：MM月DD日
   * @returns {string} MM月DD日
   */
  public get createdTimeByDay(): string {
    return `${this.createdTime?.getMonth()}月${this.createdTime?.getDay()}日`
  }

  /**
   * 获取note创建更新时间，格式：MM月DD日 hh:mm:ss
   * @returns {string} MM月DD日 hh:mm:ss
   */
  public get createdTimeByTime(): string {
    return `${this.createdTime?.getMonth()}月${this.createdTime?.getDay()}日 ${this.createdTime?.toLocaleTimeString([],
      {
        timeStyle: "short",
      })}`
  }
}