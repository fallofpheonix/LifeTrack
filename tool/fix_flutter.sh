#!/bin/bash
echo "Attempting to fix Flutter SDK permissions..."

FLUTTER_PATH="/Users/fallofpheonix/development/flutter"

if [ -d "$FLUTTER_PATH" ]; then
    echo "Found Flutter at $FLUTTER_PATH"
    
    # Try to change ownership to current user
    sudo chown -R $(whoami) "$FLUTTER_PATH"
    
    # Try to fix permissions
    chmod -R u+w "$FLUTTER_PATH"
    
    # Remove the lock file if it exists
    rm -f "$FLUTTER_PATH/bin/cache/lockfile"
    rm -f "$FLUTTER_PATH/bin/cache/engine.stamp"
    
    echo "Permissions fix attempted. Please try running 'flutter doctor' now."
else
    echo "Flutter SDK not found at $FLUTTER_PATH"
fi
