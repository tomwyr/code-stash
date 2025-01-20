import * as vscode from "vscode";
import { Result } from "../ffi/result";

export function handleDefault<T>(
  result: Result<T>,
  options: HandleResultOptions
) {
  switch (result.type) {
    case "success":
      /* noop */
      break;
    case "error":
      onError(result.value, options.errorTitle);
      break;
    case "unknown":
      onUnknown(result.value);
      break;
  }
}

type HandleResultOptions = {
  errorTitle: string;
};

async function onError(error: object, title: string) {
  const moreItem = "More info";

  const item = await showError(title, moreItem);
  switch (item) {
    case moreItem:
      showError(title, {
        modal: true,
        detail: JSON.stringify(error),
      });
      break;
  }
}

function onUnknown(result: any) {
  showWarning(`Unexpected result received: ${result}`);
}

export const showInfo = vscode.window.showInformationMessage;
export const showWarning = vscode.window.showWarningMessage;
export const showError = vscode.window.showErrorMessage;
export const showPicker = vscode.window.showQuickPick;
