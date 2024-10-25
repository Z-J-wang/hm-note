import { Note, Notebook } from '../../model';
import NoteBookBll from '../../bll/Notebook.bll';
import { NotebookColors } from '../../utils';

@CustomDialog
export struct NotebookSettingsDialog {
  @Prop notebooks: Notebook[] = []
  @Prop note: Note
  @State addNotebook: boolean = false // 是否新增Notebook
  @State newNotebook: Notebook | null = null
  controller: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: (notebook: Notebook) => void = () => {
  }

  @Builder
  ColorSettingsBuilder() {
    GridRow({ gutter: 10 }) {
      ForEach(NotebookColors.list, (color: ResourceColor) => {
        GridCol({
          span: 3
        }) {
          Text() {
            SymbolSpan($r('sys.symbol.folder'))
              .fontSize(20).fontWeight(FontWeight.Bold)
          }.fontColor(color === Color.White ? Color.Grey : color)
        }
        .onClick(() => {
          console.log(color.toString())
          if (this.newNotebook !== null) {
            this.newNotebook.color = color
          }
        })
      }, (color: string,) => color)
    }
    .width(200)
    .padding(10)
  }

  build() {
    Column() {
      Text(this.note?.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
        .width('100%')
      // eslint-disable-next-line @hw-ets-eslint/init-list-component
      List({ space: 10 }) {
        ForEach(this.notebooks, (notebook: Notebook) => {
          ListItem() {
            Row() {
              Row() {
                Text() {
                  SymbolSpan($r('sys.symbol.folder'))
                    .fontSize(20).fontWeight(FontWeight.Bold)
                }.fontColor(notebook.color)

                Text(notebook.name).margin({ left: 10 })
              }

              Column() {
                Radio({ value: notebook.name, group: 'radioGroup' })
                  .checked(notebook.name == this.note?.notebook.name)
                  .onChange((isChecked: boolean) => {
                    if (isChecked) {
                      this.confirm(notebook)
                    }
                    this.controller.close()
                  })
              }
            }.justifyContent(FlexAlign.SpaceBetween).width('100%')
          }
        }, (item: Notebook, index: number) => item.name.toString())

        if (this.addNotebook && this.newNotebook !== null) {
          ListItem() {
            // 新增Notebook控件
            Row() {
              // 取消新增按钮
              Button({ type: ButtonType.Normal, stateEffect: true }) {
                Text() {
                  SymbolSpan($r('sys.symbol.xmark'))
                    .fontSize(20).fontWeight(FontWeight.Bold)
                }
              }
              .backgroundColor(Color.Transparent)
              .onClick(() => {
                // 取消新增，初始化addNotebook和newNotebook
                this.addNotebook = false
                this.newNotebook = null
              })

              Column() {
                Row({ space: 8 }) {
                  // notebook 颜色选择器
                  Button({ type: ButtonType.Normal, stateEffect: true }) {
                    Text() {
                      SymbolSpan($r('sys.symbol.folder'))
                        .fontSize(20).fontWeight(FontWeight.Bold)
                    }
                    .fontColor(this.newNotebook.color)
                  }
                  .bindMenu(this.ColorSettingsBuilder)
                  .backgroundColor(Color.Transparent)


                  // notebook 命名输入框
                  Column() {
                    TextInput().onChange(value => {
                      if (this.newNotebook !== null) {
                        this.newNotebook.name = value
                      }
                    })
                  }
                  .flexShrink(1)
                }.width('100%')
              }.flexShrink(1).padding({ left: 10, right: 10 })

              // 确认新增按钮
              Button({ type: ButtonType.Normal, stateEffect: true }) {
                Text() {
                  SymbolSpan($r('sys.symbol.checkmark'))
                    .fontSize(20).fontWeight(FontWeight.Bold)
                }
              }
              .backgroundColor(Color.Transparent)
              .onClick(async () => {
                // 确认新增notebook
                if (this.newNotebook === null) {
                  return
                }
                const notebooks = await NoteBookBll.add(this.newNotebook.name, this.newNotebook.color)
                this.notebooks = notebooks as Notebook[]
                // 新增成功，初始化addNotebook和newNotebook
                this.newNotebook = null
                this.addNotebook = false
              })
            }.width('100%').justifyContent(FlexAlign.SpaceBetween)

          }
        } else {
          ListItem() {
            Row() {
              Text() {
                SymbolSpan($r('sys.symbol.plus'))
                  .fontSize(20).fontWeight(FontWeight.Bold)
              }

              Text('新建').margin({ left: 10 })
            }.width('100%')
            .onClick(() => {
              this.addNotebook = true
              this.newNotebook = new Notebook('', Color.Gray)
            })
          }
        }

      }.margin({ top: 20, bottom: 20 })
      .width('100%')

    }.padding(20).width('100%')
  }
}