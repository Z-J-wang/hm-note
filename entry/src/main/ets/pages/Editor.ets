/**
 * note 编辑器
 */
import { Note } from '../../model';
import { router } from '@kit.ArkUI';
import NoteBll from '../../bll/Note.bll';

export interface EditorParams {
  noteID: string
}

@Entry({ routeName: 'Editor' })
@Component
struct Editor {
  @State note: Note | null = null
  controller: RichEditorController = new RichEditorController();

  async onPageShow() {
    const params: EditorParams = router.getParams() as EditorParams
    if (params.noteID) {
      const result = await NoteBll.getNote(params.noteID)
      console.log(params.noteID)
      console.log('result', JSON.stringify(result))
      if (result instanceof Note) {
        this.note = result
      } else {
        // note 不存在重定向到首页
        router.pushUrl({
          url: "pages/Index"
        })
      }
    } else {
      router.pushUrl({
        url: "pages/Index"
      })
    }
  }

  build() {
    Column({ space: 10 }) {
      if (this.note !== null) {
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
          }

          Column() {
            Text(this.note.createdTimeByTime).fontSize(12).fontColor(Color.Gray)
          }
        }.padding(10).alignItems(HorizontalAlign.Start)

        RichEditor({ controller: this.controller }).flexGrow(1).onReady(() => {
          this.controller.addTextSpan((this.note as Note).content)
        })

        Column() {
          Text(`共 ${this.note.content.length} 字`).fontSize(12)
        }
        .padding({ bottom: 10, right: 10 })
        .width('100%')
        .alignItems(HorizontalAlign.End)
      }
    }.height('100%')
  }
}