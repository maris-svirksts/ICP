# Version 0.9

import os
import re
import argparse


def process_file(file_path, declaration_type, block_type):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    stack = []
    resource_blocks = []
    inside_resource = False
    current_resource = []
    start_index = 0
    inside_block_comment = False

    resource_pattern = re.compile(rf'{declaration_type}.+{block_type}')

    for i, line in enumerate(lines):
        stripped_line = line.strip()

        # Manage block comments
        if '/*' in stripped_line:
            inside_block_comment = True
        if '*/' in stripped_line:
            inside_block_comment = False
            if not inside_resource:  # Ensure processing continues properly after a block comment
                continue

        # Skip processing lines inside block comments or lines that are commented out
        if inside_block_comment or stripped_line.startswith('#'):
            continue

        # Check if entering target declaration
        if resource_pattern.search(stripped_line) and not inside_resource:
            inside_resource = True
            start_index = i
            current_resource = []

        if inside_resource:
            # Append line as part of the current resource
            current_resource.append(line)

            if '{' in line:
                stack.append('{')
            if '}' in line:
                if stack:
                    stack.pop()
                if not stack:  # End of resource block
                    resource_blocks.append((start_index, i, current_resource))
                    inside_resource = False

    new_content = []
    last_copied_index = 0
    for start, end, block in resource_blocks:
        new_content.extend(lines[last_copied_index:start])
        # Create commented version of the block
        commented_block = ['/* TODO\n'] + \
            [line for line in block] + ['*/\n\n']
        new_content.extend(commented_block)
        new_content.extend(block)  # Include original block
        last_copied_index = end + 1

    new_content.extend(lines[last_copied_index:])

    try:
        with open(file_path, 'w', encoding='utf-8') as file:
            file.writelines(new_content)
    except Exception as e:
        print(f"Error writing to file {file_path}: {str(e)}")


def main(directory_path, declaration_type, block_type):
    for root, _, files in os.walk(directory_path):
        for file in files:
            if file.endswith('.tf'):
                process_file(os.path.join(root, file),
                             declaration_type, block_type)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Duplicate Terraform declaration blocks as commented sections.")
    parser.add_argument("directory_path", type=str,
                        help="Directory containing Terraform files.")
    parser.add_argument("declaration_type", type=str,
                        help="Terraform declaration type to process (e.g., resource, module, provider).")
    parser.add_argument("block_type", type=str,
                        help="Specific type of the Terraform declaration to process, with or without quotes.")
    args = parser.parse_args()
    main(args.directory_path, args.declaration_type, args.block_type)
