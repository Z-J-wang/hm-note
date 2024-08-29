import { router } from '@kit.ArkUI';
import { EditorParams } from '../pages/Editor';
import { Note } from '../../model';

import('../pages/Editor') // 引入命名路由页面。实现命名路由跳转必须先引入目标页面

@Component
export struct Item {
  @Prop note: Note

  build() {
    Column() {
      Row() {
        Text(this.note.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')

      Row() {
        Text(this.note.createdTimeByDay).fontColor(Color.Gray)
        Divider()
          .vertical(true)
          .height(16)
          .strokeWidth(1)
          .color(Color.Gray)
          .margin({ left: 8, right: 8 })
        Text(this.note.content).fontColor(Color.Gray)
      }
      .width('100%')
      .margin({ top: 4 })
    }
    .width('100%')
    .backgroundColor(this.note.notebook.color)
    .borderRadius(10)
    .padding(10)
    .borderStyle(BorderStyle.Solid)
    .borderWidth(1)
    .borderColor(Color.Grey)
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      const params: EditorParams = {
        noteID: this.note.id,
      }
      router.pushNamedRoute({
        name: 'Editor',
        params: params
      })

    })
  }
}