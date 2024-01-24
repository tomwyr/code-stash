import { window } from "vscode"
import {
  findSelectedSymbol,
  getDocumentSymbols,
  getEditorMoveSymbolParams,
  moveEditorSymbol,
} from "."
import { MoveSymbolDirection } from "../types"

export async function moveSymbol(direction: MoveSymbolDirection) {
  const editor = window.activeTextEditor
  if (editor == undefined) return

  const document = editor.document
  const selection = editor.selection

  const documentSymbols = await getDocumentSymbols(document)
  if (documentSymbols == undefined) return

  const symbolSearchResult = findSelectedSymbol(selection, documentSymbols)
  if (symbolSearchResult == undefined) return

  const moveSymbolParams = await getEditorMoveSymbolParams(
    document,
    symbolSearchResult,
    direction,
  )
  if (moveSymbolParams == undefined) return

  moveEditorSymbol(editor, moveSymbolParams)
}
