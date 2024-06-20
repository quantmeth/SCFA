#' Hierarchical clustering of variables from Signal Cancellation Factor Analysis
#'
#' @description Draw the hierarchical clustering of variables from Signal Cancelling Factor Analysis.
#'
#' @param x An object of class SCFA.
#' @param alpha Type I error rate to display for clustering of variables. Default is \eqn{\alpha = .01,.05,.20}.
#' @param ... Further arguments for other methods, ignored for "scfa".
#'
#' @return A plot output.
#' @export
#' @importFrom ggplot2 xlab ylab ggtitle theme_minimal geom_hline annotate
#' @importFrom ggdendro ggdendrogram
#' @importFrom stats hclust as.dist pchisq
#'
#' @examples
#' plot(SCFA(R = Achim24, N = 1000))
#' 
plot.SCFA <- function(x, alpha = c(.01,.05,.2), ...){
  a <- hclust(as.dist(x$Dist))
  a$height <- -log(1-pchisq(x$Z[,3],8),10)
  a$labels <- names(x$pertinentes)
  crit <- -log(alpha,10)

  ggdendro::ggdendrogram(a)+
    ggplot2::xlab("Variables") + 
    ggplot2::ylab(expression(log[10](P))) +
    ggplot2::ggtitle("Dendrogram of Signal Cancellation") + 
    ggplot2::theme_minimal() +
    ggplot2::geom_hline(yintercept = crit, linetype="dashed") + 
    # ggplot2::annotate("text",
    #                   label = c("alpha == .01", "alpha == .05","alpha == .20"),
    #                   x = max(a$order),
    #                   y = crit+max(a$height[is.finite(a$height)])/40, parse = TRUE)
    ggplot2::annotate("text", 
             x = max(a$order),  
             y = crit+max(a$height[is.finite(a$height)])/40,
             label = sapply(alpha, FUN = function(x) sprintf("alpha ==  '%0.2f'",x)), parse = TRUE)
  
  #      main = "Dendrogram of Signal Cancellation",
  #      xlab = "Variables",
  #      sub = "",
  #      ylab = "log_10(P)")
  # abline(h = -log(c(.05,.01,.2),10), col = "blue")
  # title("test")
  #abline(h = x$X2crit, col = "blue")
}

#AS$Z
#-log(1-(1-10^AS$Z[,3])^)


# %crit=chi2inv(p.^(1/nx),nv-2); 
# % -log10(1-(1-10.^-Z(k, 3)).^nx);
# % Z(k,3)=-log10(1-(1-10.^-Z(k,3)).^nx); %fig2 corrigée
# % Z(k,3)=-log10(1-(1-10.^-Z(k,3)).^1);  %fig1 non corrigé
# % P = 1-chi2cdf(Dist,np-2);
# % Dist = -log10(P);
# % ligne .2, .05 et .01