###### Funções do Caio Referente à MANOVA

########
#Funções Gerais
########

Box.teste.Igual.MCov<-function(m.X.completa,v.grupos,v.n,G)
{
  # v.grupos (1,2,3...)
  # m.X.completa : matriz de dados com todos os grupos
  grupo <- 1
  p<- ncol(m.X.completa)
  m.X.k <- m.X.completa[v.grupos==grupo,]
  Sigma.k <- cov(m.X.k)
  m.Sigma.completa <- cbind(grupo,Sigma.k)
  Sigma.P <- (v.n[grupo]-1)*Sigma.k # estimativa ponderada
  aux.k.1 <- (v.n[grupo] - 1)*log(det(Sigma.k))
  grupo <- grupo + 1
  for (i in 2:G)
  {
    m.X.k <- m.X.completa[v.grupos==grupo,] # pegar os dados referentes ao grupo i
    Sigma.k <- cov(m.X.k)
    m.Sigma.completa <- rbind(m.Sigma.completa,cbind(grupo,Sigma.k))
    Sigma.P <- Sigma.P + (v.n[grupo]-1)*Sigma.k # estimativa ponderada
    aux.k.1 <- aux.k.1 + (v.n[grupo] - 1)*log(det(Sigma.k))
    grupo <- grupo + 1
  }
  Sigma.P <- Sigma.P/(sum(v.n)-G)
  
  # Estatística de ajuste
  aux.u <- (sum(1/(v.n - 1)) - (1/(sum(v.n - 1))))*(2*p^2 + 3*p - 1)/(6*(p+1)*(G-1))
  Q.B <-  (1 - aux.u)*(sum(v.n-1)*log(det(Sigma.P)) - aux.k.1)
  aux.v <- 0.5*p*(p+1)*(G-1)
  e.nd.QB <- 1 - pchisq(Q.B,aux.v)
  cat("Estatística do Teste: ", Q.B, "\n")
  cat("nível descritivo: ",e.nd.QB,"\n")
  cat("Matrizes de Covariâncias por grupo: \n")
  print(m.Sigma.completa)
  Sigma.P <-as.matrix(data.frame(Sigma.P))
  #mudei aqui para conseguir printar o pvalor e o qui-quadrado mais fácil
  return(list(Sigma.P=Sigma.P,p.valor = e.nd.QB, est.test = Q.B))
} # fim fa função


TesteF.CBU.M<-function(fit.model,m.Sigma.P,p,G,m.C,m.U,m.M)
{
  m.B <- matrix(coef(fit.model),G,p)
  v.beta <- matrix(t(m.B))
  m.X <- model.matrix(fit.model)
  m.Ca <- kronecker(m.C,t(m.U))
  m.Ma <- matrix(t(m.M))
  v.theta <- m.Ca%*%v.beta - m.Ma
  m.Sigmabeta <- kronecker(solve(t(m.X)%*%m.X),m.Sigma.P)
  estat <- t(v.theta)%*%solve(m.Ca%*%(m.Sigmabeta)%*%t(m.Ca))%*%v.theta
  p.valor <- 1-pchisq(estat,df=nrow(m.C)*ncol(m.U))
  cat("Estatistica Qui-quadrado = ",round(estat,2),"\n")
  cat("pvalor = ",round(p.valor,4),"\n")
  cat("Matriz C :","\n")
  print(m.C)
  cat("Matriz U :","\n")
  print(m.U)
  cat("Matriz M :","\n")
  print(m.M)
  return(list(pvalor = p.valor,M = m.M,U = m.U,C = m.C,estatqui = estat))
}




#########
#Análise de diagnóstico
#########



