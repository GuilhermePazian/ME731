tabela.descritiva_regiao <- function(vetor){
  
  media=aggregate(vetor, by=list(dados2$Reg), mean)
  names(media)<-c("Regi�o", "Media")
  
  variancia=aggregate(vetor,by=list(dados2$Reg),var)
  names(variancia)<-c("Regi�o", "Variancia")
  
  desvio_padrao=aggregate(vetor, by=list(dados2$Reg), sd)
  names(desvio_padrao)<-c("Regi�o", "DP")
  
  cv=100*(desvio_padrao$DP/media$Media)
  
  mediana=aggregate(vetor, by=list(dados2$Reg), median)
  names(mediana)<-c("Regi�o", "Mediana")
  
  min=aggregate(vetor, by=list(dados2$Reg), min)
  names(min)<-c("Regi�o", "Minimo")
  
  max=aggregate(vetor, by=list(dados2$Reg), max)
  names(max)<-c("Regi�o", "Maximo")
  
  Regi�o<-c("Alasca", "Canad�")
  
  tabela_descritiva_regiao=cbind(Regi�o,c(50,50),round(media$Media,3),round(variancia$Variancia,3), round(desvio_padrao$DP,3), round(cv,3), round(min$Minimo,3), round(mediana$Mediana,3), round(max$Maximo,3))
  colnames(tabela_descritiva_regiao)<-c("Regi�o","n","Media", "Variancia", "Desvio Padrao", "CV(%)", "Minimo", "Mediana", "Maximo")
  
  return(tabela_descritiva_regiao)  
}


tabela.descritiva_genero <- function(vetor){
  
  media=aggregate(vetor, by=list(dados2$Gen), mean)
  names(media)<-c("G�nero", "Media")
  
  variancia=aggregate(vetor,by=list(dados2$Gen),var)
  names(variancia)<-c("G�nero", "Variancia")
  
  desvio_padrao=aggregate(vetor, by=list(dados2$Gen), sd)
  names(desvio_padrao)<-c("G�nero", "DP")
  
  cv=100*(desvio_padrao$DP/media$Media)
  
  mediana=aggregate(vetor, by=list(dados2$Gen), median)
  names(mediana)<-c("G�nero", "Mediana")
  
  min=aggregate(vetor, by=list(dados2$Gen), min)
  names(min)<-c("G�nero", "Minimo")
  
  max=aggregate(vetor, by=list(dados2$Gen), max)
  names(max)<-c("G�nero", "Maximo")
  
  G�nero<-c("F�mea", "Macho")
  
  tabela_descritiva_genero=cbind(G�nero,c(52,48),round(media$Media,3),round(variancia$Variancia,3), round(desvio_padrao$DP,3), round(cv,3), round(min$Minimo,3), round(mediana$Mediana,3), round(max$Maximo,3))
  colnames(tabela_descritiva_genero)<-c("G�nero","n","Media", "Variancia", "Desvio Padrao", "CV(%)", "Minimo", "Mediana", "Maximo")
  
  return(tabela_descritiva_genero)  
}