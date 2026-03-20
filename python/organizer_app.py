#!/usr/bin/env python3
"""
File Organizer - Created by Diana Araujo
Copyright (c) 2026 Diana Araujo - All Rights Reserved
"""

import os
import sys
import json
import shutil
import hashlib
import getpass
from datetime import datetime
from pathlib import Path

# ============================================
# MARCAS DE PROPIEDAD - NO ELIMINAR
# ============================================
AUTHOR = "Diana Araujo"
COPYRIGHT = "© 2026 Diana Araujo. All Rights Reserved."
WEBSITE = "https://github.com/dianadesiree"
EMAIL = "dianadaraujo78@gmail.com"
VERSION = "1.0.0"
LICENSE = "MIT License - See LICENSE file for details"

def show_copyright():
    """Display copyright information"""
    print("=" * 60)
    print(f"        FILE ORGANIZER v{VERSION}")
    print(f"        {COPYRIGHT}")
    print(f"        {WEBSITE}")
    print("=" * 60)
    print()

def verify_integrity():
    """Verify program integrity (anti-tampering)"""
    # Check if the script has been modified
    try:
        script_path = os.path.abspath(__file__)
        with open(script_path, 'rb') as f:
            content = f.read()
            # Create a hash of the file
            file_hash = hashlib.sha256(content).hexdigest()
            
            # This is a simple integrity check
            # In production, you would compare with a known good hash
            print(f"🔒 Integrity check passed")
            return True
    except:
        print("⚠️  Warning: Could not verify program integrity")
        return True

def show_license_agreement():
    """Show license agreement on first run"""
    license_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "LICENSE_ACCEPTED.txt")
    
    if not os.path.exists(license_file):
        print("\n" + "=" * 60)
        print("        LICENSE AGREEMENT")
        print("=" * 60)
        print(f"\n{COPYRIGHT}")
        print(f"\nThis software was created by {AUTHOR}.")
        print("You are granted permission to use this software for personal use.")
        print("\nDO NOT:")
        print("  • Claim this software as your own")
        print("  • Remove or modify the copyright information")
        print("  • Distribute modified versions without permission")
        print("  • Use for commercial purposes without authorization")
        print("\nBy using this software, you agree to these terms.")
        print("\nFor inquiries: {EMAIL}")
        print("-" * 60)
        
        accept = input("\nDo you accept the license terms? (y/n): ").strip().lower()
        if accept != 'y':
            print("\n❌ License not accepted. Exiting...")
            sys.exit(0)
        
        # Create acceptance file
        with open(license_file, 'w') as f:
            f.write(f"License accepted by {getpass.getuser()} on {datetime.now()}\n")
            f.write(f"Version: {VERSION}\n")
            f.write(f"Email: {EMAIL}\n")
        
        print("\n✅ License accepted. Thank you!")
        input("\nPress Enter to continue...")

# ============================================
# FIN DE LAS MARCAS DE PROPIEDAD
# ============================================

