# Issues

A simple mobile application utilizing Shorebird service for code push in Flutter. The application uses a few services that require configuration in order work correctly, namely:
- [Shorebird](https://shorebird.dev/): Code push
- [Appwrite](https://appwrite.io/): Backend
- [Google OAuth](https://developers.google.com/identity/protocols/oauth2/native-app): Authentication
- [GitHub Actions](https://docs.github.com/en/actions): CI

**The project can only be run on Android.** iOS platform was not implemented, however, it is supported by Shorebird and adding the necessary configuration should allow code push to work on iOS devices as well. For more info see https://docs.shorebird.dev/.

## Setup

In order to run the project, follow instructions described below. The setup requires configuring tools used by the application in order to run properly, and setting correct environment variables.

The project was created and tested using the following tools versions:
- Flutter: 3.13.2
- Dart: 3.1.0
- Shorebird: 0.14.6
- Appwrite: 1.1.2
- Appwrite CLI: 1.1.1
- Appwrite Functions Runtime: Dart 2.17

### Flutter
- Add `.env` file in the root directory and set the necessary environment variables.
```
APPWRITE_PROJECT_ID
APPWRITE_DATABASE_ID
APPWRITE_ISSUES_ID
APPWRITE_APP_INFO_ID
```

### Shorebird
- Login to your Shorebird account.
- Init new Shorebird project and update `shorebird.yaml` configuration.
- Authenticate with `shorebird login:ci` to obtain a CI auth token.

### Appwrite
- Create new Appwrite project.
- Register Flutter and Android platforms under **Appwrite Console > Overview > Integrations > Platforms**.
- Add API keys under **Appwrite Console > Overview > Integrations > API Keys** with the following scopes:
  - Database > documents.write
  - Functions > execution.write

#### Auth
- Enable Google auth provider under **Appwrite Console > Auth > Settings > OAuth2 Providers**.
- Register new Google Cloud application and setup OAuth client ID under **Google Cloud Console > APIs & Services > Credentials > Create Credentials > OAuth client ID**.

#### Database
- Create new database and collections matching the following schema:
```yaml
issues
  title: string
  votes: string[]

appInfo
  patchTime: datetime
```
- Assign at least the following access permissions under **Appwrite Console > Databases > *database* > *collection* > Settings > Update Permissions**:
  - issues - Users: Read, Create, Update
  - appInfo - Users: Read

#### Functions
- Init Appwrite project in the `cloud` directory using the CLI.
- Init a function called `update-patch-time` and pick Dart as the runtime.
- Deploy the function to your Appwrite instance.
- Set necessary function variables under **Appwrite Console > Functions > update-patch-time > Settings > Update Variables**.
```sh
APPWRITE_UPDATE_PATCH_TIME_KEY
APPWRITE_PROJECT_ID
APPWRITE_DATABASE_ID
APPWRITE_APP_INFO_ID
```

### GitHub Actions
- Set necessary secrets under **Settings > Secrets and variables > Actions > Secrets**.
```
ANDROID_ENCODED_KEYSTORE
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD
ANDROID_STORE_FILE
ANDROID_STORE_PASSWORD
APPWRITE_NOTIFY_UPDATE_AVAILABLE_KEY
SHOREBIRD_TOKEN
```

- Set necessary variables under **Settings > Secrets and variables > Actions > Variables**.
```sh
APPWRITE_PROJECT_ID
APPWRITE_DATABASE_ID
APPWRITE_APP_INFO_ID
APPWRITE_ISSUES_ID
APPWRITE_NOTIFY_UPDATE_AVAILABLE_ID
```

## Usage

In order to use code push for the application, first, create and upload an initial release to shorebird using the `shorebird release android` command.

After uploading the initial version, make changes to the application and publish a patch. Releasing patch can be done in either of the two ways:
- using the `shorebird patch android` command
- pushing changes to GitHub and annotating the commit with `patch#*<number>*` tag

You can also checkout commits annotated with `patch#` tags, in order to see, what changes can be released using the code push.

## Variables and secrets

The section below lists all variables and secrets defined and used in the project followed by short explanations and hints about where to get their values from.

| Name | Meaning | Location |
|---|---|---|
||
| **Appwrite** |
| `APPWRITE_PROJECT_ID` | Appwrite project ID  | Appwrite Console > Overview  Project ID |
| `APPWRITE_DATABASE_ID` | Project database ID | Appwrite Console > Databases > *database* > Database ID |
| `APPWRITE_ISSUES_ID` | Issues collection ID | Appwrite Console > Databases > *database* > issues > CollectionID |
| `APPWRITE_APP_INFO_ID` | AppInfo collection ID | Appwrite Console > Databases > *database* > appInfo > CollectionID |
| `APPWRITE_NOTIFY_UPDATE_AVAILABLE_ID` | *Notify update available* function ID | Appwrite Console > Functions > notify-update-available > Function ID |
| `APPWRITE_NOTIFY_UPDATE_AVAILABLE_KEY` | API key with permission to trigger the *notify update available* function | Appwrite Console > Overview > Integrations > API Keys > notify-update-available > API Key Secret |
| `APPWRITE_UPDATE_PATCH_TIME_KEY` | API key with permission to update the *appInfo* collection | Appwrite Console > Overview > Integrations > API Keys > update-patch-time > API Key Secret |
||
| **Android** |
| `ANDROID_ENCODED_KEYSTORE` | Keystore file containt Android app signing key encoded to base64 | Terminal > `cat <path_to_keystore> \| base64` |
| `ANDROID_STORE_FILE` | Keystore file name | The keystore file **must** be located under `android/app` directory |
| `ANDROID_STORE_PASSWORD` | Keystore password | Defined during keystore creation |
| `ANDROID_KEY_ALIAS` | Signing key alias in the keystore | Defined during keystore creation |
| `ANDROID_KEY_PASSWORD` | Signing key password in the keystore | Defined during keystore creation |
||
| **Shorebird** |
| `SHOREBIRD_TOKEN` | Shorebird auth token used in the CI workflow | Terminal > `shorebird login:ci` |
