# Late Checker

![ss](https://github.com/tomwyr/playground/assets/9600796/dd37135b-0109-4a30-8de2-26972f551237)

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
