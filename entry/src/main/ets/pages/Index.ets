import { Note, Notebook } from '../../model';
import NoteBll from '../../bll/Note.bll';
import NoteBookBll from '../../bll/Notebook.bll';
import { Item } from '../components/Item';
import { router } from '@kit.ArkUI';
import { SelectClassification } from '../components/SelectClassification';
import { NotebookSettingsDialog } from '../components/NotebookSettingsDialog';
import { JSON } from '@kit.ArkTS';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State notebooks: Notebook[] = []
  @State notes: Note[] = []
  @State searchKeyword: string = '' //
  @State value: string = ''
  @State selectedClassification: string = '' // 选择中的笔记类别
  @State count: number = 0
  noteOfNotebookSetting: Note | null = null // 正在进行归纳设置的note
  dialogController: CustomDialogController = new CustomDialogController({
    builder: NotebookSettingsDialog({
      cancel: () => {
        console.info('取消note：' + JSON.stringify(this.noteOfNotebookSetting) + '归纳操作')
        this.noteOfNotebookSetting = null // 取消归纳操作，重置noteOfNotebookSetting
      },
      confirm: (notebook: Notebook) => {
        if (this.noteOfNotebookSetting instanceof Note) { // noteOfNotebookSetting类型正确，更新数据
          this.noteOfNotebookSetting.notebook = notebook
          NoteBll.update(this.noteOfNotebookSetting).then(() => {
            this.loadNote()
            this.noteOfNotebookSetting = null // 数据更新成功，重置noteOfNotebookSetting
          })
        } else { // noteOfNotebookSetting类型错误，给出提示让用户重试 // TODO 错误弹窗待开发
        }
      },
      notebooks: this.notebooks,
      note: this.noteOfNotebookSetting as Note
    }),
    autoCancel: true,
    offset: { dx: 0, dy: -10 },
    alignment: DialogAlignment.Bottom,
  })

  loadNote() {
    this.notes = []
    return NoteBll.getAll().then(notes => {
      this.notes = notes
    })
  }

  loadNotebook() {
    this.notebooks = []
    return NoteBookBll.getAll().then(notebooks => {
      this.notebooks = notebooks
    })
  }

  filteredNotes(): Note[] {
    const filtered = this.notes.filter((note: Note) => {
      const tempString = note.title.toLowerCase() + ' ' + note.content.toLowerCase()

      // 判断note是否属于选中的类别
      const isInclude = this.selectedClassification ? this.selectedClassification === note.notebook.name : true

      // 查询关键字为空，直接返回 this.notes
      const includeKeyword = this.searchKeyword ? tempString.includes(this.searchKeyword) : true

      // TODO 优化点：命中关键字高亮
      return includeKeyword && isInclude
    })
    this.count = filtered.length
    return filtered
  }

  onPageShow(): void {
    this.loadNote()
    this.loadNotebook()
  }

  /**
   * @Builder 自定义构建函数
   * @description ListItem 右滑呼出的工具栏最近
   * @param index note 序号
   */
  @Builder
  itemEnd(note: Note) {
    Row() { // 归纳按钮
      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Text() {
          SymbolSpan($r('sys.symbol.arrow_right_folder_circle')).fontSize(20).fontWeight(FontWeight.Bold)
        }.fontColor(Color.White)
      }.padding(6).backgroundColor('#5698c3').margin(4).onClick(async () => { // 更新notebook数据
        this.dialogController.open() // notebook数据更新后再打开NotebookSetting弹窗
        await this.loadNotebook()
        this.noteOfNotebookSetting = note
      })

      // 删除按钮
      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Text() {
          SymbolSpan($r('sys.symbol.ohos_trash')).fontSize(20).fontWeight(FontWeight.Bold)
        }.fontColor(Color.White)
      }.padding(6).backgroundColor(Color.Red).margin(4).onClick(async () => { // 删除note并重新获取notes数据
        await NoteBll.delete(note.id)
        NoteBll.getAll().then(notes => {
          this.notes = notes
        })
      })
    }.padding(4).justifyContent(FlexAlign.SpaceEvenly)
  }

  @Builder
  SearchControl() {
    Row() {
      Search({
        placeholder: '搜索笔记'
      })
    }
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Scroll() {
        Column() {
          SelectClassification({
            notebooks: this.notebooks, number: this.count, change: (value) => {
              this.selectedClassification = value
            }
          })

          this.SearchControl()

          Row() {
            List({ space: 10 }) {
              ForEach(this.filteredNotes(), (note: Note) => {
                ListItem() {
                  Item({ note: note })
                }.swipeAction({
                  end: {
                    builder: () => {
                      this.itemEnd(note)
                    },
                  }
                })
              })
            }
          }.flexShrink(1)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .height('100%')
        .backgroundColor('#f5f5f5')
        .padding(10)
      }

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Text() {
          SymbolSpan($r('sys.symbol.plus')).fontColor([Color.White]).fontWeight(FontWeight.Bolder).fontSize(20)
        }
      }.markAnchor({ x: 20, y: 50 }).padding(10).backgroundColor(Color.Blue).onClick(() => {
        router.pushUrl({
          url: 'pages/Editor'
        })
      })

    }.width('100%').height('100%')
  }
}