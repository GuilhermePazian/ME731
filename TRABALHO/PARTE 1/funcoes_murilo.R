##Descritivas
#Tabela resumo com médias, variancias, quartils...
tab_estat <- function(db){
  medados <- rbind(round(apply(db,2,mean),3),
                   round(apply(db,2,var),3),
                   round(apply(db,2,sd),3),
                   round(100*apply(db,2,sd)/apply(db,2,mean),3),
                   round(apply(db,2,min),3),
                   round(apply(db,2,quantile,0.5),3),
                   round(apply(db,2,max),3))
  rownames(medados)<-c("Média","Var.","DP","CV(%)","Mínimo","Mediana","Máximo")
  return(medados)
}


descritivas <- function(dados){
  dados %>% select_if(.predicate = is.numeric) %>% 
    gather(coluna,valores) %>% 
    group_by(coluna) %>% 
    summarise_if(.predicate = function(x) is.numeric(x),
                 .funs = c(Media = "mean",
                           DP = "sd",
                           Var. = "var",
                           Minimo = "min",
                           Maximo = "max",
                           CV =  "cv",
                           Mediana = "median",
                           n = "length")) %>% 
    mutate_if(.predicate = is.numeric,funs(round(.,3)))
  return(dados)
}

##calcula coeficiente de correlacao(%)
cv <- function(x){
  100 * sd(x)/mean(x)
}


# Função que  carrega e instala pacotes
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
  
}