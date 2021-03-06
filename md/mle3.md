
# MLE

$$
\mathcal{L}(\theta) = \prod_{i = 1}^{n} f(x_{i})
$$

***

Given a sample of data, what is the unknown probability distribution that most likely generated it?

To perform maximum likelihood estimation, one thus needs to assume a certain probability distribution, and then look for the parameters that maximize the likelihood that this distribution generated the observed data. So, now the question is, how to maximize this likelihood? And mathematically speaking, what is a likelihood?

Let $X_{i}$ be random variables, and $x_{i}$ be their realizations (actual observed values). Let’s assume that the $X_{i}$ are distributed according to a certain probability distribution $D$ with density $f(\theta)$ where $\theta$ is a parameter of said distribution. Because our sample is composed of i.i.d. random variables, the probability that it was generated by our distribution $D(\theta)$ is:

$$\prod_{i = 1}^{N}Pr(X_{i} = x_{i})$$

It is customary to take the log of this expression:

$$log(\prod_{i = 1}^{N}Pr(X_{i} = x_{i})) = \sum_{i = 1}^{N} log(Pr(X_{i} = x_{i}))$$

The expression above is called the log-likelihood, logL(\theta; x_{1}, \dots, x_{n}). Maximizing this function yields $\theta^{*}$, the value of the parameter that makes the sample the most probable. In the case of linear regression, the density function to use is the one from the Normal distribution.

```r
library(tidyverse)
size <- 500000

x1 <- rnorm(size)
x2 <- rnorm(size)
x3 <- rnorm(size)

dep_y <- 1.5 + 2*x1 + 3*x2 + 4*x3 + rnorm(size)

x_data <- cbind(dep_y, 1, x1, x2, x3)

x_df <- as.data.frame(x_data) %>%
  rename(iota = V2)

head(x_df)
```

Writing a function to perform Maximum Likelihood Estimation

```r
loglik_linmod <- function(parameters, x_data){
  sum_log_likelihood <- x_data %>%
    mutate(log_likelihood =
             dnorm(dep_y,
                   mean = iota*parameters[1] + x1*parameters[2] + x2*parameters[3] + x3*parameters[4],
                   sd = parameters[5],
                   log = TRUE)) %>%
    summarise(sum(log_likelihood))

  -1 * sum_log_likelihood
}
```

The function returns minus the log likelihood, because `optim()`` which I will be using to optimize the log-likelihood function minimizes functions by default (minimizing the opposite of a function is the same as maximizing a function). Let’s optimize the function and see if we’re able to find the parameters of the data generating process, `1.5, 2, 3, 4` and `1` (the standard deviation of the error term):

```r
optim(c(1,1,1,1,1), loglik_linmod, x_data = x_df)
```
