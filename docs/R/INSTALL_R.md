Ubuntu 20.04

dependencias do ubuntu
>sudo apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common

adicionando o repositorio CRAN na lista de fontes da maquina
>sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
>sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'

instalar R
>sudo apt install r-base

compilar pacotes R
>sudo apt install build-essential

liberar escrita na pasta de instalacao de pacotes R /usr/local/lib/R/site-library/
>sudo chmod 777 /usr/local/lib/R/site-library/

instalar pacotes R
>R
>install.packages("nome_pacote")

para a parte de previsao conjunta de precipitacao
>install.packages("lpSolve")
>install.packages("readxl")
>install.packages("sgeostat")

para a parte de previsao de carga
colocar os arquivos 'combPrevCarga_1.2.5.tar.gz' e 'prevcargadessem_1.26.8.tar.gz' na pasta "/home/ubuntu/meteorologia/previsao_carga/"
>setwd("/home/ubuntu/meteorologia/previsao_carga/")
>options(repos=structure(c(CRAN="https://cran.microsoft.com/snapshot/2020-06-01/")))
>install.packages("data.table")
>install.packages("lubridate")
>install.packages("e1071")
>install.packages("neuralnet")
>install.packages("nnet")
>install.packages("WeightSVM")
>install.packages("quantreg")
>install.packages("quadprog")
>install.packages('combPrevCarga_1.2.5.tar.gz',repos=NULL)
>install.packages('prevcargadessem_1.26.8.tar.gz',repos=NULL)

para a parte de previsao eolica
>install.packages("binhf")
>install.packages("RCurl")
>install.packages("reshape2")
