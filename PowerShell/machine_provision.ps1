# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

## Software ##

# Browsers
choco install googlechrome -y
choco install firefox -y

# Gaming
choco install discord -y

# Misc
choco install spotify -y
choco install adobereader -y
choco install kodi