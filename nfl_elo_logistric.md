# Elo and Logistic Regression



$$
\Large \text{Expected Score} = \frac{1}{10^{\frac{(Team_{B} - Team_{A})}{\text{Scaling Factor}}}+1}
$$

Instead of the typical $log_{e}$ odds, Arpad Elo used $log_{10}$ hence the `10` in the formula.

Odds is the probability an event happens divided by the probability that it does not happen, e.g. 4:1 odds imply an 80% chance of an event occuring (0.8/0.2 = 4). Thus, the log odds is

$$
\Large a = \log \frac{\text{P }(\mathbf{x} \; | \; y=1)\text{ P }(y=1)}{\text{P }(\mathbf{x} \;|\; y=0)\text{ P }(y=0)}
$$

Note: here we are using $log_{e}$

Using Bayes, we get

$$
\Large \begin{align*}
P(y = 1 \; |\; \mathbf{x}) &= \frac{P(\mathbf{x}\;|\; y = 1)P(y = 1)}{\sum_{k} P(\mathbf{x}\;|\; y = k)P(y = k)} \\
&= \frac{1}{1+\frac{P(\mathbf{x}\;|\; y \;=\; 0)P(y \;=\; 0)}{P(\mathbf{x}\;|\; y \;= \;1)P(y \;=\; 1)}} \\
&= \frac{1}{1+e^{-a}}
\end{align*} 
$$

If we assume the conditional densities are normal with a shared covariance matrix and equally likely classes, then

$$
\Large \text{Pr}(y=1\;| \;\mathbf{x}; \mathbf{w}) = \sigma(\mathbf{w}^T \mathbf{x})
$$

for some `weight` vector $\mathbf{w}$. With the data likelihood

$$
\Large \text{P}(\text{Data}\;|\;\mathbf{w}) = \prod_{i=1}^{N} \sigma^{y_{i}} (1-\sigma)^{1-y_{i}}
$$

Then we want the negative log likelihood

$$
\Large -\log \; \text{Pr}(\text{Data}\;|\;\mathbf{w}) = -\sum_{i=1}^{N} y_{i} \; \ln \; \sigma + (1-y_{i}) \; \ln \; (1-\sigma)
$$

### Stochastic Gradient Descent

Gradient descent simply is the technique of searching for a minumum by taking small steps towards the negative gradient:

$$
\Large \begin{equation}
\mathbf{w}_{k+1} = \mathbf{w}_{k} - \alpha \ \nabla E(\mathbf{w}_{k})
\end{equation}
$$

Where

- $\alpha$ influences how fast the update our estimate of $\mathbf{w}$.
- You are able to evaluate the gradient at **one** of the terms in the sum, then move in that direction, and you will likely reach a minimum, so long as you keep picking random terms and you do it enough times!  
    - I find this really cool!
- The `stochastic` comes from the random aspect. 
- It comes into play for logistic regression as such

$$
\Large \mathbf{w}_{k \; + \; 1} = \mathbf{w}_{k} - \alpha\left( \sigma \; (\mathbf{w}_{k^T} \; \mathbf{x}_{i}) - t_{i} \right) \; \mathbf{x}_{i}
$$

or

$$
\begin{equation}
\Large \mathbf{w}_{k \; + \; 1} = \mathbf{w}_{k} - \alpha\left( \sigma \; (\mathbf{w}_{k^T} \; \mathbf{x}_{i}) - t_{i} \right) \; \mathbf{x}_{i}
\end{equation}
$$

### NFL Example

The `weight` vector $\mathbf{w}$ is now the ratings of all 32 teams.  Let's denote a specific game between teams $Team_{A}$ and $Team_{B}$ as the datapoint $\big(\mathbf{x}_{(Team_{A}, Team_{B})} \; , \; y_{(Team_{A}, Team_{B})}\big)$, where:

$$
\Large \mathbf{x}_{(Team_{A} \; Team_{B})} = [x_k] = \begin{cases}
1 & k = Team_{A} \\
-1 & k = Team_{B} \\
0 & \text{otherwise}
\end{cases}
$$

and $y \; {(Team_{A} \; Team_{B})} = 1$ if $Team_{A}$ wins, 0 if $Team_{B}$ wins.  The class conditional probability of $Team_{A}$ winning is then

$$
\large P \Big( y \; {\big(Team_{A} \; Team_{B}\big)} = 1 \; | \; \mathbf{x}{\big(Team_{A} \; Team_{B}\big)}; \; \mathbf{w}\Big) = \sigma\Big(\mathbf{w}^T \; \mathbf{x}{\big(Team_{A} \; Team_{B}\big)} \Big)
$$

since $\mathbf{w}^{T} \mathbf{x}_{(Team_{A} \; Team_{B})} = w_{Team_{A}} - w_{Team_{B}}$ or in Elo notation, $\text{elo}_{Team_{A}} - \text{elo}_{Team_{B}}$.  Then given some initial estimate of the weight vector $\mathbf{w}_{0}$, we can hone our estimate of the `weights` by iteratively applying an SGD step on the data,

$$
\Large \mathbf{w}_{k+1} = \mathbf{w}_{k} - \alpha \ \Big(\sigma \big(\mathbf{w}_k^T \; \mathbf{x}{(Team_{A} \; Team_{B})}\big) - 1\Big) \; \mathbf{x} {(Team_{A} \; Team_{B})}
$$

or if we want to get gritty

$$
\large \begin{bmatrix} 
w_{1} \\ 
\dots \\ 
w_{Team_{A}} \\ 
w_{Team_{B}} \\ 
\dots \\ 
w_{N} 
\end{bmatrix}_{k+1} = \begin{bmatrix} 
w_{1} \\ 
\dots \\ 
w_{Team_{A}} \\ 
w_{Team_{B}} \\ 
\dots \\ 
w_{N}  
\end{bmatrix}_{k} + \alpha \left(1 - \frac{1}{1+e^{-\Big(w_{Team_{A}} - w_{Team_{B}}\Big)}}\right) 
\begin{bmatrix} 
0 \\ 
\dots \\ 
1 \\ 
-1 \\ 
\dots \\ 
0 \end{bmatrix}
$$



- The only two lines where anything's going on out of this update correspond to the two Elo update equations for a game up.  
- Lots of signs flipping back and forth, and don't forget $\sigma(-a)=1-\sigma(a)$, but they're the same!  

> From a high level, `Elo` ratings are actually `weights` of a **logistic regression** to predict pairwise game outcomes, which we learn through SGD-like updates over streaming data.

`https://stmorse.github.io/journal/Elo.html`

A common improvement to first order methods like GD/SGD is incorporation of **momentum**. (Here's a [beautiful Distill.pub article](https://distill.pub/2017/momentum/) about it.)  A simple example is the following modified gradient step:
