import { Notebook } from '../../model';

export interface ClassificationOption {
  value: string
}


@Component
export struct SelectClassification {
  @Prop @Watch('onNotebooksUpdated') notebooks: Notebook[]
  @State options: ClassificationOption[] = []
  @State number: number = 0
  change: (value: string) => void = (value: string) => {
  }

  // @Watch 回调
  onNotebooksUpdated(propName: string): void {
    this.options = [{ value: '全部分类' }, ...this.notebooks.map(notebook => {
      return {
        value: notebook.name
      } as ClassificationOption
    })]
  }

  onPageShow(): void {
    this.options = [{ value: '全部分类' }, ...this.notebooks.map(notebook => {
      return {
        value: notebook.name
      } as ClassificationOption
    })]
  }

  build() {
    Column() {

      Row() {
        Select(this.options)
          .value(this.options[0]?.value)
          .selected(0)
          .optionWidth('100%')
          .backgroundColor(Color.Transparent)
          .onSelect((i, value) => {
            this.change(value === '全部分类' ? '' : value)
          })
      }

      Row() {
        Text() {
          Span(this.number.toString())
          Span(' ')
          Span('条笔记').padding({ left: 5 })
        }.fontSize(12).fontColor(Color.Grey)
      }
    }
  }
}