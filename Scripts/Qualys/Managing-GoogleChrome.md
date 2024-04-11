# Remediating Per-User Google Chrome Installations

This script will remove the Google Chrome installation for the current user. It will also remove the Google Chrome user data directory and the Google Chrome user profile directory.

## Handling Existing Installations

Depending on the type of installation(s) by the administrator, Google Update will be in one or both of these locations:

-   **Per machine:** `%ProgramFiles(x86)%\Google\Update`
-   **Per user:** `%LOCALAPPDATA%\Google\Update`

Chrome's Enterprise installer (MSI) installs Chrome for all users of a computer. This installer will update the Chrome browser for all users, provided that the version you’re installing is the same or newer than the version previously installed on the computer.

If the computer already has the Chrome browser installed for an individual user (in that user’s profile directory), that installation will not be modified by the Chrome Enterprise installer. Instead, the next time the user launches the installation of Chrome in their profile directory, Chrome will detect another installation of Chrome present for all users, uninstall itself, and launch the updated version of the Chrome browser for all users.

### Registry Keys

-   In the "Registry Editor" window, open:
    -   `HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Google\Update\Clients`
-   If you don’t see the application under that key, try looking for the key:
    -   `HKEY_LOCAL_MACHINE\SOFTWARE\Google\Update\Clients`
-   If you find either key, right-click the key and select "Delete".

### Using the InitialPrefs File

-   Use initial preferences for Chrome browser: <https://support.google.com/chrome/a/answer/187948?hl=en&>
-   **Windows:** `C:\Program Files\Google\Chrome\Application\initial_preferences`

---

```powershell
# Get the download URL of the latest winget installer from GitHub:
$API_URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$DOWNLOAD_URL = $(Invoke-RestMethod $API_URL).assets.browser_download_url |
    Where-Object {$_.EndsWith(".msixbundle")}

# Download the installer:
Invoke-WebRequest -URI $DOWNLOAD_URL -OutFile winget.msixbundle -UseBasicParsing

# Install winget:
Add-AppxPackage winget.msixbundle

# Remove the installer:
Remove-Item winget.msixbundle
```

---

# Resources and References

Unfortunately, these are not in any particular order. I will try to organize them in the future.

- https://support.google.com/chrome/answer/6315198
- https://support.google.com/chrome/a/topic/6242754
- https://support.google.com/chrome/a/answer/187948?hl=en&ref_topic=9023406

  ---

  ## Google Chrome Management

Installing Chrome browser from an `.MSI` overrides any version of Chrome browser installed by a user. Here’s where Chrome is installed and linked for the two types of installers:

-   **User Level:** `%USER DATA%\Google\Chrome\Application\`
-   **System Level:** `Program Files\Google\Chrome\Application\`

> **Note:** Chrome browser doesn't allow an older version to be installed over a newer version. Chrome browser MSI being installed should be newer than the version already deployed. For example, Chrome browser version 62 can’t overwrite version 63.

### Installation Steps

1. **Push the MSI package:** There are several ways .msi files can be distributed to managed Windows computers, including Active Directory Group Policy Management, HP Client Automation, Microsoft System Center Configuration Manager, and others.If you’re using SMS or other tools to deploy software, you should push the Chrome browser MSI package just like you would for any other .msi installation. Or, you can run the file on the target machines **silently** with the following command: `msiexec /q /l GoogleChrome.msi`
1. **Install the MSI package:** The Chrome browser MSI package can be installed in two ways:
    - **Silent installation:** This is the most common method. The installation runs in the background and doesn’t require user interaction. The command is: `msiexec /q /l GoogleChrome.msi`
    - **Interactive installation:** This method requires user interaction. The installation runs in the foreground and the user can see the installation progress. The command is: `msiexec /i GoogleChrome.msi`
