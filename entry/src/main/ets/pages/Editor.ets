/**
 * note 编辑器
 */
import { Note, Notebook } from '../../model';
import { LengthMetrics, router, SymbolGlyphModifier } from '@kit.ArkUI';
import NoteBll from '../../bll/Note.bll';
import { DefaultNotebookList } from '../../utils';
import NoteBookBll from '../../bll/Notebook.bll';

export interface EditorParams {
  noteID: string
}

interface NotebookOptions {
  value: string,
  symbolIcon: SymbolGlyphModifier,
  notebook: Notebook
}

@Entry({ routeName: 'Editor' })
@Component
struct Editor {
  @State notebookOpts: NotebookOptions[] = []
  @State note: Note = new Note('', '', '', new Date(), DefaultNotebookList.defaultNotebookList[0])
  controller: TextAreaController = new TextAreaController()

  loadNotebookOptions() {
    this.notebookOpts = []
    return NoteBookBll.getAll().then(notebooks => {
      this.notebookOpts = notebooks.map(notebook => {
        const icon: SymbolGlyphModifier =
          new SymbolGlyphModifier($r('sys.symbol.folder')).fontColor([notebook.color]);
        return {
          value: notebook.name,
          symbolIcon: icon,
          notebook
        } as NotebookOptions
      })
    })
  }

  async loadNote(noteID: string) {
    const result = await NoteBll.getNote(noteID)
    if (result instanceof Note) {
      this.note = result
    } else {
      // note 不存在重定向到首页
      router.pushUrl({
        url: "pages/Index"
      })
    }
  }

  // 页面离开，存储数据
  onPageHide(): void {
    if (this.note.id) {
      NoteBll.update(this.note)
    } else if (this.note.title && this.note.content) {
      NoteBll.add(this.note.title, this.note.content, this.note.notebook)
    }
  }

  onPageShow() {
    const params: EditorParams = router.getParams() as EditorParams
    this.loadNotebookOptions()
    if (params.noteID) {
      this.loadNote(params.noteID)
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

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(10) } }) {
          Text(this.note.createdTimeByTime).fontSize(12).fontColor(Color.Gray)

          Select(this.notebookOpts)
            .selected(this.notebookOpts.findIndex((notebook: NotebookOptions) => notebook.value ===
            this.note.notebook.name))
            .value(this.note.notebook.name)
            .controlSize(ControlSize.SMALL)
            .backgroundColor(this.note.notebook.color)
            .selectedOptionBgColor(Color.White)
            .onSelect((i) => {
              // 更新note的notebook
              this.note.notebook = this.notebookOpts[i].notebook
              NoteBll.update(this.note)
            })
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