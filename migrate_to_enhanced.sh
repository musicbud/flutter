#!/bin/bash

# MusicBud Flutter - Enhanced Library Migration Script
# This script automates the migration from old widget imports to the enhanced library

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║     MusicBud Enhanced Library Migration Script              ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counter for changes
TOTAL_FILES=0
TOTAL_CHANGES=0

echo "Starting migration..."
echo ""

# Function to replace imports in files
replace_imports() {
    local file="$1"
    local changes=0
    
    # Backup original file
    cp "$file" "$file.backup"
    
    # Replace old widget imports with enhanced library import
    if grep -q "import.*widgets/common\|import.*widgets/cards\|import.*widgets/buttons" "$file"; then
        # Add enhanced library import at the top if not present
        if ! grep -q "import.*widgets/enhanced/enhanced_widgets.dart" "$file"; then
            # Find the last import line
            last_import=$(grep -n "^import" "$file" | tail -1 | cut -d: -f1)
            if [ ! -z "$last_import" ]; then
                sed -i "${last_import}a import '../../../presentation/widgets/enhanced/enhanced_widgets.dart';" "$file"
                ((changes++))
            fi
        fi
        
        # Comment out old imports (don't delete in case needed for reference)
        sed -i "s|^\(import '.*widgets/common/\)|// MIGRATED: \1|g" "$file"
        sed -i "s|^\(import '.*widgets/cards/\)|// MIGRATED: \1|g" "$file"
        sed -i "s|^\(import '.*widgets/buttons/\)|// MIGRATED: \1|g" "$file"
        
        ((changes++))
    fi
    
    # If changes were made, keep the modified file; otherwise restore backup
    if [ $changes -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Migrated: $file ($changes changes)"
        rm "$file.backup"
        return 1
    else
        mv "$file.backup" "$file"
        return 0
    fi
}

# Migrate presentation/screens directory
echo "📁 Migrating screens..."
while IFS= read -r file; do
    ((TOTAL_FILES++))
    if replace_imports "$file"; then
        :
    else
        ((TOTAL_CHANGES++))
    fi
done < <(find lib/presentation/screens -name "*.dart" -type f 2>/dev/null)

# Migrate presentation/pages directory  
echo ""
echo "📁 Migrating pages..."
while IFS= read -r file; do
    ((TOTAL_FILES++))
    if replace_imports "$file"; then
        :
    else
        ((TOTAL_CHANGES++))
    fi
done < <(find lib/presentation/pages -name "*.dart" -type f 2>/dev/null)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}✓${NC} Migration complete!"
echo ""
echo "📊 Summary:"
echo "   Files processed: $TOTAL_FILES"
echo "   Files modified: $TOTAL_CHANGES"
echo ""
echo "⚠️  Note: Old imports have been commented out (not deleted)"
echo "   Review the changes and run 'flutter analyze' to verify"
echo ""
echo "🔄 To rollback changes, run:"
echo "   find lib -name '*.dart.backup' -exec sh -c 'mv \"\$1\" \"\${1%.backup}\"' _ {} \\;"
echo ""
echo "🧹 To clean up backup files after verification:"
echo "   find lib -name '*.dart.backup' -delete"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
