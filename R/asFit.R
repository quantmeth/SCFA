asFit <- function(AS) {
  pertinent <- 1:AS$nv  # temporarily ???
  nv <- length(pertinent)
  R <- AS$R[pertinent, pertinent]
  S <- AS$reprodR[pertinent, pertinent]
  diag(S) <- 1
  
  X2 <- (AS$N - 1) * (log(det(S)) - log(det(R)) + sum(diag(R %*% solve(S))) - nv)
  co <- AS$CorFct[upper.tri(AS$CorFct)]
  #  triU(AS$CorFct)
  df <- nv * (nv + 1) / 2 - nv - sum(AS$Fct != 0) - sum(co != 0)
  p <- 1 - pchisq(X2, df)
  
  return(list(p = p, X2 = X2, df = df))
}

triU <- function(matrix) {
  matrix[upper.tri(matrix)]
}
