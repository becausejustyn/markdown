#Tabbed Section

# Single hastags are so the script does not break

## Table 1 {.tabset}

### Code

```{r, fig.dim=c(5, 3)}
par(mar = c(4, 4, .5, .1))
plot(mpg ~ hp, data = mtcars, pch = 19)
```

### Table

#We show the data in this tab.

```{r}
head(mtcars)
```
