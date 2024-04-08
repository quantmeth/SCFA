sapply(c("R/asCrit.R",
         "R/linkage.R",
         "R/asDistances.R",
         "R/asOrphelines.R",
         "R/asTuples.R",
         "R/asPairesIndicatrices.R",
         "R/asGrappes.R",
         "R/asCoplanaire.R",
         "R/asSatPaire.R",
         "R/asSaturations.R",
         "R/asVariableMulti.R",
         "R/asCorrFct.R",
         "R/asMultiSatur.R"),
       source)
R <- round(Rnest::ex_3factors_doub_unique, 3)
R <- round(Rnest::ex_4factors_corr, 3)

SCFA <- function(R, N = NULL){
  if(is.null(N)){
    N <- nrow(R)
    R <- cov(R)
  }
  AS <- list(dat = R)
  AS$et <- sqrt(diag(R))
  iet <- 1/AS$et
  AS$R <- R * (iet %*% t(iet))
  AS$N <- N
  AS$nv <- ncol(R)
  AS$GS <- chol(R)
  AS <- asOrphelines(AS)
  AS <- asPairesIndicatrices(AS)
  AS <- asDistances(AS)
  AS$Z <- linkage(AS$Dist)
  AS <- asGrappes(AS)
  AS <- asCoplanaire(AS) # À Terminer pour ng >= 3
  AS$ng <- length(AS$Gr)
  AS$Fct <- matrix(0, AS$nv, AS$ng)
  AS <- asSaturations(AS)
  AS <- asCorrFct(AS)
  AS <- asVariableMulti(AS)
  AS$reprodR <- AS$Fct %*% AS$CorFct %*% t(AS$Fct)
  return(AS)
}
