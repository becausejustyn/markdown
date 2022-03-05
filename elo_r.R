

"https://andr3w321.com/a-note-on-autocorrelation/"
"https://fivethirtyeight.com/methodology/how-our-nfl-predictions-work/"

# Elo functions

#yearly_adjustment

elo_current_year = (elo_previous_year * 2/3) + (1500 * 1/3)

#margin of victory

#"Margin of Victory Multiplier" = ln(\text{WinnerPointDiff} + 1) \times \frac{2.2}{\text{WinnerEloDiff} \times 0.001 + 2.2}
# Margin of Victory Multiplier = LN(ABS(PD)+1) * (2.2/((ELOW-ELOL)*.001+2.2))

#Where PD is the point differential in the game, ELOW is the winning team’s Elo Rating before the game, and ELOL is the losing team’s Elo Rating before the game.

margin_of_victory = log(winner_point_diff + 1) * (2.2 / winner_elo_diff * 0.001 + 2.2)