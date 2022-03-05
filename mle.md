## Likelihood

## Bayes Approach


Likelihood is a strange concept, in that it is not a probability, but it is proportional to a probability. 

The likelihood of a hypothesis (H) given some data (D) is proportional ($\propto$) to the probability of obtaining D given that H is true, multiplied by an arbitrary positive constant K. In other words, 

\underbrace{L(H)}_{\text{Hypothesis Likelihood}}

$$
L(H) = K \times P (D|H).
$$

> Consider the case of Earl, who is visiting a foreign country that has a mix of women-only and mixed-gender saunas (known to be visited equally often by both genders). After a leisurely jog through the city he decides to stop by a nearby sauna to try to relax. Unfortunately, Earl does not know the local language so he cannot determine from the posted signs whether this sauna is women-only or mixed-gender. While Earl is attempting to decipher the signs he observes three women independently exit the sauna. If the sauna is women-only, the probability that all three exiting patrons would be women is 1.0; if the sauna is mixed-gender, this probability is .53 = .125. With this information Earl can compute the likelihood ratio between the women-only hypothesis and the mixed- gender hypothesis to be 1.0/.125 = 8, or eight-to-one evidence in favor of the sauna being women-only. Source doi: 10.1177/2515245917744314

d

$$
\underbrace{P(\beta | y)}_{\text{posterior}} = \frac{\overbrace{P(y | \beta)}^{\text{likelihood}} \times \overbrace{P(\beta)}^{\text{prior}}}{\underbrace{P(y)}_{\text{evidence}}}
$$

