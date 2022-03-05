## Elo Python

`https://andr3w321.com/elo-ratings-part-1/`

For a simple overview of Elo everyone with no record is assigned a default rating of 1500. 

If two teams rated at 1500 play each other with a k value of 20: 

- the winner would end up with a 1510 rating,
- the loser ending on a 1490 rating. 

The trick of Elo comes when two teams of drastically different ratings play each other. 

For example when 1600 beats 1400 with a K value of 20, the new ratings are only 1602 and 1398. Not much changed – only a difference of 2 because the favorite won and was expected to win. However, if 1400 beats 1600, the new ratings would be 1418 and 1582. A much bigger change of 18, because a huge upset occurred its likely that the original 1400 and 1600 rating were incorrect.

```python
def rate_1vs1(p1, p2, k=20, drawn=False):
    rp1 = 10 ** (p1/400)
    rp2 = 10 ** (p2/400)
    exp_p1 = rp1 / float(rp1 + rp2)
    exp_p2 = rp2 / float(rp1 + rp2)
    if drawn == True:
        s1 = 0.5
        s2 = 0.5
    else:
        s1 = 1
        s2 = 0
    new_p1 = p1 + k * (s1 - exp_p1)
    new_p2 = p2 + k * (s2 - exp_p2)
    return(new_p1, new_p2)
    
# if you need a win probability function

def win_probability(p1, p2):
    diff = p1 - p2
    p = 1 - 1 / (1 + 10 ** (diff / 400.0))
    return(p)
```

Example of the code

```python
rate_1vs1(1600,1400)
#(1601.8181818181818, 1398.1818181818182)
rate_1vs1(1400,1600)
#(1418.1818181818182, 1581.8181818181818)
win_probability(1600,1400)
#0.759746926647958
```

`https://andr3w321.com/elo-ratings-part-2-margin-of-victory-adjustments/`

### Margin of Victory Adjustments

For mov, fivethirtyeight uses the function ln(abs(mov) + 1)


```python
def rate_1vs1(p1, p2, mov = 1, k = 20, drawn = False):
    k_multiplier = 1.0
    if mov >= 7:
        k_multiplier = 2.0
    rp1 = 10 ** (p1/400)
    rp2 = 10 ** (p2/400)
    exp_p1 = rp1 / float(rp1 + rp2)
    exp_p2 = rp2 / float(rp1 + rp2)
    if drawn == True:
        s1 = 0.5
        s2 = 0.5
    else:
        s1 = 1
        s2 = 0
    new_p1 = p1 + k_multiplier * k * (s1 - exp_p1)
    new_p2 = p2 + k_multiplier * k * (s2 - exp_p2)
    return(new_p1, new_p2)
```

Autocorrelation Lets say instead of two neutral teams playing each other on a neutral field we have two mismatched teams playing each other. We would have four possible outcomes

1)favorite wins small
2)favorite wins big
3)underdog wins small
4)underdog wins big

```python
rate_1vs1(1550,1450,1,20)
#(1560.0, 1440.0)
rate_1vs1(1550,1450,14,20)
#(1570.0, 1430.0)
rate_1vs1(1450,1550,1,20)
#(1460.0, 1540.0)
rate_1vs1(1450,1550,14,20)
#(1470.0, 1530.0)
```

To have a variable k multiplyer to reward underdog wins and punish good teams for losing to bad teams, we can use he equation (2.2/((ELOW-ELOL)*.001+2.2))


$$
\frac{2.2}{((ELOW - ELOL) \times 0.001 + 2.2)}
$$

For example, if the favorite wins we have $2.2/(100 * 0.001 + 2.2) = 0.956$ and when the underdog wins we have $2.2/(-100 * 0.001 + 2.2) = 1.048$. Our rewritten elo rating function will be

```python
def rate_1vs1(p1, p2, mov=1, k=20, drawn=False):
    k_multiplier = 1.0
    corr_m = 1.0
    if mov >= 7:
        k_multiplier = 2.0
        corr_m = 2.2 / ((p1 - p2)*.001 + 2.2)
    rp1 = 10 ** (p1/400)
    rp2 = 10 ** (p2/400)
    exp_p1 = rp1 / float(rp1 + rp2)
    exp_p2 = rp2 / float(rp1 + rp2)
    if drawn == True:
        s1 = 0.5
        s2 = 0.5
    else:
        s1 = 1
        s2 = 0
    new_p1 = p1 + k_multiplier * corr_m * k * (s1 - exp_p1)
    new_p2 = p2 + k_multiplier * corr_m * k * (s2 - exp_p2)
    return(new_p1, new_p2)
    
#Our new ratings
rate_1vs1(1550,1450,1,20)
#(1560.0, 1440.0)
rate_1vs1(1550,1450,14,20)
#(1569.1304347826087, 1430.8695652173913)
rate_1vs1(1450,1550,1,20)
#(1460.0, 1540.0)
rate_1vs1(1450,1550,14,20)
#(1470.952380952381, 1529.047619047619)
```