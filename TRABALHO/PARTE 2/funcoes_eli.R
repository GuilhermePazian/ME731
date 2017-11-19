tabela.descritiva_regiao <- function(vetor){
  
  media=aggregate(vetor, by=list(dados2$Reg), mean)
  names(media)<-c("Região", "Media")
  
  variancia=aggregate(vetor,by=list(dados2$Reg),var)
  names(variancia)<-c("Região", "Variancia")
  
  desvio_padrao=aggregate(vetor, by=list(dados2$Reg), sd)
  names(desvio_padrao)<-c("Região", "DP")
  
  cv=100*(desvio_padrao$DP/media$Media)
  
  mediana=aggregate(vetor, by=list(dados2$Reg), median)
  names(mediana)<-c("Região", "Mediana")
  
  min=aggregate(vetor, by=list(dados2$Reg), min)
  names(min)<-c("Região", "Minimo")
  
  max=aggregate(vetor, by=list(dados2$Reg), max)
  names(max)<-c("Região", "Maximo")
  
  Região<-c("Alasca", "Canadá")
  
  tabela_descritiva_regiao=cbind(Região,c(50,50),round(media$Media,3),round(variancia$Variancia,3), round(desvio_padrao$DP,3), round(cv,3), round(min$Minimo,3), round(mediana$Mediana,3), round(max$Maximo,3))
  colnames(tabela_descritiva_regiao)<-c("Região","n","Media", "Variancia", "Desvio Padrao", "CV(%)", "Minimo", "Mediana", "Maximo")
  
  return(tabela_descritiva_regiao)  
}


tabela.descritiva_genero <- function(vetor){
  
  media=aggregate(vetor, by=list(dados2$Gen), mean)
  names(media)<-c("Gênero", "Media")
  
  variancia=aggregate(vetor,by=list(dados2$Gen),var)
  names(variancia)<-c("Gênero", "Variancia")
  
  desvio_padrao=aggregate(vetor, by=list(dados2$Gen), sd)
  names(desvio_padrao)<-c("Gênero", "DP")
  
  cv=100*(desvio_padrao$DP/media$Media)
  
  mediana=aggregate(vetor, by=list(dados2$Gen), median)
  names(mediana)<-c("Gênero", "Mediana")
  
  min=aggregate(vetor, by=list(dados2$Gen), min)
  names(min)<-c("Gênero", "Minimo")
  
  max=aggregate(vetor, by=list(dados2$Gen), max)
  names(max)<-c("Gênero", "Maximo")
  
  Gênero<-c("Fêmea", "Macho")
  
  tabela_descritiva_genero=cbind(Gênero,c(52,48),round(media$Media,3),round(variancia$Variancia,3), round(desvio_padrao$DP,3), round(cv,3), round(min$Minimo,3), round(mediana$Mediana,3), round(max$Maximo,3))
  colnames(tabela_descritiva_genero)<-c("Gênero","n","Media", "Variancia", "Desvio Padrao", "CV(%)", "Minimo", "Mediana", "Maximo")
  
  return(tabela_descritiva_genero)  
}