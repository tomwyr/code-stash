import { Position, Range, Selection, TextEditor } from "vscode"
import { MoveSymbolParams, Span } from "../types"

export function moveEditorSymbol(editor: TextEditor, params: MoveSymbolParams) {
  moveSymbolText(editor, params)
  moveSymbolSelection(editor, params)
  updateVisibleRange(editor, params)
}

function moveSymbolText(editor: TextEditor, params: MoveSymbolParams) {
  const bottomSymbolRange = getSpanRange(params.bottomSymbolSpan)
  const blankSpaceRange = getSpanRange(params.blankSpaceSpan)
  const bottomSymbolNewPosition = getLinePosition(
    params.bottomSymbolNewStartLine,
  )

  const symbolText = editor.document.getText(bottomSymbolRange)
  const blankText = editor.document.getText(blankSpaceRange)

  editor.edit((editBuilder) => {
    editBuilder.delete(bottomSymbolRange)
    editBuilder.delete(blankSpaceRange)
    editBuilder.insert(bottomSymbolNewPosition, symbolText)
    editBuilder.insert(bottomSymbolNewPosition, blankText)
  })
}

function getSpanRange(span: Span): Range {
  return new Range(new Position(span.start, 0), new Position(span.end, 0))
}

function getLinePosition(line: number): Position {
  return new Position(line, 0)
}

function moveSymbolSelection(editor: TextEditor, params: MoveSymbolParams) {
  const anchor = editor.selection.anchor
  const active = editor.selection.active

  const newAnchor = new Position(
    anchor.line + params.selectedSymbolDelta,
    anchor.character,
  )
  const newActive = new Position(
    active.line + params.selectedSymbolDelta,
    active.character,
  )

  editor.selection = new Selection(newAnchor, newActive)
}

function updateVisibleRange(editor: TextEditor, params: MoveSymbolParams) {
  const documentEndLine = editor.document.lineCount - 1

  const visibleStartLine = editor.visibleRanges[0].start.line
  const visibleEndLine =
    editor.visibleRanges[editor.visibleRanges.length - 1].end.line

  const newStartLine = params.selectedSymbolNewStartLine

  const lineNextToFirstVisible = visibleStartLine + 1
  const linePriorToLastVisible = visibleEndLine - 1

  const isNewStartLineInVisibleRange =
    newStartLine >= lineNextToFirstVisible &&
    newStartLine <= linePriorToLastVisible
  if (isNewStartLineInVisibleRange) return

  const visibleRangeSpan = visibleEndLine - visibleStartLine

  const targetStartLine =
    newStartLine < lineNextToFirstVisible
      ? Math.max(newStartLine - 1, 0)
      : Math.min(newStartLine + 1 - visibleRangeSpan, documentEndLine)

  const targetEndLine = targetStartLine + visibleRangeSpan

  const targetRange = new Range(
    new Position(targetStartLine, 0),
    new Position(targetEndLine, 0),
  )

  editor.revealRange(targetRange)
}
