#!/usr/bin/env python3
"""
Script to properly add Swift files to an Xcode project.
This will add the ProgressOverlayManager.swift and EnhancedRadialProgressIndicator.swift files
to the OKTimer.xcodeproj project.
"""

import re
import uuid
import os

def generate_uuid():
    """Generate a unique ID for Xcode project entries"""
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

def add_files_to_project():
    project_path = 'OKTimer.xcodeproj/project.pbxproj'
    
    # Read the current project file
    with open(project_path, 'r') as f:
        content = f.read()
    
    # Files to add
    files_to_add = [
        {
            'path': 'OKTimer/Services/ProgressOverlayManager.swift',
            'name': 'ProgressOverlayManager.swift',
            'group': 'Services'
        },
        {
            'path': 'OKTimer/Views/EnhancedRadialProgressIndicator.swift',
            'name': 'EnhancedRadialProgressIndicator.swift',
            'group': 'Views'
        }
    ]
    
    # Find existing file references to understand the pattern
    file_ref_pattern = r'([A-F0-9]{24}) /\* (.+?) \*/ = \{isa = PBXFileReference; lastKnownFileType = sourcecode\.swift; path = (.+?); sourceTree = "<group>"; \};'
    build_file_pattern = r'([A-F0-9]{24}) /\* (.+?) in Sources \*/ = \{isa = PBXBuildFile; fileRef = ([A-F0-9]{24}) /\* (.+?) \*/; \};'
    
    new_content = content
    
    for file_info in files_to_add:
        file_ref_id = generate_uuid()
        build_file_id = generate_uuid()
        
        # Skip if file is already in project
        if file_info['name'] in content:
            print(f"File {file_info['name']} already exists in project")
            continue
            
        print(f"Adding {file_info['name']} to project...")
        
        # Add PBXFileReference
        file_ref_entry = f"\t\t{file_ref_id} /* {file_info['name']} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {file_info['name']}; sourceTree = \"<group>\"; }};"
        
        # Find where to insert file reference (after other file references)
        file_ref_section = re.search(r'(/* Begin PBXFileReference section */.*?)(/* End PBXFileReference section */)', new_content, re.DOTALL)
        if file_ref_section:
            new_file_refs = file_ref_section.group(1) + file_ref_entry + "\n\t\t" + file_ref_section.group(2)
            new_content = new_content.replace(file_ref_section.group(0), new_file_refs)
        
        # Add PBXBuildFile
        build_file_entry = f"\t\t{build_file_id} /* {file_info['name']} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {file_info['name']} */; }};"
        
        # Find where to insert build file (after other build files)
        build_file_section = re.search(r'(/* Begin PBXBuildFile section */.*?)(/* End PBXBuildFile section */)', new_content, re.DOTALL)
        if build_file_section:
            new_build_files = build_file_section.group(1) + build_file_entry + "\n\t\t" + build_file_section.group(2)
            new_content = new_content.replace(build_file_section.group(0), new_build_files)
        
        # Add to appropriate group (Services or Views)
        group_pattern = rf'([A-F0-9]{{24}}) /\* {file_info["group"]} \*/ = \{{[\s\S]*?children = \(\s*(.*?)\s*\);'
        group_match = re.search(group_pattern, new_content)
        if group_match:
            current_children = group_match.group(2)
            new_children = current_children.rstrip() + f"\n\t\t\t\t{file_ref_id} /* {file_info['name']} */,"
            new_content = new_content.replace(group_match.group(2), new_children)
        
        # Add to Sources build phase
        sources_pattern = r'([A-F0-9]{24}) /\* Sources \*/ = \{[\s\S]*?files = \(\s*(.*?)\s*\);'
        sources_match = re.search(sources_pattern, new_content)
        if sources_match:
            current_files = sources_match.group(2)
            new_files = current_files.rstrip() + f"\n\t\t\t\t{build_file_id} /* {file_info['name']} in Sources */,"
            new_content = new_content.replace(sources_match.group(2), new_files)
    
    # Write the modified content back
    with open(project_path, 'w') as f:
        f.write(new_content)
    
    print("Project file updated successfully!")

if __name__ == "__main__":
    add_files_to_project()
