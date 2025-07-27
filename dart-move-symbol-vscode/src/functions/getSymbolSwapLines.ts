import {
  SymbolSwapLines,
  MoveSymbolDirection,
  RelativeSymbolSwapLines,
} from "../types"

export function getSymbolSwapLines(
  swapLines: RelativeSymbolSwapLines,
  direction: MoveSymbolDirection,
): SymbolSwapLines {
  return direction == MoveSymbolDirection.up
    ? {
        bottomSymbolNewStart: swapLines.adjacentSymbolStart,
        bottomSymbolStart: swapLines.selectedSymbolStart,
        bottomSymbolEnd: swapLines.selectedSymbolEnd,
        blankSpaceStart: swapLines.adjacentSymbolEnd,
        selectedSymbolStart: swapLines.selectedSymbolStart,
        selectedSymbolDeltaStart: swapLines.adjacentSymbolStart,
        selectedSymbolDeltaEnd: swapLines.selectedSymbolStart,
      }
    : {
        bottomSymbolNewStart: swapLines.selectedSymbolStart,
        bottomSymbolStart: swapLines.adjacentSymbolStart,
        bottomSymbolEnd: swapLines.adjacentSymbolEnd,
        blankSpaceStart: swapLines.selectedSymbolEnd,
        selectedSymbolStart: swapLines.selectedSymbolStart,
        selectedSymbolDeltaStart: swapLines.adjacentSymbolEnd,
        selectedSymbolDeltaEnd: swapLines.selectedSymbolEnd,
      }
}
