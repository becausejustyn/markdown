# Elo Algorithm 

Fundamentally, Elo ratings are quite simple. All teams (or competitors for individual competition such as tennis), start with a baseline value e.g. 1500. The baseline is what an average team could expect their Elo value to be. 

- The beautiful thing about Elo scores, is that they translate to expected outcomes. 
- The starting Elo formula for calculating the expected outcome of a game is

$$
%Large
\huge \text{Expected Score} = \frac{1}{10^{\frac{(Team_{B} - Team_{A})}{\text{Scaling Factor}}}+1}
$$


This looks very similar to the logistic function, e.g.

$$
\huge f(x) = \frac{e^{\alpha + \beta X}}{1 + e^{\alpha + \beta X}}
$$

Which becomes more apparent as we look how Elo works.

- `Expected Score` is the win probability for $Team_{A}$
- $Team_{A}$ and $Team_{B}$ are the two teams playing `elo rating`
- `Scaling Factor` is an arbitary value that scales the values. Traditionally 400 is used, which means a difference in 400 Elo would give the favoured team a $90\%$ of winning.

For example, say $Team_{A}$ has an Elo rating of $1600$ and $Team_{B}$ has a rating of $1500$, then we simple input the values into the formula, giving $Team_{A}$ a $64\%$ chance of winning.

$$
\Large \begin{aligned} \text{Expected Score/Win Probability} & = \frac{1}{10^{\left( \frac{EloDiff}{400} \right)} + 1} \\
& = \frac{1}{10^{\frac{(1500 - 1600)}{400}}+1} \\ 
& = \frac{1}{10^{\frac{-100}{400}}+1} \\ 
& = 0.64 \end{aligned} 
$$


This can be done in `R` or `Python` with 

Python

```python
def get_expected_score(team_a, team_b):
    exp = (team_b - team_a) / 400
    return(1 / (1 + 10**exp))
```

R

```r
get_expected_score <- function(team_a, team_b){
  exp <- (team_b - team_a) / 400
    return(1 / (1 + 10^exp))
}
```


After each round or game, Elo values are adjusted depending if a team wins or loses. The amount values change after a single game is determined with $K$. 

- First each teams win probability is calculated like above
- Then the `difference` between their win probability (or expected score) and actual scores are used to make an adjustment
- To do this, games are scored as $0$ for a `loss`, $0.5$ for a `tie`, and $1$ for a `win`. 
- Once we have the difference between the `expected value` and `game result`, we multiple that value by our `K` value. 
- A larger $K$ creates more variance as the values get updated, whereas a lower $K$ value takes longer to adjust to new information. 538 in their Elo model use a $K$ of $25$.


$$
\underbrace{Elo_{Team_{A}}}_{\text{new Elo}} = \underbrace{Elo_{Team_{A}}}_{\text{old Elo}} + \text{ K Factor } \Big (\text{ Actual Score }_{Team_{A}} - \text{ Expected Score }_{Team_{A}}\Big )
$$

or

```
\underbrace{\text{New Elo = Old Elo}}_{\color{DarkBlue} Team_{A}} + \text{ K Factor } \times \underbrace{
\color{DarkGreen} \overbrace{\text{Actual Score}}^{\text{Game Result}} \color{Black} - \color{Orchid} \overbrace{\text{Expected Score}}^{\text{Win Prob}}}_{\color{DarkBlue} Team_{A}
}
```

For example, imagine $Team_{A}$ and $Team_{B}$ play each other in round 1 with an `Elo` of $1500$. Their expected score will both be $0.5$ since they have the same `Elo`. $Team_{A}$ beats $Team_{B}$, which leads to $Team_{A}$ being assigned a $1$ for the victory and $Team_{B}$ a $0$. As such we can do

For $Team_{A}$

$$
\Large \underbrace{Elo_{Team_{A}}}_{\text{new Elo}} = \underbrace{Elo_{Team_{A}}}_{\text{old Elo}} + 25 \times (1 - 0.5) = 1512.5
$$

or

$$
\Large \underbrace{\text{New Elo = } \overbrace{\quad 1500 \quad}^{\text{Old Elo}}}_{Team_{A}} + \overbrace{\quad 25 \quad}^{K} \times \left( \underbrace{\quad 1 \quad}_{\text{Won Game}} - \underbrace{\quad 0.5 \quad}_{\text{Win Prob}} \right) = 1512.5
$$

and $Team_{B}$

$$
\Large \underbrace{Elo_{Team_{B}}}_{\text{new Elo}} = \underbrace{Elo_{Team_{B}}}_{\text{old Elo}} + 25 \times (0 - 0.5) = 1487.5
$$

or

$$
\Large \underbrace{\text{New Elo = } \overbrace{\quad 1500 \quad}^{\text{Old Elo}}}_{Team_{B}} + \overbrace{\quad 25 \quad}^{K} \times \left( \underbrace{\quad 0 \quad}_{\text{Lost Game}} - \underbrace{\quad 0.5 \quad}_{\text{Win Prob}} \right) = 1487.5
$$

## Limitations

Autocorrelation: Elo systems that adjust for scoring difference can be cofounded since good teams can be predicted to be better than they are simply because historically they have done well. In short, a correlation between past results with future results.

## Point Spread

You can get an estimation of the point spread by dividing the difference in Elo points between the two teams by $25$. As such, if we assume that two teams are equally matched before accounting for home field advantage, and then give $Team_{A}$ $55$ points because they are the home team, we could assume that the model predicts the spread to be close to $\frac{55}{25}=2.2$. **Please note:** do not just use this to try and beat Vegas. Their odds account for much more than this model.


Calculating the new elo





Further reading
`https://blog.collegefootballdata.com/talking-tech-elo-ratings/`