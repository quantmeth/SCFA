# Cpaires, Ppaires, R
asSatPaire <- function(AS, v){
  inverse <- v[1] > v[2] # Techniquement impossible ???
  if(inverse) v <- v[c(2, 1)]
  
  r <- AS$R[v[1], v[2]]
  pa <- which(apply(AS$Cpaires == matrix(v, nrow(AS$Cpaires), 2, byrow = TRUE), 1, all))
  p <- AS$Ppaires[pa]
  if((p * r) < 0){
    sat <- c(0, 0)
  } else {
    s1 <- sqrt(r/p)
    s2 <- r/s1
    if(inverse) {
      sat <- c(s2, s1)
    } else{
      sat <- c(s1, s2)
    }
  }
  return(sat)
}
