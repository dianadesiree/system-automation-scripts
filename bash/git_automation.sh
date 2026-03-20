#!/bin/bash

# Git Automation Script
# Author: Diana Araujo
# Description: Automated git operations with status reporting

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_PATH=${1:-$(pwd)}
BRANCH=${2:-"main"}
COMMIT_MSG=${3:-"Auto-commit: $(date +'%Y-%m-%d %H:%M:%S')"}

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if we're in a git repository
check_git_repo() {
    cd "$REPO_PATH" || exit 1
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_status "$RED" "❌ Not a git repository: $REPO_PATH"
        exit 1
    fi
    
    print_status "$GREEN" "✅ Git repository found: $REPO_PATH"
}

# Function to get repository status
get_repo_status() {
    print_status "$BLUE" "📊 Repository Status:"
    
    # Get current branch
    local current_branch=$(git branch --show-current)
    print_status "$YELLOW" "   Branch: $current_branch"
    
    # Check for changes
    if git diff --quiet && git diff --cached --quiet; then
        print_status "$GREEN" "   Working tree: Clean"
    else
        local changes=$(git status --porcelain | wc -l)
        print_status "$YELLOW" "   Working tree: $changes change(s) pending"
    fi
    
    # Check for remote updates
    git fetch --quiet
    local local_commits=$(git rev-list HEAD..origin/$current_branch 2>/dev/null | wc -l)
    local remote_commits=$(git rev-list origin/$current_branch..HEAD 2>/dev/null | wc -l)
    
    if [ "$local_commits" -gt 0 ]; then
        print_status "$YELLOW" "   Updates: $local_commits commit(s) to pull"
    fi
    
    if [ "$remote_commits" -gt 0 ]; then
        print_status "$YELLOW" "   Updates: $remote_commits commit(s) to push"
    fi
}

# Function to auto-commit changes
auto_commit() {
    print_status "$BLUE" "💾 Committing changes..."
    
    # Add all changes
    git add -A
    
    # Check if there's anything to commit
    if git diff --cached --quiet; then
        print_status "$GREEN" "   No changes to commit"
        return 0
    fi
    
    # Commit changes
    if git commit -m "$COMMIT_MSG"; then
        print_status "$GREEN" "✅ Changes committed: $COMMIT_MSG"
        return 0
    else
        print_status "$RED" "❌ Commit failed"
        return 1
    fi
}

# Function to push changes
auto_push() {
    print_status "$BLUE" "📤 Pushing to remote..."
    
    local current_branch=$(git branch --show-current)
    
    if git push origin "$current_branch"; then
        print_status "$GREEN" "✅ Changes pushed to origin/$current_branch"
        return 0
    else
        print_status "$RED" "❌ Push failed"
        return 1
    fi
}

# Function to pull updates
auto_pull() {
    print_status "$BLUE" "📥 Pulling updates from remote..."
    
    local current_branch=$(git branch --show-current)
    
    if git pull origin "$current_branch"; then
        print_status "$GREEN" "✅ Updates pulled from origin/$current_branch"
        return 0
    else
        print_status "$RED" "❌ Pull failed"
        return 1
    fi
}

# Main execution
main() {
    echo ""
    echo "========================================"
    echo "   GIT AUTOMATION SCRIPT"
    echo "========================================"
    echo ""
    
    # Check repository
    check_git_repo
    
    # Show status
    get_repo_status
    echo ""
    
    # Ask for action
    echo "Select action:"
    echo "1) Auto-commit only"
    echo "2) Commit and push"
    echo "3) Pull updates"
    echo "4) Full sync (pull, commit, push)"
    echo "5) Show status only"
    echo ""
    read -p "Choice [1-5]: " choice
    
    case $choice in
        1)
            auto_commit
            ;;
        2)
            auto_commit && auto_push
            ;;
        3)
            auto_pull
            ;;
        4)
            auto_pull && auto_commit && auto_push
            ;;
        5)
            # Status already shown
            print_status "$GREEN" "✅ Status check complete"
            ;;
        *)
            print_status "$RED" "❌ Invalid choice"
            exit 1
            ;;
    esac
    
    echo ""
    echo "========================================"
    echo "   OPERATION COMPLETED"
    echo "========================================"
}

# Run main function
main