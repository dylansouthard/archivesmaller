# ArchiveSmaller

ArchiveSmaller is a macOS application designed to create backup archives of directories while excluding certain user-defined subdirectories. It's an especially useful tool for developers, enabling them to create backups of project directories while excluding large and unnecessary directories like `node_modules`, `build` folders, `.git` directories, etc.

## Features

- Easily create `.zip` archives of any directory on your system
- Exclude specific subdirectories from being archived
- Preset configurations allow you to save your exclude settings for future use

## Getting Started

### Prerequisites

- macOS 11.0 or later
- Xcode 12.0 or later

### Building the Project

1. Clone the repository to your local machine.
2. Open the `.xcodeproj` file in Xcode.
3. Choose your target device or simulator and click the Run button.

## Usage

1. Select or create a preset configuration for which directories to exclude.
2. Drag and drop the directory you wish to archive onto the application window.
3. Click on "Create .zip archive" if you want a `.zip` archive; otherwise, a copy of the directory with excluded subdirectories will be created.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue if you encounter a problem or have a feature request. If you'd like to contribute code, please open a pull request.

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. See the LICENSE file for details.


