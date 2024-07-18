export class NoteBook {
  name: string = '' // 笔记本名
  color: ResourceColor = Color.White // 笔记本颜色

  constructor(name: string = '', color: ResourceColor = Color.White) {
    this.name = name
    this.color = color
  }
}