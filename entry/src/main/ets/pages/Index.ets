import { Note, Notebook } from '../../model';
import NoteBll from '../../bll/Note.bll';
import NoteBookBll from '../../bll/Notebook.bll';
import { Item } from '../components/Item';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State notebooks: Notebook[] = []
  @State notes: Note[] = []
  @State value: string = ''

  onPageShow(): void {
    NoteBll.getAll().then(notes => {
      this.notes = notes
    })

    NoteBookBll.getAll().then(notebooks => {
      this.notebooks = notebooks
    })
  }

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
            ForEach(this.notes, (note: Note, index: number) => {
              ListItem() {
                Item({ note: note })
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
            .fontSize(20)
        }
      }
      .markAnchor({ x: 20, y: 50 })
      .padding(10)
      .backgroundColor(Color.Blue)
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      router.pushUrl({
        url: 'pages/Editor'
      })
    })
  }
}