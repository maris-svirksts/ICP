# Terraform Declaration Block Processor

## Overview

This script is designed to process Terraform files by identifying specific declaration blocks and duplicating them as commented sections for review or modification. This allows developers to easily track changes or proposals without altering the active configuration.

## Version

0.10

## Features

- Scans a specified directory for Terraform (.tf) files.
- Identifies and processes specified types of Terraform declarations.
- Duplicates each found declaration block into a commented section directly above the original block.

## Prerequisites

- Python 3.6 or higher.

## Usage

1. Ensure that Python 3.6 or higher is installed on your system.
2. Place the script in a directory that has access to the target Terraform files.
3. Run the script from the command line using the following syntax:

```bash
python copy_and_comment.py [directory_path] [declaration_type] [block_type]
```

### Arguments

- `directory_path`: The path to the directory containing Terraform (.tf) files to process.
- `declaration_type`: The type of Terraform declaration to target (e.g., `resource`, `module`, `provider`).
- `block_type`: The specific type of the Terraform declaration (e.g., `"aws_s3_bucket"`, `"google_compute_instance"`).

## Example

To process all AWS S3 bucket resource declarations in Terraform files located in `/path/to/terraform/files`:

```bash
python copy_and_comment.py /path/to/terraform/files resource "aws_s3_bucket"
```

## Error Handling

The script handles file I/O errors gracefully, printing error messages if issues occur during the file writing process.

## Limitations

- The script currently only processes files with the `.tf` extension.
- It does not validate the syntax of Terraform files before processing.

## Contributing

Contributions to the script are welcome. Please ensure to follow best practices and include appropriate tests when submitting patches or features.

## License

MIT
