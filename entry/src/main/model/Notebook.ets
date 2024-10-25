/**
 * @class 笔记本类
 */
export default class NoteBook {
  constructor(name: string, color: ResourceColor) {
    this._name = name
    this._color = color
  }

  // 笔记本名
  private _name: string = ''

  public get name(): string {
    return this._name
  }

  public set name(value: string) {
    this._name = value
  }

  // 笔记本颜色
  private _color: ResourceColor = Color.Gray

  public get color(): ResourceColor {
    return this._color
  }

  public set color(value: ResourceColor) {
    this._color = value
  }

  public toString(): string {
    return JSON.stringify({
      name: this.name,
      color: this.color
    })
  }
}
