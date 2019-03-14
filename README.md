
<!-- README.md is generated from README.Rmd. Please edit that file -->
datacenter
==========

The goal of datacenter is to assist in the consolidation of information spread across multiple data sets.

Installation
------------

<!-- You can install the released version of datacenter from [CRAN](https://CRAN.R-project.org) with: -->
``` r
install.packages("datacenter")
```

You can install the development version of datacenter from [Github](https://github.com/mkearney/datacenter) with:

``` r
remotes::install_github("mkearney/datacenter")
```

Example
-------

Let's say you want to consolidate and maximize information (variables) for obversations spread across multiple different data sets.

``` r
## data set with variables v1, v2
data1 <- tibble::tibble(
  id = c("a", "b", "c"),
  v1 = c(TRUE, FALSE, FALSE),
  v2 = c(1, NA_real_, NA_real_)
)

## data set with variables v2, v3
data2 <- tibble::tibble(
  id = c("b", "c"),
  v2 = c(2, 3),
  v3 = c("z", "x")
)
```

Create a data center with a fixed set of variables

``` r
## create data center with all variables
dc <- new_datacenter(c(names(data1), names(data2)))

## print datacenter
dc
#> # A datacenter: 0 x 4
#> # … with 4 variables: id <lgl>, v1 <lgl>, v2 <lgl>, v3 <lgl>
```

``` r
## add data1 to datacenter
dc$add(data1)
dc
#> # A datacenter: 3 x 4
#>   id    v1       v2 v3   
#>   <chr> <lgl> <dbl> <lgl>
#> 1 a     TRUE      1 NA   
#> 2 b     FALSE    NA NA   
#> 3 c     FALSE    NA NA

## update datacenter with data2
dc$update(data2)
dc
#> # A datacenter: 3 x 4
#>   id    v1       v2 v3   
#>   <chr> <lgl> <dbl> <chr>
#> 1 a     TRUE      1 <NA> 
#> 2 b     FALSE     2 z    
#> 3 c     FALSE     3 x
```
