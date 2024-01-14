# Late Checker

The latest version of the app is available and can be accessed [here](https://late-checker.onrender.com/).

Due to the current hosting setup, the initial load can take up to one minute.

## Configuration
Update `config.yaml` file with the necessary configuration:
* clientId - Twitch app client ID (can be found in [Twitch dev console](https://dev.twitch.tv/console/apps/)).
* secret - Twitch app client secret (can be found in [Twitch dev console](https://dev.twitch.tv/console/apps/)).

## Gradle Tasks

### Running
* jsRun - Starts a webpack dev server on port 3000
* jvmRun - Starts a dev server on port 8080
### Packaging
* jsBrowserWebpack - Bundles the compiled js files into `build/dist/js/productionExecutable`
* jsJar - Packages a standalone "web" frontend jar with all required files into `build/libs/*.jar`
* jvmJar - Packages a backend jar with compiled source files into `build/libs/*.jar`
* jar - Packages a "fat" jar with all backend sources and dependencies while also embedding frontend resources into `build/libs/*.jar`
