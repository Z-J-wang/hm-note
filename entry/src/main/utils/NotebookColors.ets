// notebook 可选颜色
// TODO 可选颜色还需调整

export default class NotebookColors {
  // 默认(对应未分类) 白色
  static default = Color.White
  // 默认|红|橙|黄|绿|蓝|靛|紫
  static red = '#FF8A80'
  static orange = '#FFECB3'
  static blue = '#BBDEFB'
  static green = '#dfecd5'
  static yellow = '#FFF9C4'
  static indigo = '#E0F2F1'
  static purple = '#D1C4E9'
  static list: ResourceColor[] =
    [this.red, this.orange, this.yellow, this.green, this.blue, this.indigo, this.purple, Color.White]
}