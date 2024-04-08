# DONE
croise <- function(A, B){
  dA <- dim(A)
  dB <- dim(B)
  tuple <- numeric()
  ligne <- matrix(0, dA[2]+dB[2], 1)
  for(j in 1:dA[1]){
    ligne[1:dA[2],] <- A[j,]
    for(k in 1:dB[1]){
      ligne[(dA[2] + 1):nrow(ligne)] <- B[k,]
      tuple <- rbind(tuple,
                     t(ligne))
    }
  }
  tuple
}
