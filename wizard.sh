#!/bin/bash

PROGRAM_NAME="impzy"
BINARY_FILE="./impzy"
INSTALL_DIR="$HOME/.local/share/$PROGRAM_NAME"

install_program() {
  # Create the installation directory if it doesn't exist
  if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
  fi
  # Copy the binary file to the installation directory
  cp "$BINARY_FILE" "$INSTALL_DIR/$PROGRAM_NAME"
  # Add the path to PATH in .zshrc if it's not already added
  if ! grep -q "export PATH=\"$INSTALL_DIR:\$PATH\"" "$HOME/.zshrc"; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$HOME/.zshrc"
    echo "Added $INSTALL_DIR to PATH in .zshrc"
  else
    echo "Path '$INSTALL_DIR' is already in PATH"
  fi
  echo "Program '$PROGRAM_NAME' has been installed in '$INSTALL_DIR'"
}

uninstall_program() {
  # Remove the installation directory
  if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
  fi
  # Remove the PATH line in .zshrc if it exists
  if grep -q "export PATH=\"$INSTALL_DIR:\$PATH\"" "$HOME/.zshrc"; then
    # sed -i "/export PATH=\"$INSTALL_DIR:\$PATH\"/d" "$HOME/.zshrc"
    sed -i "\#export PATH=\"$INSTALL_DIR:\$PATH\"#d" "$HOME/.zshrc"
    echo "Removed $INSTALL_DIR from PATH in .zshrc"
  else
    echo "Path '$INSTALL_DIR' is not in PATH"
  fi
  echo "Program '$PROGRAM_NAME' has been uninstalled"
}

# Check the argument passed to the script
if [ "$1" == "install" ]; then
  install_program
elif [ "$1" == "uninstall" ]; then
  uninstall_program
else
  echo "Usage: $0 {install|uninstall}"
fi
