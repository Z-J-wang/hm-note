import { CircleShape, IconType } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Stack({alignContent: Alignment.BottomEnd }) {
      Column(){
        Text(this.message)
      }
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .height('100%')

      Button({type: ButtonType.Circle, stateEffect: true}){
       Text(){
         SymbolSpan($r('sys.symbol.plus'))
           .fontColor([Color.White])
           .fontWeight(FontWeight.Bolder)
           .fontSize(30)
       }
      }
      .markAnchor({x: 20, y: 50})
      .padding(16)
      .backgroundColor(Color.Blue)
    }
    .width('100%')
    .height('100%')
  }
}