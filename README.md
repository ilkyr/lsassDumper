# lsassDumper

lsassDumper is a PowerShell script designed to create memory dumps of the Local Security Authority Subsystem Service (LSASS) process on Windows machines. This tool can be particularly useful for forensic analysis and security testing, allowing users to extract potentially sensitive information from memory for further investigation.

## Features

- **Customizable Output Directory:** Users can specify the output directory for the dump file or use the default path.
- **Ease of Use:** Simple command-line interface with optional parameters.
- **Administrator Check:** Ensures the script is run with administrator privileges to access the LSASS process.

## Prerequisites

- Windows operating system
- PowerShell 5.1 or later
- Administrator rights on the system where the script is executed

## Installation

No installation is necessary. Download the `lsassDumper.ps1` script from this repository to your local machine.

## Usage

To run lsassDumper, open a PowerShell window as Administrator and navigate to the directory containing the script. Execute the script with the following command:

```powershell
.\lsassDumper.ps1 [-Path <custom_directory>]
```

## Legal Disclaimer and Permissions

**Caution:** lsassDumper is intended for use in authorized security testing and research environments only. You are responsible for ensuring you have the necessary permissions to use this tool in your specific context. Unauthorized use of this tool to access, modify, or interfere with system processes can result in legal consequences. By using lsassDumper, you agree to do so legally and ethically. The author disclaims any liability for misuse or damages resulting from the use of lsassDumper.
