#' Signal Cancellation Factor Analysis
#'
#' @param R A correlation matrix or a data set.
#' @param N The sample size if a correlation matrix is supplied.
#' @param alpha Type I error rate on the hierarchical clustering of variables.
#' @param factors.only An option if only the number of dimensions is required.
#'
#' @return An object of class SCFA.
#' @export
#'
#' @importFrom stats cov optim pchisq qchisq qnorm cov2cor
#' @importFrom utils combn
#'
#' @references Achim, A. (2024, April 4). Signal cancellation factor analysis. \emph{PsyArXiv}, 1–13. \doi{10.31234/osf.io/h7qwg}
#'
#' @examples
#' SCFA(R = Achim24, N = 1000)
#' 
SCFA <- function(R, N = NULL, alpha = .05, factors.only = FALSE){
  if(is.null(N)){
    N <- nrow(R)
    R <- cov(R)
  }
  AS <- list()
  AS$R <- cov2cor(R)
  AS$N <- N
  AS$nv <- ncol(R)
  AS$GS <- chol(AS$R)
  AS <- asOrphelines(AS, alpha = alpha)
  AS <- asPairesIndicatrices(AS)
  AS <- asDistances(AS)
  AS$Z <- linkage(AS$Dist)
  AS <- asGrappes(AS, alpha = alpha) # alpha ici?
  AS$ng <- length(AS$Gr)
  if(AS$ng > 0){
    AS <- asCoplanaire(AS) # À Terminer pour ng >= 3     # alpha à ajouter
    # Voir car détecte 8 9  comme devant être retiré avec petit n
    # change 
    # si ng change
    AS$ng <- length(AS$Gr)
    # à checker
    
    # if factors.only = TRUE
    fct <- NULL
    CorFct <- NULL
    
    if(!factors.only){
      AS$Fct <- matrix(0, AS$nv, AS$ng)
      AS <- asSaturations(AS)
      AS <- asCorrFct(AS)                 # alpha à ajouter
      AS <- asVariableMulti(AS)
      AS$reprodR <- AS$Fct %*% AS$CorFct %*% t(AS$Fct)
      AS$Fit <- asFit(AS)
      
      # OUTPUT
      # fct CorFct, ng, dist, orpheline
      fct <- AS$Fct
      CorFct <- AS$CorFct
      colnames(fct) <- paste0("F", 1:AS$ng)
      rownames(fct) <- rownames(AS$R)
      rownames(CorFct) <- colnames(CorFct) <- colnames(fct)
    
    }
  }
  out <- list(nfactors = AS$ng,
              loadings = fct,
              corr.fact = CorFct,
              unique.variable = AS$orpheline,
              dist = AS$dist) 
  # alpha? (not sure) 
  # x2crit (yes for plot)? 
  # Z for plot
  # N (for summary) 
  # R for summary
  out <- structure(AS, class = "SCFA") # out
  return(out)
}

