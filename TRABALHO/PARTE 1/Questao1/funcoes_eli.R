tabela.descritiva <- function(vetor){
  
  media=aggregate(vetor, by=list(dadosmoscas$Esp), mean)
  names(media)<-c("Especie", "Media")
  
  variancia=aggregate(vetor,by=list(dadosmoscas$Esp),var)
  names(variancia)<-c("Especie", "Variancia")
  
  desvio_padrao=aggregate(vetor, by=list(dadosmoscas$Esp), sd)
  names(desvio_padrao)<-c("Especie", "DP")
  
  cv=100*(desvio_padrao$DP/media$Media)
  
  mediana=aggregate(vetor, by=list(dadosmoscas$Esp), median)
  names(mediana)<-c("Especie", "Mediana")
  
  min=aggregate(vetor, by=list(dadosmoscas$Esp), min)
  names(min)<-c("Especie", "Minimo")
  
  max=aggregate(vetor, by=list(dadosmoscas$Esp), max)
  names(max)<-c("Especie", "Maximo")
  
  especie<-c("Carteri","Torrens")
  
  tabela_descritiva=cbind(especie,c(35,35),round(media$Media,3),round(variancia$Variancia,3), round(desvio_padrao$DP,3), round(cv,3), round(min$Minimo,3), round(mediana$Mediana,3), round(max$Maximo,3))
  colnames(tabela_descritiva)<-c("Especie","n","Media", "Variancia", "Desvio Padrao", "CV(%)", "Minimo", "Mediana", "Maximo")
  
  return(tabela_descritiva)  
}