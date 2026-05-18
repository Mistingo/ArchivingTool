# Self Extracting Archive System

Hybrid archive utility implemented using **Bash** and **C**, capable of generating executable self-restoring archives.

The system packages files and directories into a portable executable archive script which can later recreate deleted resources together with their structure, contents and access permissions.

Instead of generating standard archives such as:

- ZIP
- TAR
- RAR

the project creates an executable archive:

```text
my-ball.sh
```

Executing this script restores the archived resources automatically.

---

## Overview

The objective of this project is to explore archive generation and restoration mechanisms through a hybrid Bash/C architecture.

The archive preserves:

✓ File contents

✓ Directory hierarchy

✓ Nested structures

✓ Encoded resources

✓ Restoration instructions

✓ Access permissions

✓ Executable rights

✓ File metadata required for reconstruction

The system allows deleted resources to be recreated from the generated archive.

---

## Workflow

```text
Original resources
        ↓
Filesystem traversal
(Bash)
        ↓
Metadata extraction
(chmod information)
        ↓
Encoding phase
(C)
        ↓
Archive generation
        ↓
my-ball.sh
        ↓
Archive execution
        ↓
Decoding phase
(C)
        ↓
Filesystem reconstruction
        ↓
Permission restoration
(chmod)
```

---

## Usage

Archive a file:

```bash
./create-ball.sh file.txt
```

Archive a folder:

```bash
./create-ball.sh project/
```

Generated archive:

```text
my-ball.sh
```

Delete original resources:

```bash
rm file.txt

rm -rf project/
```

Restore resources:

```bash
./my-ball.sh
```

The deleted resources are recreated automatically.

---

## Example

Initial structure:

```text
project/

├── notes.txt
├── images/
│   ├── logo.png
│   └── icon.png
│
└── scripts/
    └── backup.sh
```

Permissions:

```bash
-rw-r--r-- notes.txt

-rwxr-xr-x backup.sh
```

Generate archive:

```bash
./create-ball.sh project/
```

Output:

```text
my-ball.sh
```

Delete original resources:

```bash
rm -rf project/
```

Restore:

```bash
./my-ball.sh
```

Recovered structure:

```text
project/

├── notes.txt
├── images/
│   ├── logo.png
│   └── icon.png
│
└── scripts/
    └── backup.sh
```

Recovered permissions:

```bash
-rw-r--r-- notes.txt

-rwxr-xr-x backup.sh
```

The restored resources keep their original access rights.

---

## Internal Architecture

The project combines two layers.

### Bash Layer

Responsible for:

- Filesystem traversal
- Recursive analysis
- Resource discovery
- Archive generation
- Restoration script creation
- Metadata extraction
- Permission storage

Main entry point:

```text
create-ball.sh
```

---

### C Layer

Responsible for:

- Encoding operations
- Decoding operations
- Content reconstruction support

The C component is integrated into the archive workflow.

Global pipeline:

```text
Files / Directories
            ↓
Traversal
(Bash)
            ↓
Permission extraction
(chmod metadata)
            ↓
Encoding
(C)
            ↓
Archive generation
            ↓
my-ball.sh
            ↓
Execution
            ↓
Decoding
(C)
            ↓
Reconstruction
            ↓
chmod restoration
```

---

## Features

Implemented:

✓ File archiving

✓ Directory archiving

✓ Recursive traversal

✓ Self-extracting archives

✓ Automatic restoration

✓ File reconstruction

✓ Directory reconstruction

✓ Permission preservation

✓ chmod restoration

✓ Executable rights recovery

✓ Encoding system

✓ Decoding system

✓ Hybrid Bash/C architecture

✓ Portable execution

---

## Permission Preservation

The archive stores filesystem permissions before generation.

Saved information includes:

- Read permissions
- Write permissions
- Execute permissions

Permissions are restored automatically using:

```bash
chmod
```

Example:

Original file:

```bash
-rwxr-xr-x script.sh
```

Archive generation:

```bash
./create-ball.sh script.sh
```

Delete file:

```bash
rm script.sh
```

Restore:

```bash
./my-ball.sh
```

Recovered file:

```bash
-rwxr-xr-x script.sh
```

The file keeps its original access rights.

---

## Project Structure

```text
self-extracting-archive-system/

├── create-ball.sh
│
├── encoder/
│   ├── encode.c
│   └── decode.c
│
├── generated/
│   └── my-ball.sh
│
├── examples/
│
└── README.md
```

*(Structure may vary depending on the current implementation.)*

---

## Technologies

Languages:

- Bash
- C

Concepts explored:

- Shell scripting
- Recursive traversal
- Filesystem manipulation
- Encoding systems
- Decoding systems
- Metadata preservation
- Permission management
- chmod handling
- Archive generation
- Resource reconstruction
- Linux utilities

---

## Educational Objectives

This project explores:

- Hybrid Bash/C development
- Archive systems
- Recursive algorithms
- Filesystem analysis
- File handling
- Metadata preservation
- Linux permission management
- Restoration mechanisms
- System scripting

---

## Possible Improvements

Future developments:

- Compression support

- Incremental backup mode

- Encryption support

- Password protection

- Timestamp recovery

- Metadata expansion

- Archive preview

```bash
./my-ball.sh --preview
```

- Archive listing

```bash
./my-ball.sh --list
```

- Selective restoration

```bash
./my-ball.sh --restore scripts/
```

- Logging system

- Multiple archive outputs

- Compression statistics

---

## Academic Context

Project developed during Computer Science studies.

Main topics explored:

- Bash scripting
- C integration
- Linux systems
- Recursive traversal
- Filesystem reconstruction
- Permission handling
- Archive generation
- Metadata preservation

---

## Author

Thomas Augendre
