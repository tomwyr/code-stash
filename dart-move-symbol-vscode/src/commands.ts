import { moveSymbol } from "./functions/moveSymbol"
import { MoveSymbolDirection } from "./types"

export const moveSymbolUp = () => moveSymbol(MoveSymbolDirection.up)

export const moveSymbolDown = () => moveSymbol(MoveSymbolDirection.down)
