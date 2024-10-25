import KvmUtil from './KvmUtil'
import DefaultNotebookList from './DefaultNotebookList'

import NotebookColors from './NotebookColors'
import { Note, Notebook } from '../model'

type List = Note | Notebook

function toStringList(items: List[]) {
  return JSON.stringify(items.map((item: List): string => item.toString()))
}

export { KvmUtil, DefaultNotebookList, NotebookColors, toStringList }