#Gráfico de resíduos
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
  g4 = ggplot(data=data.frame(fac = factor(1),tsi),aes(fac,tsi,col=I("black"),fill=I("white")))+ geom_boxplot(outlier.size = 1.5, outlier.colour = "red",width=0.4)+labs(title="D")+scale_x_discrete(name="")+scale_y_continuous(name = "Residuo Studentizado")+theme(axis.text.x = element_blank())+theme_light()
  
  #funcao que une todos os gráficos
  grid.arrange(g1,g2,g3,g4,ncol=2,nrow=2)
}


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
