asPairesIndicatrices <- function(AS){
  AS$Cpaires <- t(combn(AS$pertinentes, 2))
  nc <- nrow(AS$Cpaires)
  AS$Crit <- matrix(0, nc, 1)
  AS$Corr <- matrix(0, AS$nv, nc)
  AS$Ppaires <- matrix(0, nc, 1)
  for(k in 1:nc){
    AS <- asTuples(AS, k)
  }
  AS$Crit <- AS$Crit*(AS$N-1)
  AS$z2 <- AS$Corr^2 * (AS$N-1)
  return(AS)
}
