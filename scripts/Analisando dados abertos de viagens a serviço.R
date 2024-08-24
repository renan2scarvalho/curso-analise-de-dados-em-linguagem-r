################################################################################
# Título: Análise de viagens a serviço
# Data: 24/08/2024
# Descrição:
#   A proposta deste tópico é colocar em prática algumas das funções do R trabalhando com a 
#   análise de dados abertos de viagens a serviço, com o intuito de subsidiar a tomada de medidas 
#   mais eficientes na redução dos gastos com os custos dessas viagens no setor público.
################################################################################

logMessage <- function(message, level = "INFO", file = file.path(CURRENT_DIR, "logs", "projeto1.log")) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  msg <- sprintf("[%s] %s: %s", timestamp, level, message)
  cat(msg, "\n", file = file, append = TRUE)
}

clear_directory <- function(dir) {
  files <- list.files(dir, full.names = TRUE)
  file.remove(files)
}

install_if_missing <- function(packages) {
  for (package in packages) {
    if (!require(package, character.only = TRUE)) {
      install.packages(package, dependencies = TRUE)
      library(package, character.only = TRUE)
    }
  }
}

install_if_missing(c("dplyr", "ggplot2"))

library(dplyr)
library(ggplot2)

# Configuração de diretórios
CURRENT_DIR <- getwd()
path_components <- strsplit(CURRENT_DIR, .Platform$file.sep)[[1]]
HOME_DIR <- paste(path_components[-length(path_components)], collapse = .Platform$file.sep)

# Diretórios de saída
DIR_OUTPUT <- file.path(CURRENT_DIR, "Saida")
DIR_FILES <- file.path(DIR_OUTPUT, "files")
DIR_FIGURAS <- file.path(DIR_OUTPUT, "figuras_projeto1")

# Cria diretórios de saída
if (dir.exists(DIR_FIGURAS)) {
  clear_directory(DIR_FIGURAS)
} else {
  dir.create(DIR_FIGURAS, recursive = TRUE)
}

start_time <- Sys.time()
logMessage(paste("Início do script: ", start_time))

logMessage(paste("Leitura do arquivo"))
arquivo <- file.path(DIR_FILES, "2019_Viagem.csv")
df_viagens <- read.csv(arquivo, sep=";", dec=",", fileEncoding = "Latin1")

logMessage(paste("Dimensão do dataset: ", dim(df_viagens)))

logMessage("Transformação de variáveis")
df_viagens$data.inicio <- as.Date(df_viagens$Período...Data.de.início, "%d/%m/%Y")
df_viagens$data.inicio.fmt <- format(df_viagens$data.inicio, "%Y-%m")

logMessage("Exploração de dados")
logMessage("-------------------")
logMessage("Valor das passagens")
logMessage("Sumário")
logMessage(summary(df_viagens$Valor.passagens))
# histograma
output_path <- file.path(DIR_FIGURAS, "p0_hist_valor_passagens.png")
png(filename=output_path)
hist(df_viagens$Valor.passagens, main='Valor das Passagens - Histograma')
dev.off()
# boxplot
output_path <- file.path(DIR_FIGURAS, "p1_boxplot_valor_passagens.png")
png(filename=output_path)
boxplot(df_viagens$Valor.passagens, main='Valor das Passagens - Boxplot')
dev.off()

logMessage("-------------------")
logMessage("Checando valores faltantens")
logMessage(colSums(is.na(df_viagens)))

logMessage("-------------------")
logMessage("Checando quantidade de ocorrências de uma classe - Situação")
logMessage("Absoluto")
logMessage(table(df_viagens$Situação))

logMessage("Percentual")
logMessage(prop.table(table(df_viagens$Situação))*100)

logMessage("-------------------")
logMessage("Respondendo questões")
logMessage("1. Quais órgãos estão gastando mais com passagens aéreas?")
df1 <- df_viagens %>% 
    group_by(Nome.do.órgão.superior) %>% # agrupa por nome do órgão superior
    summarise(n=sum(Valor.passagens)) %>%  # soma valor das passagens
    arrange(desc(n)) %>%  # ordena de maneira descendente
    top_n(15) # seleciona top 15
names(df1) <- c("orgao", "valor")
logMessage(df1)

p2 <- ggplot(df1, aes(x=reorder(orgao, valor), y=valor)) +
    geom_bar(stat="identity") +
    coord_flip() +
    labs(x="Valor", y="Órgão")
output_path <- file.path(DIR_FIGURAS, "p2_orgaos_maior_gasto.png")
ggsave(output_path, plot = p2, width = 8, height = 6, dpi = 300)

logMessage("2. Quais destinios possuem maior gasto com passagens aéreas?")
df2 <- df_viagens %>%
    group_by(Destinos) %>%
    summarise(n=sum(Valor.passagens)) %>%
    arrange(desc(n)) %>%
    top_n(15)
names(df2) <- c("destino", "valor")
logMessage(df2)

p3 <- ggplot(df2, aes(x=reorder(destino, valor), y=valor)) +
    geom_bar(stat="identity", fill="#0ba791") +
    geom_text(aes(label=valor), vjust=0.3, size=3) +
    coord_flip() +
    labs(x="Valor", y="Destino")
options(scipen=999)
output_path <- file.path(DIR_FIGURAS, "p3_destinos_maior_gasto.png")
ggsave(output_path, plot = p3, width = 8, height = 6, dpi = 300)

logMessage("3. Qual a quantidade de viagens realizadas por mês?")
df3 <- viagens %>%
    group_by(data.inicio.fmt) %>%
    summarise(qtd=n_distinct(Identificador.do.processo.de.viagem))
logMessage(head(df3))

p4 <- ggplot(df3, aes(x=data.inicio.fmt, y=qtd, groupb=1)) +
    geom_line() +
    geom_point()
output_path <- file.path(DIR_FIGURAS, "p4_quantidade_viagens_mes.png")
ggsave(output_path, plot = p4, width = 8, height = 6, dpi = 300)

