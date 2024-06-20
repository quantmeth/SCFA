asCoplanaire <- function(AS) {
  
  options <- list(maxit = 1e9,
                  factr = 1e-6,
                  pgtol = 1e-6)
  
  AS$coplan <- list()
  AS$GrCoplan <- list()
  ote <- NULL
  ng <- length(AS$Gr)
  if (ng < 3) {
    
  } else {
    
    trios <- combn(1:ng, 3, simplify = FALSE)
    cible <- 1:length(AS$pertinent)
    
    for (tri in trios) { # for each trio of groups
      nt <- 0
      pire <- 0
      for (i in AS$Gr[[tri[1]]]) {
        for (j in AS$Gr[[tri[2]]]) {
          for (k in AS$Gr[[tri[3]]]) {
            nt <- nt + 1
            melange <- c(i, j, k)
            if (any(melange < 0)) { # ignore a group to exclude
              pire <- -1
            } else {
              # if the two largest correlations are not essentially equal,
              # try with new initializations
              # POUR ANDRÉ : AJOUTER 0 
              mul <- c(1, 0.5, 2, 0)
              for (e in 1:length(mul)) {
                P <- sign(crossprod(AS$GS[, melange[1:(length(melange) - 1)]], AS$GS[, melange[length(melange)]]))
                P <- mul[e] * P / sqrt(length(P))
                result <- optim(P, 
                                fn = asCrit, 
                                G = AS$GS, 
                                combine = melange, 
                                cible = cible, 
                                method = "Nelder-Mead", 
                                control = options)
                P <- result$par
                cr <- result$value
                cor <- asCrit(P, AS$GS, melange, cible, to.opt = FALSE)$corr
                cor <- t(cor)
                cc <- sort(abs(cor))
                # POUR ANDRÉ : P peut être négatif?
                #
                if (((cc[length(cc)] - cc[length(cc) - 1]) < 0.0001) && all(abs(log10(abs(P)) < 2))) {
                  break
                }
              }#
              if (cc[length(cc)] - cc[length(cc) - 1] > 0.0001) {
                stop("Optimization did not find a true minimum")
              }
              if (cr > pire) {
                pire <- cr
              }
            }
          }
          if (pire > 0) {
            pire <- pire * (AS$N - 1)
            if (pire < qchisq(0.95^(1 / nt), df = 1)) { # the groups in tri seem coplanar
              # calculate saturations from the first two group variables
              s <- matrix(0, nrow = 3, ncol = 2)
              v <- matrix(0, nrow = 3, ncol = 2)
              for (g in 1:3) {
                v[g, ] <- AS$Gr[[tri[g]]][1:2] # the first two variables of each group
                s[g, ] <- asSatPaire(AS, v[g, ]) # their saturations
              }
              C <- matrix(0, nrow = 3, ncol = 3)
              for (g1 in 1:2) {
                for (g2 in (g1 + 1):3) { # for the three pairs of groups
                  co <- 0
                  for (j in 1:2) { # for the two variables of the first group
                    for (k in 1:2) { # two variables of the second group correlated to those of the first
                      co <- co + crossprod(AS$GS[, v[g1, j]], AS$GS[, v[g2, k]]) / (s[g1, j] * s[g2, k])
                    }
                  }
                  C[g1, g2] <- abs(co) / 4
                }
              }
              C <- C[upper.tri(C, diag = TRUE)]
              mi <- min(C) # correlation of the most orthogonal pair
              f <- 4 - which.min(C) # positions in C are 12, 13 and 23, the missing ranks are 3, 2, and 1 respectively
              f <- tri[f]
              ote <- c(ote, f)
              AS$GrCoplan[[length(AS$GrCoplan) + 1]] <- AS$Gr[[f]]
              AS$Gr[[f]] <- -AS$Gr[[f]]
              # keep track in AS$coplan
              AS$coplan <- rbind(AS$coplan, tri)
            }
          }
        }
      }
    }
    if(!is.null(ote)){
      for (k in 1:length(ote)) {
        AS$reste <- c(AS$reste, -AS$Gr[[ote[k]]])
      }
      AS$Gr <- AS$Gr[-ote]
    }
  }
  return(AS)
}