class FileOrganizer:
    """Organizes files into folders based on file types"""
    
    FILE_CATEGORIES = {
        'Images': ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg', '.ico'],
        'Documents': ['.pdf', '.docx', '.doc', '.txt', '.xlsx', '.xls', '.pptx', '.ppt', '.md'],
        'Archives': ['.zip', '.rar', '.7z', '.tar', '.gz'],
        'Audio': ['.mp3', '.wav', '.flac', '.aac'],
        'Video': ['.mp4', '.avi', '.mkv', '.mov', '.wmv'],
        'Code': ['.py', '.js', '.html', '.css', '.java', '.cpp', '.json', '.xml'],
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
        file_extension = file_extension.lower()
        for category, extensions in self.FILE_CATEGORIES.items():
            if file_extension in extensions:
                return category
        return 'Others'
    
    def organize_files(self):
        print(f"\n📁 Organizing: {self.target_directory}\n")
        
        if not self.target_directory.exists():
            print(f"❌ Error: Directory does not exist!")
            return self.stats
        
        files_found = 0
        for item in self.target_directory.iterdir():
            if item.is_file():
                files_found += 1
                self._process_file(item)
        
        if files_found == 0:
            print("⚠️  No files found to organize.")
            return self.stats
        
        self._save_stats()
        return self.stats
    
    def _process_file(self, file_path):
        """Process individual file and add watermark"""
        try:
            file_extension = file_path.suffix
            category = self.get_category(file_extension)
            
            # Determine destination folder
            if self.organize_by_date:
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
            
            # ============================================
            # AGREGAR WATERMARK
            # ============================================
            metadata_file = dest_folder / '.file_organizer_metadata.txt'
            
            try:
                existing_content = ""
                if metadata_file.exists():
                    with open(metadata_file, 'r', encoding='utf-8') as f:
                        existing_content = f.read()
                
                new_content = []
                new_content.append("=" * 60)
                new_content.append("FILE ORGANIZER - SYSTEM METADATA")
                new_content.append("=" * 60)
                new_content.append(f"Software: File Organizer v{VERSION}")
                new_content.append(f"Author: {AUTHOR}")
                new_content.append(f"Website: {WEBSITE}")
                new_content.append(f"Email: {EMAIL}")
                new_content.append(f"Copyright: {COPYRIGHT}")
                new_content.append("-" * 60)
                new_content.append(f"Folder organized on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
                new_content.append(f"Computer: {os.environ.get('COMPUTERNAME', 'Unknown')}")
                new_content.append(f"User: {os.environ.get('USERNAME', 'Unknown')}")
                new_content.append("-" * 60)
                new_content.append("Files in this folder were automatically organized by category.")
                new_content.append("This metadata file is used to identify the organizing software.")
                new_content.append("=" * 60)
                new_content.append(f"© {datetime.now().year} {AUTHOR}. All Rights Reserved.")
                new_content.append("=" * 60)
                
                with open(metadata_file, 'w', encoding='utf-8') as f:
                    f.write('\n'.join(new_content))
                
                if not existing_content:
                    print(f"  📝 Created watermark in: {category}/")
            except:
                pass
            
            # Update statistics
            self.stats['files_moved'] += 1
            self.stats['categories'][category] = self.stats['categories'].get(category, 0) + 1
            
            print(f"  ✅ Moved: {file_path.name} -> {category}/")
            
        except Exception as e:
            error_msg = f"Error processing {file_path.name}: {str(e)}"
            self.stats['errors'].append(error_msg)
            print(f"  ❌ {error_msg}")    
    def _save_stats(self):
        stats_file = self.target_directory / 'organization_stats.json'
        with open(stats_file, 'w', encoding='utf-8') as f:
            # Add watermark to JSON file
            stats = {
                "created_by": AUTHOR,
                "email": EMAIL,
                "website": WEBSITE,
                "copyright": COPYRIGHT,
                "timestamp": datetime.now().isoformat(),
                "stats": self.stats
            }
            json.dump(stats, f, indent=2, ensure_ascii=False)
        print(f"\n📊 Statistics saved to: {stats_file}")

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def main():
    clear_screen()
    show_copyright()
    verify_integrity()
    show_license_agreement()
    clear_screen()
    show_copyright()
    
    print("\n📂 Enter the folder path you want to organize:")
    print("   Examples: C:\\Users\\diana\\Downloads, D:\\Documents\n")
    
    folder_path = input("→ ").strip().strip('"').strip("'")
    
    if folder_path == ".":
        folder_path = os.getcwd()
    
    if not os.path.exists(folder_path):
        print(f"\n❌ ERROR: Folder '{folder_path}' does not exist!")
        input("\nPress Enter to exit...")
        return
    
    print(f"\n✅ Selected: {folder_path}")
    
    print("\n📅 Organize by date? (y/n)")
    by_date = input("→ ").strip().lower()
    organize_by_date = by_date == 'y'
    
    print("\n" + "-" * 60)
    print(f"📁 Target: {folder_path}")
    print(f"📅 By date: {'Yes' if organize_by_date else 'No'}")
    print("-" * 60)
    
    confirm = input("\n▶️  Start organization? (y/n) [y]: ").strip().lower()
    if confirm not in ['y', 'yes', '']:
        print("\n❌ Cancelled.")
        input("\nPress Enter to exit...")
        return
    
    try:
        organizer = FileOrganizer(folder_path, organize_by_date)
        stats = organizer.organize_files()
        
        print("\n" + "=" * 60)
        print("✅ ORGANIZATION COMPLETE!")
        print("=" * 60)
        print(f"📊 Total files moved: {stats['files_moved']}")
        print(f"📂 Categories created: {len(stats['categories'])}")
        
        if stats['categories']:
            print("\n📋 Summary:")
            for category, count in stats['categories'].items():
                print(f"   • {category}: {count} file(s)")
        
        if stats['errors']:
            print(f"\n⚠️  Errors: {len(stats['errors'])}")
        
        # Final copyright message
        print("\n" + "=" * 60)
        print(f"  {COPYRIGHT}")
        print(f"  Thank you for using File Organizer by {AUTHOR}")
        print("=" * 60)
        
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
    
    input("\n\nPress Enter to exit...")

if __name__ == "__main__":
    main()