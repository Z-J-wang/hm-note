/**
 * note 编辑器
 */
import { NoteData } from '../components/Item'
import { router } from '@kit.ArkUI'

export interface EditorParams {
  noteID: number
}

@Entry({ routeName: 'Editor' })
@Component
struct Editor {
  @State noteID: number = 0
  @State noteData: NoteData = new NoteData()
  controller: RichEditorController = new RichEditorController();

  onPageShow(): void {
    const params: EditorParams = router.getParams() as EditorParams
    if (params.noteID) {
      this.noteID = params.noteID
      this.noteData = new NoteData(this.noteID, '明天你好！')
    }
  }

  build() {
    Column({ space: 10 }) {
      Column() {
        Column() {
          TextInput({ placeholder: '标题' }).padding({ left: 0 })
        }

        Column() {
          Text(this.noteData.createdTimeByTime).fontSize(12).fontColor(Color.Gray)
        }
      }.padding(10).alignItems(HorizontalAlign.Start)

      RichEditor({ controller: this.controller }).flexGrow(1).onReady(() => {
        this.controller.addTextSpan(this.noteData.content)
      })

      Column() {
        Text(`共 ${this.noteData.content.length} 字`).fontSize(12)
      }
      .padding({ bottom: 10, right: 10 })
      .width('100%')
      .alignItems(HorizontalAlign.End)
    }.height('100%')
  }
}