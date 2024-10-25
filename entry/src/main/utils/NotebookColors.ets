// notebook 可选颜色
// TODO 可选颜色还需调整

export default class NotebookColors {
  // 默认(对应未分类) 白色
  static default = Color.White
  // 默认|红|橙|黄|绿|蓝|靛|紫
  static red = '#de2a18'
  static orange = '#f97d1c'
  static blue = '#8fb2c9'
  static green = '#dfecd5'
  static yellow = '#f9e9cd'
  static indigo = '#5698c3'
  static purple = '#bc84a8'
  static list: ResourceColor[] =
    [this.red, this.orange, this.yellow, this.green, this.blue, this.indigo, this.purple, Color.White]
}