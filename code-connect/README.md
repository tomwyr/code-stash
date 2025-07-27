# Code Connect

The repository contains software that together builds the Code Connect application.

![ss](https://github.com/tomwyr/playground/assets/9600796/c132cf0d-f9eb-40ba-aaa8-61eca7b4d14c)

The project consists of three main sub-modules:

- backend - Shelf application providing core functionalities of the system.
- frontend - Flutter multiplatform application allowing users interact with the system.
- common - Dart library housing elements of the system shared by the frontend and the backend.

## Deployment

The project uses [Globe](globe.dev) as the deployment platform for both, the backend and the frontend application. For more information head to Globe's [documentation](https://docs.globe.dev/).

## Frontend

### Env vars

Environment variables that the app requires to run:

- **API_BASE_URL** - Url of the deployed backend application.
- **PROJECT_REPO_URL** - Url pointing to this project repository.

## Backend

### Env vars

Environment variables that the app requires to run:

- **PORT** - The port on which the application should listen for incoming requests.
- **OPENAI_API_KEY** - A secret key to access the OpenAI api. Can be found or created in your OpenAI account under the [API keys](https://platform.openai.com/api-keys) section.
- **GITHUB_API_KEY** - An api key to access the GitHub api. Can be created in your GitHub account under the [Personal access tokens](https://github.com/settings/tokens) section.
