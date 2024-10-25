import NotebookColors from './NotebookColors'
import Notebook from '../model/Notebook'

/**
 * 默认Notebook列表
 */
export default class DefaultNotebookList {
  static defaultNotebookList: Notebook[] = [
    new Notebook('未分类', NotebookColors.default),
    new Notebook('个人', NotebookColors.green),
    new Notebook('生活', NotebookColors.blue),
    new Notebook('工作', NotebookColors.yellow),
  ]
}