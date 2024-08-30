/**
 * note 编辑器
 */
import { Note } from '../../model';
import { router } from '@kit.ArkUI';
import NoteBll from '../../bll/Note.bll';
import { DefaultNotebookList } from '../../utils';

export interface EditorParams {
  noteID: string
}

@Entry({ routeName: 'Editor' })
@Component
struct Editor {
  @State note: Note = new Note('', '', '', new Date(), DefaultNotebookList.defaultNotebookList[0])
  controller: TextAreaController = new TextAreaController()

  // 页面离开，存储数据
  onPageHide(): void {
    if (this.note.id) {
      NoteBll.update(this.note)
    } else if (this.note.title && this.note.content) {
      NoteBll.add(this.note.title, this.note.content, this.note.notebook)
    }
  }

  async onPageShow() {
    const params: EditorParams = router.getParams() as EditorParams
    if (params.noteID) {
      const result = await NoteBll.getNote(params.noteID)
      if (result instanceof Note) {
        this.note = result
      } else {
        // note 不存在重定向到首页
        router.pushUrl({
          url: "pages/Index"
        })
      }
    }
  }

  build() {
    Column({ space: 10 }) {
      Column() {
        Column() {
          Button({ buttonStyle: ButtonStyleMode.TEXTUAL, role: ButtonRole.NORMAL }) {
            Text() {
              SymbolSpan($r('sys.symbol.arrow_left')).fontSize(16).fontWeight(FontWeight.Bold)
            }
          }.padding(6).margin({
            left: -6
          })
          .onClick(() => {
            router.back()
          })
        }

        Column() {
          TextInput({ placeholder: '标题', text: this.note.title })
            .padding({ left: 0 })
            .backgroundColor(Color.Transparent)
            .onChange((value: string) => {
              this.note.title = value
            })
        }

        Column() {
          Text(this.note.createdTimeByTime).fontSize(12).fontColor(Color.Gray)
        }
      }.padding(10).alignItems(HorizontalAlign.Start)

      Scroll() {
        TextArea({
          text: this.note.content,
          controller: this.controller
        }).height('100%')
          .backgroundColor(Color.White)
          .onChange((value: string) => {
            this.note.content = value
          })
      }.flexGrow(1)
      .flexShrink(1)

      Column() {
        Text(`共 ${this.note.content.length} 字`).fontSize(12)
      }
      .padding({ bottom: 10, right: 10 })
      .width('100%')
      .alignItems(HorizontalAlign.End)
    }.height('100%')
  }
}