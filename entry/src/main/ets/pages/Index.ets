import { Item, ItemData } from '../components/Item';
import { NoteBook } from '../model';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State notebooks: NoteBook[] = [new NoteBook()]

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Scroll() {
        Column() {
          Item({ data: new ItemData('明天你好！') })
          Item({ data: new ItemData('明天你好！！！', new Date(), '', new NoteBook('book1', Color.Pink)) })
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .height('100%')
        .backgroundColor('#f5f5f5')
        .padding(10)
      }

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Text() {
          SymbolSpan($r('sys.symbol.plus'))
            .fontColor([Color.White])
            .fontWeight(FontWeight.Bolder)
            .fontSize(30)
        }
      }
      .markAnchor({ x: 20, y: 50 })
      .padding(16)
      .backgroundColor(Color.Blue)
    }
    .width('100%')
    .height('100%')
  }
}