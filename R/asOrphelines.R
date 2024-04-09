asOrphelines <- function(AS, alpha = 0.05){
  R <- AS$R - diag(AS$nv)
  z2 <- apply(abs(R), 2, max)^2 * (AS$N-1)
  AS$orphelines <- which(z2 < qchisq((1-alpha)^(1/(AS$nv-1)), 1))
  if(length(AS$orphelines) != 0){
    AS$GS[, AS$orphelines] <- 0
  }
  AS$pertinentes <- which(z2 >= qchisq((1-alpha)^(1/(AS$nv-1)), 1))
  return(AS)
}

#What if all unique?