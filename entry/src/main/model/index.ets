import Note from './Note'
import Notebook from './Notebook'

// 操作错误类
interface ErrorMessage {
  status: boolean,
  message: string
}

export { Note, Notebook, ErrorMessage }