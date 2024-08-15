import Notebook from '../model/Notebook'

/**
 * 默认Notebook列表
 */
export default class DefaultNotebookList {
  static defaultNotebookList: Notebook[] = [
    new Notebook('未分类', Color.White),
    new Notebook('个人', '#1ba784'),
    new Notebook('生活', '#2775b6'),
    new Notebook('工作', '#de2a18'),
  ]
}