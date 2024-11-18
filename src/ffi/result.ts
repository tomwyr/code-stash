export type Result<T> =
  | { type: "success"; value: T }
  | { type: "error"; value: object }
  | { type: "unknown"; value: any };

export function parseResult<T>(resultString: string): Result<T> {
  let resultData = JSON.parse(resultString);
  if ("success" in resultData) {
    return { type: "success", value: resultData["success"] as T };
  }
  if ("error" in resultData) {
    return { type: "error", value: resultData["error"] };
  }
  return { type: "unknown", value: resultData };
}