gen.graf.resid<-function(mY,mresult,var,typeresid,wplot)
{
  mresiduo <- mresult$residuals
  mbeta <- coef(mresult) 
  mX <- as.matrix(model.matrix(mresult))
  n <- nrow(mX)
  p <- ncol(mbeta)
  q <- nrow(mbeta)
  mSigma<-t(mY-mX%*%mbeta)%*%(mY-mX%*%mbeta)/(n-q)
  if (typeresid == "univariate")
  {
    auxres <- diag((diag(n) - mX%*%solve(t(mX)%*%mX)%*%t(mX)))
    mresiduo <- mresiduo/(sqrt((matrix(auxres,n,p))%*%diag(diag(mSigma))))
  }
  else if (typeresid == "multivariate")
  {
    mresiduo <- t(solve(t(chol(mSigma)))%*%t(mresiduo))
  }
  mfit <- fitted.values(mresult)
  #
  if (wplot == "diagnostics")
  {
    par(mfrow =c(2,2))
    plot(mresiduo[,var],ylim=c(min(-3,min(mresiduo[,var])),max(3,max(mresiduo[,var]))),xlab="índice",ylab="resíduo studentizado",main = "gráfico 1")
    abline(-2,0,lty=2)
    abline(2,0,lty=2)
    abline(0,0,lty=2)
    #
    plot(mfit[,var],mresiduo[,var],ylim=c(min(-3,min(mresiduo[,var])),max(3,max(mresiduo[,var]))),xlab="valor ajustado",ylab="resíduo studentizado",main = "gráfico 2")
    abline(-2,0,lty=2)
    abline(2,0,lty=2)
    abline(0,0,lty=2)
    #
    hist(mresiduo[,var],probability=TRUE,xlab="resíduo studentizado",ylab="densidade",main = "gráfico 3")
    #
    qqPlot((mresiduo[,var]),dist="norm",mean=0,sd=1,col.lines=1,grid="FALSE",xlab="quantil da N(0,1)",ylab=paste("quantil do resíduo studentizado"),cex=1.2,id.cex=1.2, main = "gráfico 4")
  }
  
  else if (wplot == "envelope")
  {
    par(mfrow =c(1,1))
    qqPlot((mresiduo[,var]),dist="norm",mean=0,sd=1,col.lines=1,grid="FALSE",xlab="quantil da N(0,1)",ylab=paste("quantil do resíduo studentizado"),cex=1.2,id.cex=1.2, main = "gráfico 1")
  }
}

gen.graf.resid.quad.form<-function(mY,mresult)
{
  mresiduo <- mresult$residuals
  mbeta <- coef(mresult) 
  mX <- as.matrix(model.matrix(mresult))
  n <- nrow(mX)
  p <- ncol(mbeta)
  q <- nrow(mbeta)
  mSigma<-t(mY-mX%*%mbeta)%*%(mY-mX%*%mbeta)/(n-q)
  vmu<- apply(mresiduo,2,mean)
  #vresid <- n*apply(((mresiduo-vmu)*(mresiduo-vmu)%*%solve(mSigma)),1,sum)
  vresid <- n*mahalanobis(mresiduo,center=vmu,cov=mSigma)
  #vresid<- #(n-nvar)*vresid/((n-1)*n)
  nvar <- length(vmu)
  n <- length(vresid)
  #  qqPlot(vresid,dist="chisq",df=nvar,col.lines=1,grid="FALSE",xlab="quantil da distribuição qui-quadrado",ylab="quantil da forma quadrática",cex=1.2,id.cex=1.2)
  mX <- model.matrix(mresult)
  vresidA <- matrix(0,n,1)
  #mident <- diag(1,p)
  for (i in 1:n)
  {
    mXi <- rbind(mX[i,])
    mYi <- rbind(mY[i,])
    Ai <- 1 - mXi%*%solve(t(mX)%*%mX)%*%t(mXi)
    vresidA[i] <- (Ai^(-2))*mYi%*%solve(mSigma)%*%t(mYi)
  }
  #par(mfrow =c(1,1)) #tirei para conseguir juntar os gráficos
  car::qqPlot(vresidA,dist="chisq",df=nvar,col.lines=1,grid="FALSE",xlab="quantil da distribuição qui-quadrado",ylab="quantil da forma quadrática",cex=1.2,id.cex=1.2)
  
}  