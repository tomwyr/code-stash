# Code Connect

The repository contains software that together builds the Code Connect application.

![1](https://github.com/tomwyr/code-connect/assets/9600796/aeedc79d-54b0-4a91-8999-e7169c4b7a87)

The project consists of three main sub-modules:

- backend - Shelf application providing core functionalities of the system.
- frontend - Flutter multiplatform application allowing users interact with the system.
- common - Dart library housing elements of the system shared by the frontend and the backend.

## Frontend

### Env vars

Environment variables that the app requires to run:

## Backend

Environment variables that the app requires to run:

- **API_BASE_URL** - Url of the deployed backend application.
- **PROJECT_REPO_URL** - Url pointing to this project repository.

### Env vars

Environment variables that the app requires to run:

- **PORT** - The port on which the application should listen for incoming requests.
- **OPENAI_API_KEY** - A secret key to access the OpenAI api. Can be found or created in your OpenAI account under the [API keys](https://platform.openai.com/api-keys) section.
- **GITHUB_API_KEY** - An api key to access the GitHub api. Can be created in your GitHub account under the [Personal access tokens](https://github.com/settings/tokens) section.
