export type Result<T> =
  | { type: "success"; value: T }
  | { type: "error"; value: object }
  | { type: "unknown"; value: any };

export function parseResult<T extends {}>(resultString: string): Result<T>;

export function parseResult(
  resultString: string,
  options: { discardData: true }
): Result<void>;

export function parseResult<T extends {}>(
  resultString: string,
  options: ParseResultOptions = { discardData: false }
): Result<T> | Result<void> {
  let resultData = JSON.parse(resultString);
  if ("success" in resultData) {
    return {
      type: "success",
      value: options.discardData ? undefined : resultData["success"],
    };
  }

  if ("error" in resultData) {
    return { type: "error", value: resultData["error"] };
  }

  return { type: "unknown", value: resultData };
}

export type ParseResultOptions = {
  discardData: boolean;
};
