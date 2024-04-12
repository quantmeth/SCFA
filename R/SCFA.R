SCFA <- function(R, N = NULL, factors.only = FALSE){
  if(is.null(N)){
    N <- nrow(R)
    R <- cov(R)
  }
  AS <- list(dat = R)
  AS$et <- sqrt(diag(R))
  iet <- 1/AS$et
  AS$R <- R * (iet %*% t(iet))  # cov2cor
  AS$N <- N
  AS$nv <- ncol(R)
  AS$GS <- chol(R)
  AS <- asOrphelines(AS)
  AS <- asPairesIndicatrices(AS)
  AS <- asDistances(AS)
  AS$Z <- linkage(AS$Dist)
  AS <- asGrappes(AS)
  AS$ng <- length(AS$Gr)
  if(AS$ng > 0){
    AS <- asCoplanaire(AS) # À Terminer pour ng >= 3
    if(!factors.only){
      AS$Fct <- matrix(0, AS$nv, AS$ng)
      AS <- asSaturations(AS)
      AS <- asCorrFct(AS)
      AS <- asVariableMulti(AS)
      AS$reprodR <- AS$Fct %*% AS$CorFct %*% t(AS$Fct)
    }
  }
  return(AS)
}

