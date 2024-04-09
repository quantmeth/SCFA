
# SCFA: Signal Cancelling Factor Analysis

The library `SCFA` is an **R** implementation of the Signal Cancelling
Factor Analysis (SCFA) developped by Achim (2024, April 4). It provides
a main function `SCFA()` to carry the analysis. Currently in
development.

# Installation

The development version can be accessed through GitHub:

``` r
remotes::install_github(repo = "quantmeth/SCFA")
library(SCFA)
```

# Examples

Here is an example using the `ex_4factors_corr` correlation matrix from
the `Rnest` library. The factor structure is

<p align="center">
<img src="inst/ex_4factors_corr.png" width="50%" height="50%" style="display: block; margin: auto;" />
</p>

and the correlation matrix is

$$\begin{bmatrix}
1&0.81&0.27&0.567&0.567&0.189&0&0&0&0&0&0 \\
0.81&1&0.27&0.567&0.567&0.189&0&0&0&0&0&0 \\
0.27&0.27&1&0.189&0.189&0.063&0&0&0&0&0&0 \\
0.567&0.567&0.189&1&0.81&0.27&0&0&0&0&0&0 \\
0.567&0.567&0.189&0.81&1&0.27&0&0&0&0&0&0 \\
0.189&0.189&0.063&0.27&0.27&1&0&0&0&0&0&0 \\
0&0&0&0&0&0&1&0.81&0.27&0.567&0.567&0.189 \\
0&0&0&0&0&0&0.81&1&0.27&0.567&0.567&0.189 \\
0&0&0&0&0&0&0.27&0.27&1&0.189&0.189&0.063 \\
0&0&0&0&0&0&0.567&0.567&0.189&1&0.81&0.27 \\
0&0&0&0&0&0&0.567&0.567&0.189&0.81&1&0.27 \\
0&0&0&0&0&0&0.189&0.189&0.063&0.27&0.27&1 \\
\end{bmatrix}$$

From `ex_4factors_corr`, we can easily generate random data using the
`MASS` packages (Venables & Ripley, 2002).

``` r
set.seed(4)
mydata <- MASS::mvrnorm(n = 200,
                        mu = rep(0, ncol(ex_4factors_corr)),
                        Sigma = ex_4factors_corr)
```

We can then carry SCFA

``` r
output <- SCFA(mydata)
```

and the results.

``` r
# The number of factors
output$ng
```

    ## [1] 4

``` r
# The factorial structure
output$Fct
```

    ##            [,1]      [,2]      [,3]      [,4]
    ##  [1,] 0.0000000 0.0000000 0.0000000 0.9475771
    ##  [2,] 0.0000000 0.0000000 0.0000000 0.7999968
    ##  [3,] 0.0000000 0.0000000 0.0000000 0.3682050
    ##  [4,] 1.0648506 0.0000000 0.0000000 0.0000000
    ##  [5,] 0.8807150 0.0000000 0.0000000 0.0000000
    ##  [6,] 0.1883421 0.0000000 0.0000000 0.0000000
    ##  [7,] 0.0000000 0.9408338 0.0000000 0.0000000
    ##  [8,] 0.0000000 0.7878626 0.0000000 0.0000000
    ##  [9,] 0.0000000 0.2713004 0.0000000 0.0000000
    ## [10,] 0.0000000 0.0000000 0.9350918 0.0000000
    ## [11,] 0.0000000 0.0000000 0.8844697 0.0000000
    ## [12,] 0.0000000 0.0000000 0.2806946 0.0000000

``` r
# The correlation between factors
output$CorFct
```

    ##           [,1]      [,2]      [,3]      [,4]
    ## [1,] 1.0000000 0.0000000 0.0000000 0.6723476
    ## [2,] 0.0000000 1.0000000 0.7169519 0.0000000
    ## [3,] 0.0000000 0.7169519 1.0000000 0.0000000
    ## [4,] 0.6723476 0.0000000 0.0000000 1.0000000

Plotting, print and summary functions coming soon.

<!-- We can visualize the results using the generic function `plot()`. -->
<!-- ```{r plot, fig.cap="Scree plot of NEST", imgcenter='center'} -->
<!-- res <- nest(mydata) -->
<!-- plot(res) -->
<!-- ``` -->
<!-- The above figure shows the empirical eigenvalues in blue and the 95^th^ percentile of the sampled eigenvalues. -->
<!-- It is also possible to use a correlation matrix directly. A sample size, `n` must be supplied. -->
<!-- ```{r nest2} -->
<!-- nest(ex_4factors_corr, n = 240) -->
<!-- ``` -->
<!-- The `nest()` function can use with many $\alpha$ values if desired. -->
<!-- ```{r plot2, fig.cap="Scree plot of NEST with many $\\alpha$", imgcenter='center'} -->
<!-- res <- nest(ex_4factors_corr, n = 120, alpha = c(.01,.025,.05,.1)) -->
<!-- plot(res) -->
<!-- ``` -->

# How to cite

Caron, P.-O. (2023). *SCFA: Signal Cancelling Factor Analysis*.
<https://github.com/quantmeth/Rnest>

# References

<div id="refs" class="references csl-bib-body hanging-indent"
line-spacing="2">

<div id="ref-Achim24" class="csl-entry">

Achim, A. (2024, April 4). Signal cancellation factor analysis.
*PsyArXiv*, 1–13. <https://doi.org/10.31234/osf.io/h7qwg>

</div>

<div id="ref-MASS" class="csl-entry">

Venables, W. N., & Ripley, B. D. (2002). *Modern applied statistics with
S*. Springer. <https://www.stats.ox.ac.uk/pub/MASS4/>

</div>

</div>
