import { MoveSymbolParams, SymbolSwapLines } from "../types"

export function getMoveSymbolParams(
  swapLines: SymbolSwapLines,
): MoveSymbolParams {
  const bottomSymbolNewStartLine = swapLines.bottomSymbolNewStart

  const bottomSymbolSpan = {
    start: swapLines.bottomSymbolStart,
    end: swapLines.bottomSymbolEnd + 1,
  }

  const blankSpaceSpan = {
    start: swapLines.blankSpaceStart + 1,
    end: bottomSymbolSpan.start,
  }

  const selectedSymbolDelta =
    swapLines.selectedSymbolDeltaStart - swapLines.selectedSymbolDeltaEnd

  const selectedSymbolNewStartLine =
    swapLines.selectedSymbolStart + selectedSymbolDelta

  return {
    bottomSymbolNewStartLine: bottomSymbolNewStartLine,
    bottomSymbolSpan: bottomSymbolSpan,
    blankSpaceSpan: blankSpaceSpan,
    selectedSymbolDelta: selectedSymbolDelta,
    selectedSymbolNewStartLine: selectedSymbolNewStartLine,
  }
}
