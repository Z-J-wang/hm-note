import { Item, NoteData } from '../components/Item';
import { NoteBook } from '../model';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State notebooks: NoteBook[] = [new NoteBook()]
  @State notes: NoteData[] = [
    new NoteData(1, '明天你好！'),
    new NoteData(2, '明天你好！！！', new Date(), '', new NoteBook('book1', Color.Pink))
  ]

  /**
   * @Builder 自定义构建函数
   * @description ListItem 右滑呼出的工具栏最近
   * @param index note 序号
   */
  @Builder
  itemEnd(index: number) {
    Row() {
      // 归纳按钮
      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Text() {
          SymbolSpan($r('sys.symbol.arrow_right_folder_circle'))
            .fontSize(20).fontWeight(FontWeight.Bold)
        }.fontColor(Color.White)
      }.padding(6).backgroundColor('#5698c3').margin(4)
      .onClick(() => {
        // TODO 归纳相关逻辑，更新note数据
        console.log(index.toString())
      })

      // 删除按钮
      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Text() {
          SymbolSpan($r('sys.symbol.ohos_trash')).fontSize(20).fontWeight(FontWeight.Bold)
        }.fontColor(Color.White)
      }.padding(6).backgroundColor(Color.Red).margin(4)
      .onClick(() => {
        // TODO 删除相关逻辑，更新note数据
      })
    }.padding(4).justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Scroll() {
        Column() {
          List({ space: 10 }) {
            ForEach(this.notes, (item: NoteData, index: number) => {
              ListItem() {
                Item({ data: item })
              }.swipeAction({
                end: {
                  builder: () => {
                    this.itemEnd(index)
                  },
                }
              })
            })
          }
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