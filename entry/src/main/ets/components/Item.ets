import { NoteBook } from '../model'
import { router } from '@kit.ArkUI'
import { EditorParams } from '../pages/Editor'

import('../pages/Editor') // 引入命名路由页面。实现命名路由跳转必须先引入目标页面

export class NoteData {
  id: number | undefined = undefined
  title: string = ''
  content: string = 'Hello World!!'
  notebook: NoteBook

  constructor(id?: number, title?: string, dateTime: Date = new Date(), content: string = '',
    notebook: NoteBook = new NoteBook()) {
    id && (this.id = id)
    title && (this.title = title)
    this._createdTime = dateTime
    this.notebook = notebook || new NoteBook()
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

@Component
export struct Item {
  @Prop data: NoteData

  build() {
    Column() {
      Row() {
        Text(this.data.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')

      Row() {
        Text(this.data.createdTimeByDay).fontColor(Color.Gray)
        Divider()
          .vertical(true)
          .height(16)
          .strokeWidth(1)
          .color(Color.Gray)
          .margin({ left: 8, right: 8 })
        Text(this.data.content).fontColor(Color.Gray)
      }
      .width('100%')
      .margin({ top: 4 })
    }
    .width('100%')
    .backgroundColor(this.data.notebook.color)
    .borderRadius(10)
    .padding(10)
    .borderStyle(BorderStyle.Solid)
    .borderWidth(1)
    .borderColor(Color.Grey)
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      const params: EditorParams = {
        noteID: this.data.id as number,
      }
      router.pushNamedRoute({
        name: 'Editor',
        params: params
      })

    })
  }
}