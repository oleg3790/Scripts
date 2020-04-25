# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

## Software ##

# Node
choco install nvm -y
nvm install node -y

# .NET
choco install netfx-4.8 -y
choco install dotnetcore -y

# .NET SDK
choco install netfx-4.8-devpack -y
choco install dotnetcore-sdk -y

# Browsers
choco install googlechrome -y
choco install firefox -y

# Dev tools
choco install curl -y
choco install git -y
choco install vscode -y
choco install vscode-powershell -y
choco install vscode-csharp -y
choco install vscode-gitlens -y
choco install postman -y
choco install sql-server-management-studio -y

# VS 2019
choco install visualstudio2019community

# Misc
choco install filezilla -y
choco install github