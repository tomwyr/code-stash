# Git Branch Cleaner

Git Branch Cleaner is a command-line utility designed to help clean up branches in git repositories. It identifies and removes branches that are no longer needed based on their commit history. If a branch hasn't been merged directly into another (reference) branch, the tool flags it for cleanup, if the commit messages suggest it's been merged with a merge commit.

## Features

- **Find Branches**: Identify branches that can be cleaned up.
- **Remove Branches**: Clean up the identified branches from the repository.
- **Custom Configurations**: Configure branch cleaning strategies and parameters.

## Installation

To install `git_branch_cleaner`, download the latest release from the [Releases](https://github.com/tomwyr/git_branch_cleaner/releases) section on GitHub. Extract the executable and place it in your desired directory.

## Usage

Run the executable `gbc` with the desired command and options:

```sh
gbc <command> <options>
```

### Commands

#### Find Branches

Scan the current working directory (cwd) for local git branches that have been merged into the reference branch and can be safely removed. This command will NOT delete any branches.

```sh
gbc find [options]
```

#### Remove Branches

Remove the local git branches in the cwd that have been merged into the reference branch. This command WILL delete the found branches.

```sh
gbc remove [options]
```

#### Help

Display help information:

```sh
gbc help
```

### Command Options

- `--max-depth <number>`: Number of commits of the reference branch history to check for common history between cleaned up branches and the reference branch. Defaults to 100. Applies in: `find`, `remove`.
- `--ref-branch <branch>`: Name of the branch that cleaned up branches are merged into. Defaults to "main". Applies in: `find`, `remove`.
- `--verbose`: Show additional output for commands.

## Contributing

Contributions are welcome. Please fork the repository and create a pull request with your changes. For any issues or suggestions, please visit the Issues section on GitHub to report and open issues.

## License

This project is licensed under the MIT License.
