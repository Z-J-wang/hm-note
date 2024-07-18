import { NoteBook } from '../model'

export class ItemData {
  title: string
  createdTime: string
  content: string = 'Hello World!!'
  notebook: NoteBook

  constructor(title: string, dateTime: Date = new Date(), content: string = '', notebook: NoteBook = new NoteBook()) {
    this.title = title
    this.createdTime = `${dateTime.getMonth()}月${dateTime.getDay()}日`
    this.notebook = notebook || new NoteBook()
  }
}

@Component
export struct Item {
  @Prop data: ItemData

  build() {
    Column() {
      Row() {
        Text(this.data.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')

      Row() {
        Text(this.data.createdTime).fontColor(Color.Gray)
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
  }
}