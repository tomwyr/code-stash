import { TextDocument } from "vscode"
import {
  MoveSymbolDirection,
  RelativeSymbolSwapLines,
  SymbolSearchResult,
} from "../types"

export async function getRelativeSymbolSwapLines(
  document: TextDocument,
  searchResult: SymbolSearchResult,
  direction: MoveSymbolDirection,
): Promise<RelativeSymbolSwapLines | undefined> {
  const selectedSymbol = searchResult.searched
  const adjacentSymbol =
    direction == MoveSymbolDirection.up
      ? searchResult.previous
      : searchResult.next

  if (adjacentSymbol == undefined) return

  const swapLines = {
    selectedSymbolStart: selectedSymbol.range.start.line,
    selectedSymbolEnd: selectedSymbol.range.end.line,
    adjacentSymbolStart: adjacentSymbol.range.start.line,
    adjacentSymbolEnd: adjacentSymbol.range.end.line,
  }

  const swapLinesIncludingAnnotations = includeSymbolAnnotations(
    document,
    swapLines,
  )

  return swapLinesIncludingAnnotations
}

function includeSymbolAnnotations(
  document: TextDocument,
  moveLines: RelativeSymbolSwapLines,
): RelativeSymbolSwapLines {
  const selectedSymbolStartLineIncludingAnnotations =
    getLineIncludingAnnotations(document, moveLines.selectedSymbolStart)

  const adjacentSymbolStartLineIncludingAnnotations =
    getLineIncludingAnnotations(document, moveLines.adjacentSymbolStart)

  return {
    selectedSymbolStart: selectedSymbolStartLineIncludingAnnotations,
    selectedSymbolEnd: moveLines.selectedSymbolEnd,
    adjacentSymbolStart: adjacentSymbolStartLineIncludingAnnotations,
    adjacentSymbolEnd: moveLines.adjacentSymbolEnd,
  }
}

function getLineIncludingAnnotations(
  document: TextDocument,
  line: number,
): number {
  var annotationsLinesCount = 0

  for (let index = line - 1; index >= 0; index--) {
    const isAnnotation = document.lineAt(index).text.trimStart().startsWith("@")

    if (!isAnnotation) break

    annotationsLinesCount++
  }

  return line - annotationsLinesCount
}
