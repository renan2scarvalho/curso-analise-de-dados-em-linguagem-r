
Abra o R e instale:

```s
install.packages("devtools")
```

```s
devtools::install_github("ManuelHentschel/vscDebugger")
```

E instale o Radian

```s
pip3 install radian
```

Instale a extensão: `R Debugger`

Instalar (ctrl+shift+p) o package `r.debugger.updateRPackage`

Se seu VSCode estiver aberto, feche-o e abra novamente.
Se tiver o arquivo `.vscode/launch.json` renomei ele com outro nome
e clique em Debug que ele criará um novo `launch.json`

```s
{
    // Use o IntelliSense para saber mais sobre os atributos possíveis.
    // Focalizar para exibir as descrições dos atributos existentes.
    // Para obter mais informações, acesse: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "R-Debugger",
            "name": "Launch R-Workspace",
            "request": "launch",
            "debugMode": "workspace",
            "workingDirectory": "${workspaceFolder}"
        },
        {
            "type": "R-Debugger",
            "name": "Debug R-File",
            "request": "launch",
            "debugMode": "file",
            "workingDirectory": "${workspaceFolder}",
            "file": "${file}"
        },
        {
            "type": "R-Debugger",
            "name": "Debug R-Function",
            "request": "launch",
            "debugMode": "function",
            "workingDirectory": "${workspaceFolder}",
            "file": "${file}",
            "mainFunction": "main",
            "allowGlobalDebugging": false
        },
        {
            "type": "R-Debugger",
            "name": "Debug R-Package",
            "request": "launch",
            "debugMode": "workspace",
            "workingDirectory": "${workspaceFolder}",
            "includePackageScopes": true,
            "loadPackages": [
                "."
            ]
        },
        {
            "type": "R-Debugger",
            "request": "attach",
            "name": "Attach to R process",
            "splitOverwrittenOutput": true
        }
    ]
}
```


Ref: https://github.com/ManuelHentschel/VSCode-R-Debugger
