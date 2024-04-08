asGrappes <- function(AS, alpha = 0.05){
  
  p <- 1 - alpha
  pp <- p / 5
  
  # Vraiment utile?
  nv <- length(AS$pertinentes)
  Gr <- list() 
  for(k in 1:nv){
    Gr[k] <- AS$pertinentes[k]
  }
  # Gr <- AS$pertinentes ???
  for(k in 1:nrow(AS$Z)){
    a <- Gr[[AS$Z[k, 1]]]
    b <- Gr[[AS$Z[k, 2]]]
    nx <- length(a) * length(b)
    crit <- qchisq(p^(1 / nx), 1) # à sortir
    if(AS$Z[k,3] < crit){
      Gr[[length(Gr)+1]] <- sort(c(a,b))
      Gr[[AS$Z[k, 1]]] <- numeric()
      Gr[[AS$Z[k, 2]]] <- numeric()
      AS$X2crit <- crit  
    } else {
      # crit <- qchisq(pp^(1 / nx), 1)
      # if(AS$Z[k,3] < crit){
      #   AS$GS
      #   R2 <- cor(AS$GS[,AS$Z[k,-3]])
      #   AS$X2crit <- crit  
      # } else {
      Gr[[length(Gr)+1]] <- numeric()
      #}
    }
  }
  AS$Gr <- Gr[sapply(Gr, function(x) length(x) >= 2)]
  AS$reste <- unlist(Gr[sapply(Gr, function(x) length(x) == 1)])
  AS$Gr <- AS$Gr[sort(sapply(AS$Gr, length), 
                   index.return = TRUE, 
                   decreasing = TRUE)$ix]
  return(AS)
}
