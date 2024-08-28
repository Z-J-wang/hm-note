/**
 * @class 笔记本类
 */
export default class NoteBook {
  // 笔记本名
  name: string = ''
  // 笔记本颜色
  color: ResourceColor = Color.White

  constructor(name: string, color: ResourceColor) {
    this.name = name
    this.color = color
  }
}