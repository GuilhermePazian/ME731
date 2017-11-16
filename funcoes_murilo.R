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

envelnorm<-function(fit.model){  
  # argumento: modelo de regressão linear homocedástico ajustado
  # Eu adaptei uma função que achei na net com o que o Caio fez nos grafs de envelope. Agradeçam a um desconhecido.  
  
  
  
  X <- model.matrix(fit.model)
  n <- nrow(X)
  p <- ncol(X)
  H <- X%*%solve(t(X)%*%X)%*%t(X)
  h <- diag(H)
  si <- lm.influence(fit.model)$sigma
  r <- resid(fit.model)
  tsi <- r/(si*sqrt(1-h))
  #
  ident <- diag(n)
  epsilon <- matrix(0,n,100)
  e <- matrix(0,n,100)
  e1 <- numeric(n)
  e2 <- numeric(n)
  #
  for(i in 1:100){
    epsilon[,i] <- rnorm(n,0,1)
    e[,i] <- (ident - H)%*%epsilon[,i]
    u <- diag(ident - H)
    e[,i] <- e[,i]/sqrt(u)
    e[,i] <- sort(e[,i]) }
  #
  for(i in 1:n){
    eo <- sort(e[i,])
    e1[i] <- (eo[2]+eo[3])/2
    e2[i] <- (eo[97]+eo[98])/2 }
  
  
  y <- quantile(tsi[!is.na(tsi)], c(0.25, 0.75))
  x <- qnorm(c(0.25, 0.75))
  slope <- diff(y)/diff(x)
  int <- y[1L] - slope * x[1L]
  
  d <- data.frame(resids = tsi)
  
  ggplot(d, aes(sample = resids))+stat_qq()+stat_qq(aes(sample=e1),geom="line")+stat_qq(aes(sample=e2),geom="line")+ geom_abline(slope = slope, intercept = int,linetype = 3)+labs(x="Percentil da N(0,1)",y="Residuo Studentizado",title="E")+theme_light()
}


diag2norm<-function(fit.model){
  # fit.model: objeto com o ajuste do modelo normal linear homocedástico 
  # obtido através da função "lm"
  
  
  
  X <- model.matrix(fit.model)
  n <- nrow(X)
  p <- ncol(X)
  H <- X%*%solve(t(X)%*%X)%*%t(X)
  h <- diag(H)
  lms <- summary(fit.model)
  s <- lms$sigma
  r <- resid(lms)
  ts <- r/(s*sqrt(1-h))
  di <- (1/p)*(h/(1-h))*(ts^2)
  si <- lm.influence(fit.model)$sigma
  tsi <- r/(si*sqrt(1-h))
  tam <- 1:length(tsi)
  a <- max(tsi)
  b <- min(tsi)
  
  g1 = ggplot(data=data.frame(tam,tsi),aes(tam,tsi))+ geom_point() +scale_y_continuous(name = "Resíduo Studentizado",limits=c(b-1,a+1)) +scale_x_continuous(name = "Índice")+labs(title="A")+geom_hline(yintercept=0,size=0.25,linetype=2)+geom_hline(yintercept=2,size=0.25,linetype=2)+geom_hline(yintercept=-2,size=0.25,linetype=2)+theme_light()
  
  g2 =  ggplot(data=data.frame(fitted(fit.model),tsi),aes(fitted(fit.model),tsi))+ geom_point() +scale_y_continuous(name = "Resíduo Studentizado",limits=c(b-1,a+1)) +scale_x_continuous(name = "Valores Ajustados")+labs(title="B")+geom_hline(yintercept=0,size=0.25,linetype=2)+geom_hline(yintercept=2,size=0.25,linetype=2)+geom_hline(yintercept=-2,size=0.25,linetype=2)+theme_light()
  
  #Histograma
  g3 = ggplot(data=data.frame(tsi),aes(tsi,col=I("black"),fill=I("white")))+geom_histogram(binwidth = 1,aes(y=..density..))+labs(title="C",x="Resíduo Studentizado",y="Densidade")+theme_light()
  
  #Boxplot
  g4 = envelnorm(fit)
  #funcao que une todos os gráficos
  grid.arrange(g1,g2,g3,g4,ncol=2,nrow=2)
  #---------------------------------------------------------------#
  
}

# Programa extraído do site: https://www.ime.usp.br/~giapaula/textoregressao.htm
# Créditos: Prof. Dr. Gilberto Alvarenga Paula
# Adaptado por Caio L. N. Azevedo e Henrique Capatto

function(n,c){
  y <- character(n)
  for(i in 1:n){
    y[i] <- ifelse(i %% 2 == 1,  paste0("$","\\mu_{",(i+1)/2,"}$"),
                   paste0("$","\\alpha_{",c,i/2,"}$") )
  }
  return(y)
}
