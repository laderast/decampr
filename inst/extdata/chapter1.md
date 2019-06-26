---
title       : The Magic of ggplot2
description : Learn how ggplot2 turns variables into statistical graphics
---

--- type:NormalExercise lang:r xp:100 skills:1 key:8323fcbca1
## Quick Data Frame Introduction

Before we start: please join the [RBootcamp OHSU Group!](https://www.datacamp.com/groups/de163cc541d0d9bde4956157d17dbedfb1149225/invite)

A `data.frame` is basically a table-like format which has the following properties: 

- Columns can each have a different type (`numeric`, `character`, `boolean`, `factor`)
- Columns are called "variables"
- Rows correspond to a single observation (ideally)
- Can be subset or filtered based on criteria

Individual variables within a `data.frame` can be accessed with the `$` operator (such as `gap1992$pop`). We won't use this very often, as the `tidyverse` lets us access the variables without it, as you'll see.

*** =instructions
Run `colnames()` and `head()` on the `gap1992` data to see what's in each column. Then see how many rows there are in the dataset using `nrow()`. Run these in console before you submit your answer.

*** =pre_exercise_code
```{r}
library(dplyr)
library(gapminder)
library(ggplot2)
gap1992 <- gapminder %>% filter(year == 1992)
```

*** =sample_code
```{r}
##run head on gap1992
head(----)
##run colnames here on gap1992
colnames(----)
##run nrow() on gap1992
nrow(-----)
```

*** =solution
```{r}
##run head on gap1992
head(gap1992)
##run colnames here on gap1992
colnames(gap1992)
##run nrow() on gap1992
nrow(gap1992)
```

*** =sct
```{r}
success_msg("Great! You learned some basics about `data.frame`s! Let's move on.")
test_function("colnames", incorrect_msg = "did you use colnames(gap1992)?")
test_function("nrow", incorrect_msg = "did you use nrow(gap1992)")
```


--- type:MultipleChoiceExercise lang:r xp:100 skills:1 key:d599f92ec8
## Thinking about aesthetics
Now that we've learned a little about the `data.frame`, we can get to the fun part: making graphs.

The first thing we are going to is think about how we represent variables in a plot. 

How do we visually represent a variable in our dataset? Take a look at this graph. What variable is mapped to `y`, and what is mapped to `x`, and what is mapped to `color`?

***=pre_exercise_code
```{r}
library(dplyr)
library(gapminder)
library(ggplot2)
gap1992 <- gapminder %>% filter(year == 1992)

ggplot(gap1992, aes(x = log(gdpPercap), y = lifeExp, size=pop, color=continent)) +
  geom_point() + ggtitle("Gapminder for 1992")
```

*** =instructions
- x = gdpPercap, y = log(lifeExp), color = continent
- x = continent, y = year, color = pop
- y = lifeExp, x = log(gdpPercap), color = continent

*** =hint
Look at the y-axis.

*** =sct
```{r}
msg1 = "You have things reversed, and you're taking the log of the wrong variable"
msg2 = "Wrong variables. Go back and look at what's being mapped"
msg3 = "Correct! We are displaying lifeExp as our y variable and log(gdpPercap) as our x variable"

test_mc(correct = 3, feedback_msgs=c(msg1, msg2, msg3))
```


--- type:NormalExercise lang:r xp:100 skills:1 key:bfe1375688
## Mapping variables to produce geometric plots

A statistical graphic consists of:

+ A `mapping` of variables in `data` to
+ `aes()`thetic attributes of
+ `geom_`etric objects.

In code, this is translated as:

```{r}
ggplot(data = gap1992, mapping = aes(x = log(gdpPercap), y=log(pop))) +
  geom_point()
```

Let's take the above example code apart. A `ggplot2` call always starts with the `ggplot()` function. In this function, we need two things:

1. `data` - in this case, `gap1992`.
2. `mapping` - An aesthetic mapping, using the `aes()` function. 

In order to map our variables to aesthetic properties, we will need to use `aes()`, which is our `aes()`thetic mapping function. In our example, we map `x` to `log(gdpPercap)` and `y` to `log(pop)`.

Finally, we can superimpose our geometry on the plot using `geom_point()`.

*** =instructions
Based on the graph, map the appropriate variables to the `x`, and `y` aesthetics. Run your plot. Remember, you can try plots out in the console before you submit your answer.

*** =hint
Look at the graph. If you need the variable names, you can always use `head()` or `colnames()` on the `gap1992` dataset.

*** =pre_exercise_code
```{r}
library(dplyr)
library(gapminder)
library(ggplot2)
gap1992 <- gapminder %>% filter(year == 1992)

ggplot(gap1992, aes(x = log(gdpPercap), y = lifeExp, size=pop, color=continent)) +
  geom_point() + ggtitle("Gapminder for 1992")
```

*** =sample_code
```{r}
ggplot(data = gap1992, 
    mapping = aes(
      x = , 
      y =  
      )) + 
geom_point()
```

*** =solution
```{r}
ggplot(data=gap1992, 
    mapping = aes(
      x = log(gdpPercap), 
      y = lifeExp 
      )) + 
geom_point()

```

*** =sct
```{r}
success_msg("Wunderbar! Now you're on your way to recreating that gapminder plot")
test_ggplot(check_aes = TRUE, aes_fail_msg = "Not quite. Make sure you're mapping the right variables to the right aesthetics.")
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:1 key:e507076f4e
## More about aes
For `geom_point()`, there are lots of other aesthetics. The important thing to know is that
aesthetics are properties of the `geom`. If you need to know the aesthetics that you can 
map to a `geom`, you can always use `help()` (such as `help(geom_point)`).

I'd ask you to look at `help(geom_point)`, but the documentation is not correct on Datacamp. 
Instead, look here: [http://ggplot.yhathq.com/docs/geom_point.html](http://ggplot.yhathq.com/docs/geom_point.html)
and look at all the aesthetic mappings. 

Which of the following is *not* a mappable aesthetic to `geom_point()`?

*** =instructions
- `x`
- `shape`
- `linetype`

*** =pre_exercise_code
```{r}
library(ggplot2)
```

*** =sct
```{r}
success_msg("Great! Now you know where to look for mappable aesthetics.")
msg1 = "Nope. This is a mappable aesthetic to `geom_point().`"
msg3 = "Correct. `linetype` is not mappable to `geom_point()`. Points don't have a `linetype`, do they?"
test_mc(correct = 3, feedback_msgs=c(msg1, msg1, msg3))
```


--- type:NormalExercise lang:r xp:100 skills:1 key:f0a09d682e
## Points versus lines

The great thing about `ggplot2` is that it's easy to swap representations. 
Instead of x-y points, we can plot the data as a line graph by swapping `geom_line()`
for `geom_point()`.

*** =instructions
First run the code to see the plot with points. Change the `geom_point()` in the following graph to `geom_line()`. What happened?
How did the visual presentation of the data change?

*** =pre_exercise_code
```{r}
library(dplyr)
library(gapminder)
library(ggplot2)
gap1992 <- gapminder %>% filter(year == 1992)
```

*** =sample_code
```{r}
ggplot(gap1992, aes(x = log(gdpPercap), y = lifeExp, color=continent)) +
  geom_point() 
```

*** =solution
```{r}
ggplot(gap1992, aes(x = log(gdpPercap), y = lifeExp, color=continent)) +
  geom_line() 
```

*** =sct
```{r}
success_msg("Great! Now you know how to swap representations in ggplot2. Let's move on.")
test_function("geom_line", incorrect_msg="You need to change the geom.")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:13ea4fbf3d
## Geoms are layers on a ggplot

We are not restricted to a single geom on a graph! You can think of geoms
as layers on a graph. Thus, we can use the `+` symbol to add geoms to our
base `ggplot()` statement. 

*** =instructions
Add both `geom_line()` and `geom_point()` to the following ggplot. Are the results what you expected?

*** =pre_exercise_code
```{r}
library(dplyr)
library(gapminder)
library(ggplot2)
gap1992 <- gapminder %>% filter(year == 1992)
```

*** =sample_code
```{r}
ggplot(gap1992, aes(x = log(gdpPercap), y = lifeExp, color=continent)) +
## add code here

```

*** =solution
```{r}
ggplot(gap1992, aes(x = log(gdpPercap), y = lifeExp, color=continent)) +
## add code here
  geom_line() + geom_point()
```

*** =sct
```{r}
test_function("geom_line", incorrect_msg="you need to add geom_line()")
test_function("geom_point", incorrect_msg="you need to add geom_point()")
```


--- type:MultipleChoiceExercise lang:r xp:100 skills:1 key:349a622cb7
## Quick review about ggplot2

What does the `+` in a `ggplot` statement do? 

For example:

```{r}
ggplot(gap1992, aes(x = log(gdpPercap), y = lifeExp, color=continent)) +
  geom_line() + geom_point()
```

*** =instructions
- adds one `data.frame` to another `data.frame` 
- allows you to chain data and geoms together into a single statistical graphic
- allows you to add variables together in a `data.frame`

*** =hint
`+` combines things, but doesn't add them together

*** =sct
```{r}
msg1 = "This is not the case. Go back and look at the ggplot code."
msg2 = "Correct! This is how we can add data and layer geoms together"
msg3 = "Look at the ggplot code and see if we are manipulating data or not. Are we?"
test_mc(correct = 2, feedback_msgs=c(msg1, msg2, msg3))
```


--- type:NormalExercise lang:r xp:300 skills:1 key:01ef5c54c5
## Final Challenge: Recreate this Gapminder Plot

Your final challenge is to completely recreate this graph using the `gap1992` data.

***=pre_exercise_code
```{r}
library(dplyr)
library(gapminder)
library(ggplot2)
gap1992 <- gapminder %>% filter(year == 1992)

ggplot(gap1992, aes(x = log(gdpPercap), y = lifeExp, size=pop, color=continent)) +
  geom_point() + ggtitle("Gapminder for 1992")
```

*** =instructions
- If you need to remember variable names, you can always call `head(gap1992)` or `colnames(gap1992)` in the console.
- Recreate the above graphic by mapping the right variables to the right aesthetic elements. Remember, you can try plots out in the console before you submit your answer.

*** =sample_code
```{r}
ggplot(gap1992, aes(x = , 
    y = , 
    color = ,
    size =
    )) + ggtitle("Gapminder for 1992") +
```

*** =solution
```{r}
ggplot(gap1992, aes(x = log(gdpPercap), 
    y = lifeExp, 
    color = continent,
    size = pop
    )) + ggtitle("Gapminder for 1992") + 
    geom_point()
```

*** =sct
```{r}
success_msg("Now you know the basics of ggplot and aesthetics. Congrats!")
test_ggplot(check_aes=TRUE, aes_fail_msg = "Not quite. Go back and map the variables to the correct aesthetics.")
```


--- type:NormalExercise lang:r xp:0 skills:1 key:fe7e851b1f
## What you learned in this chapter

- Basic `ggplot2` syntax.
- Plotting x-y data using `ggplot2` using both `geom_point()` and `geom_bar()`.
- Mapping variables in a dataset to visual properties using `aes()`
- `geom`s correspond to layers in a graph.
- That `ggplot2` can make some pretty cool graphs
- That you can do this!

*** =instructions
Just move on to the next chapter! (CTRL+K)

*** =hint

*** =pre_exercise_code
```{r}

```

*** =sample_code
```{r}

```

*** =solution
```{r}

```

*** =sct
```{r}

```


--- 
