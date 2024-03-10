# Code Connect

The repository contains software that together builds the Code Connect application.

The project consists of three main sub-modules:

- backend - Shelf application providing core functionalities of the system.
- frontend - Flutter multiplatform application allowing users interact with the system.
- common - Dart library housing elements of the system shared by the frontend and the backend.

## Frontend

### Env vars

The environment variables need to be stored in `.environment` file in order to work properly. It is due to the deployment configuration currently not being able to build the app with a default `.env` file placed in the root directory.
