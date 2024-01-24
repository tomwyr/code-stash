import { DocumentSymbol } from "vscode"

export enum MoveSymbolDirection {
  up,
  down,
}

export type SymbolSearchResult = {
  searched: DocumentSymbol
  previous: DocumentSymbol | undefined
  next: DocumentSymbol | undefined
}

export type RelativeSymbolSwapLines = {
  selectedSymbolStart: number
  selectedSymbolEnd: number
  adjacentSymbolStart: number
  adjacentSymbolEnd: number
}

export type SymbolSwapLines = {
  bottomSymbolNewStart: number
  bottomSymbolStart: number
  bottomSymbolEnd: number
  blankSpaceStart: number
  selectedSymbolStart: number
  selectedSymbolDeltaStart: number
  selectedSymbolDeltaEnd: number
}

export type Span = {
  start: number
  end: number
}

export type MoveSymbolParams = {
  bottomSymbolNewStartLine: number
  bottomSymbolSpan: Span
  blankSpaceSpan: Span
  selectedSymbolDelta: number
  selectedSymbolNewStartLine: number
}
