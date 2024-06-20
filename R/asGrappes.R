asGrappes <- function(AS, alpha = 0.05){
  
  p <- 1 - alpha
  #pp <- p / 5
  
  # Vraiment utile?
  nv <- length(AS$pertinentes)
  #Gr <- list() 
  # for(k in 1:nv){
  #   Gr[k] <- AS$pertinentes[k]
  # }
  Gr <- sapply(1:nv, function(x) x, simplify = FALSE)
  # Gr <- AS$pertinentes ???
  
  # NEW ## Record nx
  AS$Z <- cbind(AS$Z,NA,NA)
  # ##
  for(k in 1:nrow(AS$Z)){
    a <- Gr[[AS$Z[k, 1]]]
    b <- Gr[[AS$Z[k, 2]]]
    nx <- length(a) * length(b)
    crit <- qchisq(p^(1 / nx), nv - 2) # à sortir
    # NEW ##
    AS$Z[k, 4] <- nx
    AS$Z[k, 5] <- crit
    # ##
    if(AS$Z[k, 3] < crit){
      Gr[[length(Gr)+1]] <- sort(c(a, b))
      Gr[[AS$Z[k, 1]]] <- numeric()
      Gr[[AS$Z[k, 2]]] <- numeric()
      AS$X2crit <- crit  
    } else {
      Gr[[length(Gr)+1]] <- numeric()
    }
  }
  AS$Gr <- Gr[sapply(Gr, function(x) length(x) >= 2)]
  AS$reste <- unlist(Gr[sapply(Gr, function(x) length(x) == 1)])
  if(length(AS$Gr) != 0){
  AS$Gr <- AS$Gr[sort(sapply(AS$Gr, length), 
                   index.return = TRUE, 
                   decreasing = TRUE)$ix]
  }
  # ADDED if no group found : if(length(AS$Gr) != 0){
  return(AS)
}
