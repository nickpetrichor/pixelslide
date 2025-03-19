#!/usr/bin/env python3

import os
import sys
from PIL import Image
import argparse
from pathlib import Path

def create_directory_if_not_exists(directory):
    """Create directory if it doesn't exist."""
    if not os.path.exists(directory):
        os.makedirs(directory)

def process_image(input_path, output_filename, target_width=1200):
    """Process an image to fit the puzzle game requirements."""
    # Open the image
    with Image.open(input_path) as img:
        # Convert to RGB if necessary
        if img.mode != 'RGB':
            img = img.convert('RGB')
        
        # Calculate target height (4:3 aspect ratio)
        target_height = int(target_width * 4/3)
        
        # Get current dimensions
        width, height = img.size
        
        # Calculate current aspect ratio
        current_ratio = width / height
        target_ratio = 3/4  # We want height to be 4/3 of width
        
        if current_ratio > target_ratio:
            # Image is too wide, crop width
            new_width = int(height * target_ratio)
            left = (width - new_width) // 2
            img = img.crop((left, 0, left + new_width, height))
        else:
            # Image is too tall, crop height
            new_height = int(width / target_ratio)
            top = (height - new_height) // 2
            img = img.crop((0, top, width, top + new_height))
        
        # Resize to target dimensions
        img = img.resize((target_width, target_height), Image.Resampling.LANCZOS)
        
        # Save the processed image
        img.save(output_filename, 'JPEG', quality=85, optimize=True)
        print(f"Processed and saved: {output_filename}")

def main():
    parser = argparse.ArgumentParser(description='Process images for PixelSlide puzzle game')
    parser.add_argument('input_directory', help='Directory containing input images')
    parser.add_argument('--width', type=int, default=1200, help='Target width in pixels (default: 1200)')
    args = parser.parse_args()

    # Get the project root directory (where the script is located)
    script_dir = Path(__file__).resolve().parent
    project_root = script_dir.parent
    
    # Define the asset directories
    asset_categories = {
        'nature': ['puzzle_nature1', 'puzzle_nature2'],
        'city': ['puzzle_city1'],
        'abstract': ['puzzle_abstract1']
    }
    
    # Process each image in the input directory
    input_files = sorted([f for f in os.listdir(args.input_directory) 
                         if f.lower().endswith(('.png', '.jpg', '.jpeg'))])
    
    if not input_files:
        print("No image files found in the input directory!")
        return

    # Create asset directories if they don't exist
    for category, names in asset_categories.items():
        for name in names:
            imageset_path = project_root / 'PixelSlide' / 'Assets.xcassets' / f'{name}.imageset'
            create_directory_if_not_exists(imageset_path)
    
    # Process images
    available_slots = []
    for category, names in asset_categories.items():
        available_slots.extend(names)
    
    for i, input_file in enumerate(input_files):
        if i >= len(available_slots):
            print(f"Warning: More images than available slots. Skipping {input_file}")
            continue
            
        input_path = os.path.join(args.input_directory, input_file)
        output_path = project_root / 'PixelSlide' / 'Assets.xcassets' / f'{available_slots[i]}.imageset' / f'{available_slots[i]}.jpg'
        
        print(f"Processing {input_file} -> {available_slots[i]}")
        process_image(input_path, str(output_path), args.width)

if __name__ == '__main__':
    main() 