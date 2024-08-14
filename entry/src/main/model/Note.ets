import Notebook from './Notebook'

/**
 * @class 笔记类
 */
export default class Note {
  id: number | undefined = undefined
  title: string = ''
  content: string = 'Hello World!!'
  notebook: Notebook

  constructor(id?: number, title?: string, dateTime: Date = new Date(), content: string = '',
    notebook: Notebook = new Notebook()) {
    id && (this.id = id)
    title && (this.title = title)
    this._createdTime = dateTime
    this.notebook = notebook || new Notebook()
    content && (this.content = content)
  }

  private _createdTime: Date

  public get createdTime(): Date {
    return this._createdTime
  }

  public get createdTimeByDay(): string {
    return `${this._createdTime.getMonth()}月${this._createdTime.getDay()}日`
  }

  public get createdTimeByTime(): string {
    return `${this._createdTime.getMonth()}月${this._createdTime.getDay()}日 ${this._createdTime.toLocaleTimeString([],
      {
        timeStyle: "short",
      })}`
  }
}