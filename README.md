# Archiving – Simplon Project

This project consists of writing a Shell script to retrieve JSON documents from a web server based on a list of URLs, while keeping the HTTP headers for monitoring and maintaining a history of the latest executions.  
Here are the concise definitions of these terms that will contribute to creating this project: a console, a terminal, a shell, and a command with its arguments (and how a command is processed).

## What is a terminal
A terminal is essentially a text-based user interface that allows interaction with computers. It allows users to execute commands, see results, and control running applications on the computer. (sources: canada.lenovo.com)

## What is a console
A console application is a type of program that runs on a text-based command-line interface. Unlike graphical user interfaces, console applications interact with users via text input and output. They are often used for tasks that do not require a graphical interface, such as system administration, automation scripts, or data processing. (sources: canada.lenovo.com)

The term “console” will refer to the device, and the word “terminal” will describe the software inside this console.

For example:

On Windows:
- console → WindowsTerminal  
- terminal → PowerShell

On Linux:
- console → tty1  
- terminal → GNOME

And if we open GitBash on Windows: Mintty is the terminal that manages its own virtual console.  
Git Bash is a Windows package that allows using a lightweight Linux environment on Windows.

## What is a shell?
A shell is a program that allows interaction with the computer by typing commands and executing them. It acts as a command-line interpreter, taking your input, interpreting it, and executing the corresponding actions.  
When you enter a command in a shell, it parses the input, interprets it, and executes the appropriate system calls to perform the requested task. The shell acts as an intermediary between you and the operating system, allowing you to interact with underlying resources and services (sources: canada.lenovo.com); basically, it’s the translator.

For example:
- Bash for Linux  
- PowerShell for Windows  
- GitBash also included in the Windows package.

## A command and its arguments (and how a command is processed)
A command is the main keyword in the shell to request an action.  
Arguments are additional information that specify or modify the behavior of the command. Some of this information is called options when they start with a dash (- or --) and modify how the command works. Arguments (and options) are usually separated by spaces when there are multiple.

Simple example:

ls -l /home/Documents
ls → command (lists the files in a folder)

-l → option (modifies the behavior of ls to show details: permissions, size, date…)

/home/Documents → argument / parameter (the folder on which the command acts)

## The script
A script is a file that contains a series of commands that the shell will execute one after another. Instead of typing commands manually each time, a script allows automating tasks. Scripts are useful for repetitive work, monitoring, backups, or data processing.

For this project, the Bash script (run.sh) will do the following:

- Print the start time and the script’s full path.
- Create a temporary folder for downloads.
- Download each JSON file listed in urls.txt and save HTTP headers separately.
- Copy JSON files from the temporary folder to the downloads folder.
- Compile all headers into headers.txt.
- Compress the downloads folder into a timestamped archive in the archives folder.
- Print the end time and a “Bye!” message.

## How to run the script
bash run.sh

- urls.txt : a list of JSON URLs (one per line), must be in the same folder as run.sh
- downloads : folder where JSON files and headers.txt will be saved (created automatically)
- archives : folder where the compressed archive will be created (created automatically)


