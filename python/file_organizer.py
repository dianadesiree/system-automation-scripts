#!/usr/bin/env python3
"""
File Organizer Script
Author: Diana Araujo
Description: Automatically organizes files in a directory by their extensions
"""

import os
import shutil
import argparse
from datetime import datetime
import json
from pathlib import Path

class FileOrganizer:
    """Organizes files into folders based on file types"""
    
    # Define file categories and their extensions
    FILE_CATEGORIES = {
        'Images': ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg', '.ico'],
        'Documents': ['.pdf', '.docx', '.doc', '.txt', '.xlsx', '.pptx', '.md'],
        'Archives': ['.zip', '.rar', '.7z', '.tar', '.gz'],
        'Audio': ['.mp3', '.wav', '.flac', '.aac', '.ogg'],
        'Video': ['.mp4', '.avi', '.mkv', '.mov', '.wmv'],
        'Code': ['.py', '.js', '.html', '.css', '.java', '.cpp', '.json'],
        'Executables': ['.exe', '.msi', '.bat', '.sh', '.ps1'],
        'Others': []
    }
    
    def __init__(self, target_directory, organize_by_date=False):
        self.target_directory = Path(target_directory)
        self.organize_by_date = organize_by_date
        self.stats = {
            'files_moved': 0,
            'categories': {},
            'errors': []
        }
        
    def get_category(self, file_extension):
        """Determine the category based on file extension"""
        file_extension = file_extension.lower()
        for category, extensions in self.FILE_CATEGORIES.items():
            if file_extension in extensions:
                return category
        return 'Others'
    
    def organize_files(self):
        """Main method to organize files"""
        if not self.target_directory.exists():
            raise Exception(f"Directory {self.target_directory} does not exist")
        
        print(f"📁 Organizing files in: {self.target_directory}")
        
        # Process each file in the directory
        for item in self.target_directory.iterdir():
            if item.is_file():
                self._process_file(item)
        
        # Save statistics
        self._save_stats()
        return self.stats
    
    def _process_file(self, file_path):
        """Process individual file"""
        try:
            # Get file extension and category
            file_extension = file_path.suffix
            category = self.get_category(file_extension)
            
            # Determine destination folder
            if self.organize_by_date:
                # Get file modification date
                mod_time = datetime.fromtimestamp(file_path.stat().st_mtime)
                dest_folder = self.target_directory / category / mod_time.strftime('%Y-%m')
            else:
                dest_folder = self.target_directory / category
            
            # Create destination folder if it doesn't exist
            dest_folder.mkdir(parents=True, exist_ok=True)
            
            # Move file
            dest_path = dest_folder / file_path.name
            
            # Handle duplicate filenames
            counter = 1
            while dest_path.exists():
                stem = file_path.stem
                dest_path = dest_folder / f"{stem}_{counter}{file_extension}"
                counter += 1
            
            shutil.move(str(file_path), str(dest_path))
            
            # Update statistics
            self.stats['files_moved'] += 1
            self.stats['categories'][category] = self.stats['categories'].get(category, 0) + 1
            
            print(f"  ✅ Moved: {file_path.name} -> {category}/")
            
        except Exception as e:
            error_msg = f"Error processing {file_path.name}: {str(e)}"
            self.stats['errors'].append(error_msg)
            print(f"  ❌ {error_msg}")
    
    def _save_stats(self):
        """Save organization statistics"""
        stats_file = self.target_directory / 'organization_stats.json'
        with open(stats_file, 'w') as f:
            json.dump(self.stats, f, indent=2)
        print(f"\n📊 Statistics saved to: {stats_file}")

def main():
    parser = argparse.ArgumentParser(description='Organize files in a directory')
    parser.add_argument('directory', help='Directory to organize')
    parser.add_argument('--by-date', action='store_true', 
                       help='Organize by date (year/month) within categories')
    
    args = parser.parse_args()
    
    try:
        organizer = FileOrganizer(args.directory, args.by_date)
        stats = organizer.organize_files()
        
        print(f"\n✅ Organization complete!")
        print(f"   Files moved: {stats['files_moved']}")
        print(f"   Categories: {len(stats['categories'])}")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())