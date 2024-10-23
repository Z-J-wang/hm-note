import { Note, Notebook } from '../../model';
import NoteBookBll from '../../bll/Notebook.bll';

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

  build() {
    Column() {
      Text('这是自定义弹窗')
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
                  .checked(true)
                  .onChange((isChecked: boolean) => {
                    console.log('Radio1 status is ' + isChecked)
                  })
              }
            }.justifyContent(FlexAlign.SpaceBetween).width('100%')
          }
        }, (item: string, index: number) => index.toString())

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

        ListItem() {
          // 新增Notebook控件
          Row() {
            Button({ type: ButtonType.Normal, stateEffect: true }) {
              Text() {
                SymbolSpan($r('sys.symbol.xmark'))
                  .fontSize(20).fontWeight(FontWeight.Bold)
              }
            }
            .backgroundColor(Color.Transparent)
            .onClick(() => {
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
                }
                .backgroundColor(Color.Transparent)


                // notebook 命名输入框
                Column() {
                  TextInput()
                }
                .flexShrink(1)
              }.width('100%')
            }.flexShrink(1).padding({ left: 10, right: 10 })

            Button({ type: ButtonType.Normal, stateEffect: true }) {
              Text() {
                SymbolSpan($r('sys.symbol.checkmark'))
                  .fontSize(20).fontWeight(FontWeight.Bold)
              }
            }
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              // 确认新增notebook
              this.addNotebook = false
              if (this.newNotebook === null) {
                return
              }
              NoteBookBll.add(this.newNotebook.name, this.newNotebook.color)
            })
          }.width('100%').justifyContent(FlexAlign.SpaceBetween)
        }

      }.margin({ top: 20, bottom: 20 })
      .width('100%')

      Button('点我关闭弹窗')
        .onClick(() => {
          if (this.controller != undefined) {
            this.controller.close()
          }
        })
    }.padding(20).width('100%')
  }
}