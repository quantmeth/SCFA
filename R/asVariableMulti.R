asVariableMulti <- function(AS){
  ng <- length(AS$Gr)
  if(ng > 1){
    for(np in 2:ng){
      while((length(AS$reste) > 0) && (max(c(AS$reste, 0), na.rm = TRUE) > 0)){
        AS <- asMultiSatur(AS, np)
        while((length(AS$reste) > 0) && (AS$reste[1] < 0) && any(AS$reste > 0)){
          AS$reste <- c(AS$reste[-1], AS$reste[1])
          # ADDED ####
          # && any(AS$reste > 0) in the while
          # all AS$reste should be positive or while break
        }
      }
      if(length(AS$reste) > 0) AS$reste <- abs(AS$reste)
    }
  }
  return(AS)
}
