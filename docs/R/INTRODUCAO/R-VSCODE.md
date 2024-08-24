# Instalação dos Plugins

R Extension for Visual Studio Code

R Tools (IntelliSense, signature help, tooltips and more)

Que necessita que instalemos o pacote `languageserver`:

Inicie o R com o comando R e depois execute:

```s
install.packages("xml2")
install.packages("roxygen2")
install.packages("lintr")
install.packages("languageserver")

```

Problema econtrado:

```
Warning messages:
1: In install.packages("languageserver") :
  installation of package ‘xml2’ had non-zero exit status
2: In install.packages("languageserver") :
  installation of package ‘roxygen2’ had non-zero exit status
3: In install.packages("languageserver") :
  installation of package ‘lintr’ had non-zero exit status
4: In install.packages("languageserver") :
  installation of package ‘languageserver’ had non-zero exit status
>

```

**Solução:**

```
sudo apt install libxml2-dev

```
