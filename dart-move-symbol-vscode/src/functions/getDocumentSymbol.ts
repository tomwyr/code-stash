import { commands, DocumentSymbol, TextDocument } from "vscode"

export function getDocumentSymbols(
  document: TextDocument,
): Thenable<DocumentSymbol[] | undefined> {
  return commands.executeCommand<DocumentSymbol[]>(
    "vscode.executeDocumentSymbolProvider",
    document.uri,
  )
}
