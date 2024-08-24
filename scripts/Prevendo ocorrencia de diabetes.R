################################################################################
# Título: Prevendo ocorrência de diabetes
# Data: 24/08/2024
# Descrição:
#   Neste tópico, aprenderemos as etapas de construção de um modelo de machine learning utilizando 
#   a linguagem R. O objetivo dessa análise é demonstrar a construção do modelo preditivo, usado 
#   para identificar padrões e mostrar o que pode acontecer de acordo com os dados analisados.
# 
# A frase que expressa a definição do problema é:
# Identificar pacientes com alta probabilidade de serem diagnosticados com diabetes, 
# tendo, no mínimo, 75% de acurácia.
################################################################################

logMessage <- function(message, level = "INFO", file = file.path(CURRENT_DIR, "logs", "projeto2.log")) {
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

install_if_missing(c("dplyr", "ggplot2", "caTools", "caret", "e1071"))

library(dplyr)
library(ggplot2)
library(caTools)
library(caret)
library(e1071)

# Configuração de diretórios
CURRENT_DIR <- getwd()
path_components <- strsplit(CURRENT_DIR, .Platform$file.sep)[[1]]
HOME_DIR <- paste(path_components[-length(path_components)], collapse = .Platform$file.sep)

# Diretórios de saída
DIR_OUTPUT <- file.path(CURRENT_DIR, "Saida")
DIR_FILES <- file.path(DIR_OUTPUT, "files")
DIR_FIGURAS <- file.path(DIR_OUTPUT, "figuras_projeto2")

# Cria diretórios de saída
if (dir.exists(DIR_FIGURAS)) {
  clear_directory(DIR_FIGURAS)
} else {
  dir.create(DIR_FIGURAS, recursive = TRUE)
}

start_time <- Sys.time()
logMessage(paste("Início do script: ", start_time))

logMessage(paste("Leitura do arquivo"))
arquivo <- file.path(DIR_FILES, "diabetes.csv")
df <- read.csv(arquivo)

logMessage(paste("Dimensão do dataset: ", dim(df)))

logMessage("-------------------")
logMessage("Transformação de variáveis")
logMessage("Checando valores faltantens")
logMessage(colSums(is.na(df)))

logMessage("-------------------")
logMessage("Exploração de dados")
output_path <- file.path(DIR_FIGURAS, "p0_boxplot_diabetes.png")
png(filename=output_path)
boxplot(df)
dev.off()

output_path <- file.path(DIR_FIGURAS, "p1_hist_gravidez.png")
png(filename=output_path)
hist(df$Pregnancies)
dev.off()

output_path <- file.path(DIR_FIGURAS, "p2_hist_idade.png")
png(filename=output_path)
hist(df$Age)
dev.off()

output_path <- file.path(DIR_FIGURAS, "p3_hist_bmi.png")
png(filename=output_path)
hist(df$BMI)
dev.off()

output_path <- file.path(DIR_FIGURAS, "p4_hist_insulina.png")
png(filename=output_path)
hist(df$Insulin)
dev.off()
# valores muito acima da média
df <- df %>% 
  filter(Insulin <= 250)
output_path <- file.path(DIR_FIGURAS, "p5_hist_insulina_filter.png")
png(filename=output_path)
hist(df$Insulin)
dev.off()

logMessage("-------------------")
logMessage("Construção do modelo")
set.seed(123)
index <- sample.split(df$Pregnancies, SplitRatio=0.7)

df_train <- subset(df, index==TRUE)
df_test <- subset(df, index==FALSE)

logMessage(paste("Dimensão total: ", dim(df)))
logMessage(paste("Dimensão treino: ", dim(df_train)))
logMessage(paste("Dimensão teste: ", dim(df_test)))

logMessage("Modelo 1")
modelo <- train(Outcome ~., data=train, method='knn')

logMessage("Resultados")
logMessage(modelo$results)
logMessage("Hiperparametros")
logMessage(modelo$bestTune)

logMessage("*******************")
logMessage("Modelo 2")
modelo2 <- train(Outcome ~., data=train, method='knn', tuneGrid=epand.grid(k=c(1:20)))

logMessage("Resultados")
logMessage(modelo2$results)
logMessage("Hiperparametros")
logMessage(modelo2$bestTune)

output_path <- file.path(DIR_FIGURAS, "p6_modelo2_tuning.png")
png(filename=output_path)
plot(modelo2)
dev.off()

logMessage("*******************")
logMessage("Modelo 3")
modelo3 <- train(Outcome ~., data=train, method='naive_bayes')

logMessage("Resultados")
logMessage(modelo3$results)
logMessage("Hiperparametros")
logMessage(modelo3$bestTune)

logMessage("*******************")
logMessage("Modelo 4")
set.seed(100)
modelo4 <- train(Outcome ~., data=train, method='svmRadialSigma', preProcess=c("center"))

logMessage("Resultados")
logMessage(modelo4$results)
logMessage("Hiperparametros")
logMessage(modelo4$bestTune)

logMessage("-------------------")
logMessage("Avaliando Modelo 4")
predicoes <- predict(modelo4, test)

logMessage(confusionMatrix(predicoes, test$Outcome))

logMessage("-------------------")
logMessage("Realizando predições")

novos.dados <- data.frame(
    Pregnancies = c(3), 
    Glucoes = c(111.5), 
    BloodPressure = c(70),
    SkinThickness = c(20),
    Insulin = c(47.49),
    BMI = c(30.80),
    DiabetesPedigreeFunction = c(0.34),
    Age = c(28)
)

previsao_ponto <- predict(modelo4, novos.dados)
res <- ifelse(previsao == 1, "Positivo", "Negativo")
logMessage(paste("Resultado: ", res))