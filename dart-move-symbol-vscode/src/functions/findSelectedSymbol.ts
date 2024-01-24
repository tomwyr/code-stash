import { DocumentSymbol, Selection } from "vscode"
import { SymbolSearchResult } from "../types"

export function findSelectedSymbol(
  selection: Selection,
  documentSymbols: DocumentSymbol[],
): SymbolSearchResult | undefined {
  if (documentSymbols.length == 0) return

  let searchedSymbol: DocumentSymbol | undefined
  let previousSymbol: DocumentSymbol | undefined
  let nextSymbol: DocumentSymbol | undefined

  for (let index = 0; index < documentSymbols.length; index++) {
    const symbol = documentSymbols[index]

    const isAfterSelection = symbol.range.start.line > selection.end.line
    if (isAfterSelection) break

    const matchesSelection =
      selection.start.line >= symbol.range.start.line &&
      selection.end.line <= symbol.range.end.line
    if (!matchesSelection) continue

    searchedSymbol = symbol
    if (index > 0) {
      previousSymbol = documentSymbols[index - 1]
    }
    if (index < documentSymbols.length - 1) {
      nextSymbol = documentSymbols[index + 1]
    }

    break
  }

  if (searchedSymbol == undefined) return

  const childrenSearchResult = findSelectedSymbol(
    selection,
    searchedSymbol.children,
  )

  const searchResult = {
    searched: searchedSymbol,
    previous: previousSymbol,
    next: nextSymbol,
  }

  return childrenSearchResult ?? searchResult
}
