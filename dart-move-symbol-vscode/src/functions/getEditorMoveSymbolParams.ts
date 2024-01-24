import { TextDocument } from "vscode"
import {
  getMoveSymbolParams,
  getSymbolSwapLines,
  getRelativeSymbolSwapLines,
} from "."
import {
  MoveSymbolDirection,
  MoveSymbolParams,
  SymbolSearchResult,
} from "../types"

export async function getEditorMoveSymbolParams(
  document: TextDocument,
  searchResult: SymbolSearchResult,
  direction: MoveSymbolDirection,
): Promise<MoveSymbolParams | undefined> {
  const relativeSwapLines = await getRelativeSymbolSwapLines(
    document,
    searchResult,
    direction,
  )
  if (relativeSwapLines == undefined) return

  const swapLines = getSymbolSwapLines(relativeSwapLines, direction)

  const moveParams = getMoveSymbolParams(swapLines)

  return moveParams
}
