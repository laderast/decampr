---
title       : Simple Stats and Modeling with broom
description : Now we have tidy data, let's start doing some statistics!
---


--- type:NormalExercise lang:r xp:0 skills:1 key:e91efd94b6
## We've built a foundation. Now to stats!

About 80-90% of any data analysis project is doing the data cleaning. Once you've confirmed that your data is
cleaned properly and is tidy, now you can start trying some simple statistics on your data.

We're going to use `broom`, which is another package available in the `tidyverse`. `broom` makes the output
and results of statistical models tidy, and easy to extract. We'll try to leverage all our skills to put together
a simple data story given our data. 

Note that we can't cover all of statistics in this unit. But we can show you some of the basic operations. Remember,
if you don't completely understand the statistics, it's best to consult with a Biostatistician.

Our questions of interest are the following:

+ Is mercury exposure greater within people who are fishermen versus those who are not? (t-test)
+ What are the best predictors of mercury exposure? (multiple linear regression)

*** =possible_answers
- [Just press Submit Answer to head to the next exercise!]

*** =feedbacks
- Keep on going!



--- type:NormalExercise lang:r xp:100 skills:1 key:3e59cb838f
## Let's explore the fishermen mercury dataset

We are going to explore a dataset called the fishermen mercury dataset, which consists of factors 
related to mercury exposure among two groups: fishermen and non-fishermen, who are our control group. 

Take a look at the readme for this dataset first: [README](http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fishermen_mercury_README.txt)

Then use `glimpse` to take a look at the structure of the data and try `table()` on 
`fisherman`. What are the different categories of `fishpart` and `fisherman`?

Now use `table()` as part of a pipe to look at the cross-table of `fisherman` and `fishpart`. Are fishermen more likely to eat more whole fish than non-fishermen?

*** =instructions

`glimpse()` the data, create a table for `fisherman` and a crosstable of `fisherman`x`fishpart`.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
glimpse(fishdata)

fishdata %>% select(___) %>% table()

fishdata %>% select(___,___) %>% table()
```

*** =solution
```{r}
glimpse(fishdata)

fishdata %>% select(fisherman) %>% table()

fishdata %>% select(fisherman,fishpart) %>% table()
```

*** =sct
```{r}
ex() %>% check_function('table',index=2) %>% check_result() %>% check_equal()
ex() %>% check_function('select') %>% check_result() %>% check_equal()

success_msg("Nice tabling!")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:80227d57fb
## Visualize Mean of Total Mercury by Fisherman Status

Let's visualize mean `total_mercury` (total mercury) by `fisherman` status to 
see whether there is a difference between them.

*** =instructions

Use `geom_boxplot()` to visualize the median of `total_mercury` conditioned on
`fisherman` status (if you can't remember, 
[here's the exercise](https://campus.datacamp.com/courses/rbootcamp/ggplot2-and-categorical-data?ex=11)). 
Make sure to cast `fisherman` as a factor.

We can add the mean as a point using `stat_summary` to see how the mean differs from the median.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
#plot total_mercury here
ggplot(fishdata,aes(x=___,y=___)) + geom_boxplot() +
  stat_summary(fun.y="mean",geom="point",pch=3,color="red")
```

*** =solution
```{r}
ggplot(fishdata, aes(x=fisherman, y=total_mercury)) + geom_boxplot() +
  stat_summary(fun.y="mean",geom="point",pch=3,color="red")
```

*** =sct
```{r}
test_ggplot()
success_msg("Beautiful plot!")
```



--- type:NormalExercise lang:r xp:100 skills:1 key:296da9c0f4
## Compute Means with group_by

We can also use `group_by` and `summarize` to explicitly compute the means and standard deviations for each `fisherman` group.

*** =instructions

Use `group_by` in the `dplyr` package to group the data frame by `fisherman` status, and use `summarize` to obtain the mean and standard deviation of `total_mercury` for each group. 

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
fishdata%>%
    group_by()%>%
    summarize(  mean_total_mercury = , 
                sd_total_mercury = )
```

*** =solution
```{r}
fishdata%>%group_by(fisherman)%>%summarize(mean_total_mercury = mean(total_mercury), sd_total_mercury = sd(total_mercury))
```

*** =sct
```{r}
ex() %>% check_function('group_by') %>% check_result() %>% check_equal()
ex() %>% check_function('summarize') %>% check_result() %>% check_equal()
success_msg("Excellent summarization!")
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:1 key:6e3730d99d
## Is there a difference?

Is there a difference between the two groups: fishermen and non-fishermen?

*** =instructions

- No, there isn't. The means are too close.
- Yes, there is. The intervals overlap but there is a clear difference in means

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
ggplot(fishdata, aes(x=factor(fisherman), y=total_mercury)) + geom_boxplot() +
  stat_summary(fun.y="mean",geom="point",pch=3,color="red")
```

*** =sct
```{r}
test_mc(correct=2)
success_msg("That's right, fisherman seem to have higher total mercury")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:556d3ae28b
## T-test of means for fisherman status

A common and very useful test used to compare two means for Normally distributed data is the Student's T Test. The null hypothesis is that two means from two independent groups are identical, and the alternative hypothesis is that the two means are not identical (two-sided test).

In our case, we want to test whether the mean total mercury in fishermen is the same or different than the mean total mercurcy for non-fishermen. What is the p-value from this test?

*** =instructions

Use the function `t.test` to compare the mean `total_mercury` in fishermen and nonfishermen.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
# Use the formula input option, see ?t.test help page: a formula of the form lhs ~ rhs where lhs is a numeric variable giving the data values and rhs a factor with two levels giving the corresponding groups.
t.test(~,data=fishdata)
```

*** =solution
```{r}
t.test(total_mercury~fisherman,data=fishdata)
```

*** =sct
```{r}
ex() %>% check_function('t.test') %>% check_result() %>% check_equal(incorrect_msg = "Not quite. Check your inputs.")
```



--- type:NormalExercise lang:r xp:100 skills:1 key:36a8333264
## Sweep up that output with Broom

That output was pretty ugly, wasn't it? There's an extremely handy package called `broom` that can help us clean it up into a tidy data table. Funnily enough, the handy function is called `tidy`.

*** =instructions

Use `tidy()` to save the output of the t.test to a data.frame called `tidyTtest`. Then `glimpse()` it to see what's in there, and lastly explore how you can easily extract results (like the p-value) in the usual data.frame way.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
fishTtest <- t.test(total_mercury~fisherman,data=fishdata)

#use tidy here
tidyTtest <- tidy()

#glimpse your output
glimpse()

# extract a p-value
tidyTtest$

```

*** =solution
```{r}
fishTtest <- t.test(total_mercury~fisherman,data=fishdata)

# use tidy here
tidyTtest <- tidy(fishTtest)

# glimpse your output
glimpse(tidyTtest)

# extract a p-value
tidyTtest$p.value
```

*** =sct
```{r}
ex() %>% check_object('tidyTtest') %>% check_equal()
ex() %>% check_function('glimpse') %>% check_result() %>% check_equal()
test_output_contains("tidyTtest$p.value",
	                     incorrect_msg = "Have you extracted the p.value column?")
success_msg("So fresh and so clean clean!")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:a8e91afadb
## Let's delve deeper into the data

We have other covariates in our data. We want to see whether we can use these covariates to
predict the level of Mercury Exposure. Could another covariate be confounding the relationship between fisherman and total mercury?

Let's first look at the scatter plots of `weight` and number of fish meals per week `fishmlwk` vs `total_mercury`. Do there seem to be any associations?

*** =instructions

Use `geom_point` to make scatterplots of the two variables.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
# draw a scatterplot of weight (x-axis) vs total_mercury (y axis) and color by fisherman category
ggplot(fishdata,aes(___,___,color=___))+___

# draw a scatterplot of fishmlwk (x-axis) vs total_mercury (y axis) and color by fisherman category
ggplot(fishdata,aes(___,___,color=___))+___

```

*** =solution
```{r}
ggplot(fishdata,aes(x=weight,y=total_mercury,color=fisherman))+geom_point()

ggplot(fishdata,aes(x=fishmlwk,y=total_mercury,color=fisherman))+geom_point()
```

*** =sct
```{r}
test_ggplot(index=1)
test_ggplot(index=2)
success_msg("Beautiful plots!")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:d5e745c9f5
## Linear Regression

It looks like both `weight` and number of fish meals per week (`fishmlweek`) are associated with `total_mercury`. They also appear to be associated with `fisherman` status. We saw earlier from our cross-table output that fisherman tend to eat more fish (surprised?).

We can use linear regression to adjust for these possible confounders. We first build a univariate linear regression with just `fisherman` as a predictor of `total_mercury`. Then we compare it to a multiple linear regression with the three independent variables.

Note: the p-value from the linear regression is similar but not exactly the same as the t-test since the t-test assumed equal variances between groups (argument `var.equal=TRUE` by default in `t.test()`).

*** =instructions

Fit a linear regression with `fisherman` as the independent variable and `total_mercury` as the dependent variable. Save this as `fit_univariate`. Then, fit a multiple linear regression with `fisherman`, `weight`, `fishmlwk` as dependent variables. Save this as `fit_multiple`.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}

# fit the univariate model
fit_univariate <- lm(~,data=fishdata)

# fit the multiple predictor model with fisherman, weight, fishmlwk
fit_multiple <- lm(~,data=fishdata)

# let's look at the output
summary(fit_univariate)
summary(fit_multiple)
```

*** =solution
```{r}
fit_univariate <- lm(total_mercury~fisherman,data=fishdata)
fit_multiple <- lm(total_mercury~fisherman+weight+fishmlwk,data=fishdata)

# let's look at the output
summary(fit_univariate)
summary(fit_multiple)
```

*** =sct
```{r}
ex() %>% check_object('fit_univariate') %>% check_equal()
ex() %>% check_object('fit_multiple') %>% check_equal()
success_msg("Now we're regressing!")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:7e98c03571
## Broom with linear regression

Did you notice we have more ugly output? It's not really so bad to look at (the stars are pretty afterall) but when you try to grab model information out of it things get messy and complicated quickly.

For illustration, let's try to get the p-value for fisherman from the multiple regression model the normal way, then lets try the broom way. We can get covariate information from `tidy()`.

*** =instructions

Use the output from `summary` to obtain a p-value for fisherman from `fit_multiple`. Then, use `broom::tidy`.


*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
# here is our model
fit_multiple <- lm(total_mercury~fisherman+weight+fishmlwk,data=fishdata)

# what is in summary(fit_multiple)?
str(summary(___))
# yikes, right? well at least it's a list

# summary()$coef gives you a numerical matrix, extract fisherman's p-value
summary(fit_multiple)$coefficients[___,___]

# or use broom's tidy to see the covariate estimates and p-values--look, a tibble!
tidy()

# we can use dplyr on this to obtain our p.value
tidy() %>% filter() %>% select()
```

*** =solution
```{r}
# here is our model
fit_multiple <- lm(total_mercury~fisherman+weight+fishmlwk,data=fishdata)

# what is in summary(fit_multiple)?
str(summary(fit_multiple))
# yikes, right? well at least it's a list

# summary()$coef gives you a numerical matrix, extract fisherman's p-value
summary(fit_multiple)$coefficients[2,4]

# or use broom's tidy to see the covariate estimates and p-values--look, a tibble!
tidy(fit_multiple)

# we can use dplyr on this to obtain our p.value
tidy(fit_multiple) %>% filter(term=="fisherman1") %>% select(p.value)

```

*** =sct
```{r}
test_output_contains("summary(fit_multiple)$coefficients[2,4]",
	                     incorrect_msg = "Have you extracted the correct p.value row and column using summary(fit_multiple)$coefficients?")
ex() %>% check_function('tidy') %>% check_result() %>% check_equal()
ex() %>% check_function('filter') %>% check_result() %>% check_equal()
ex() %>% check_function('select') %>% check_result() %>% check_equal()
success_msg("Tidy all the things!")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:395ea60755
## Broom with linear regression: glance

Now let's do something similar with the $R^2 $ summary measure which is a measure of model fit in that it quantifies the amount of variance explained in the outcome (total mercury) explained by the predictors. Using broom, we get model summary level information from the function `glance()`. While `tidy()` returned a tibble/data_frame of covariate information with one row for each model term, `glance()` will return a tibble with just one row with all the pertinent single value model information.

*** =instructions

Use the output from `summary` to obtain an $R^2 $ for fisherman from `fit_multiple`. Then, use `broom::glance`.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
# here is our model
fit_multiple <- lm(total_mercury~fisherman+weight+fishmlwk,data=fishdata)

# ok where is that R^2? look at the names of the summary list again
names(summary(fit_multiple))

# call the name we need
___$___

# or we can use glance
glance()

# and select that R^2
glance() %>% select()

```

*** =solution
```{r}
# here is our model
fit_multiple <- lm(total_mercury~fisherman+weight+fishmlwk,data=fishdata)

# ok where is that R^2? look at the names of the summary list again
names(summary(fit_multiple))

# call the name we need
summary(fit_multiple)$r.squared

# or we can use glance
glance(fit_multiple)

# and select that R^2
glance(fit_multiple)%>%select(r.squared)
```

*** =sct
```{r}
test_output_contains("summary(fit_multiple)$r.squared",
	                     incorrect_msg = "Have you extracted the R^2 using summary()$?")
ex() %>% check_function('glance') %>% check_result() %>% check_equal()
ex() %>% check_function('select') %>% check_result() %>% check_equal()
success_msg("I see you did a great job!")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:abcb19fe03
## Compare our models

We've built two models: `fit_univariate` and `fit_multiple`. The first only contains `fisherman` as a predictor, and the second contains `fisherman` as well as `weight` and number of `fishmealwk`.

Which model fits the data better, and how does the association of fisherman with total mercury change when we adjust for weight and number of fish meals per week? Are the other covariates significantly associated with total mercury?

*** =instructions

Extract the covariate information using `tidy` from the two models and bind them together into one data frame with `bind_rows` in the dplyr package. Do the same with the model summary information using `glance`. Then, use a dplyr function to look at just the fisherman covariate results from both models.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
# Here are our two models
fit_univariate <- lm(total_mercury~fisherman,data=fishdata)
fit_multiple <- lm(total_mercury~fisherman+weight+fishmlwk,data=fishdata)

# Tidy 'em up
fit_univariate_tidy <- 
fit_multiple_tidy <- 

# Bind them
both_tidy <- bind_rows( "univariate"=___,
                        "multiple"=___,
                        .id="model")
both_tidy

# Same with glance (we can try doing this in one line)
both_glance <- bind_rows(   "univariate"=glance(___),
                            "multiple"=glance(___),
                            .id="model")
both_glance

# Show just fisherman's covariate information
both_tidy%>%___(term=="fisherman1")
```

*** =solution
```{r}
# Here are our two models
fit_univariate <- lm(total_mercury~fisherman,data=fishdata)
fit_multiple <- lm(total_mercury~fisherman+weight+fishmlwk,data=fishdata)

# Tidy 'em up
fit_univariate_tidy <- tidy(fit_univariate)
fit_multiple_tidy <- tidy(fit_multiple)

# Bind them
both_tidy <- bind_rows("univariate"=fit_univariate_tidy,
"multiple"=fit_multiple_tidy,.id="model")
both_tidy

# Same with glance
both_glance <- bind_rows("univariate"=glance(fit_univariate),
"multiple"=glance(fit_multiple),.id="model")
both_glance

# Show just fisherman's covariate information
both_tidy%>%filter(term=="fisherman1")

```

*** =sct
```{r}

ex() %>% check_function('bind_rows',index=1) %>% check_result() %>% check_equal()
ex() %>% check_function('bind_rows',index=2) %>% check_result() %>% check_equal()
ex() %>% check_function('filter') %>% check_result() %>% check_equal()
success_msg("Now we're doing statistics!")
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:1 key:3c97529ff5
## Prediction of mercury

How confident are you that being a fisherman is associated with higher levels of mercury?

*** =instructions

- So confident, I don't want to be a fisherman!
- Not confident, there are other confounding factors at play here, maybe they should just eat less fish?

*** =hint

*** =pre_exercise_code
```{r}

```

*** =sct
```{r}
test_mc(correct=2)
success_msg("That's right, total fish intake seems to be more associated with mercury levels, and after adjusting for this in the multiple regression, fisherman status is no longer significantly associated with total mercury.")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:4543850c9f
## Challenge 1: augment + ggplot2

We have some models and with models comes predictions, or fitted values. That is, we've fit a linear regression to predict our "y" which is `total_mercury`, and we can obtain fitted values based on the model. We can compare these fitted values to the true value of `total_mercury`.

The broom function `augment` will give us our fitted values. Plot these fitted values against the true values of `total_mercury` using ggplot.

For a reference while you work, you can use the `ggplot2` cheatsheet here:
[ggplot2 cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf)

*** =instructions
For both models, use `augment` to obtain fitted values of `total_mercury` and save these to new data frames `fit_univariate_augment` and `fit_multiple_augment`. Use `bind_rows` to bind these data frames into one long tidy data frame. Then use `ggplot2` to make a scatterplot of fitted values and true values of `total_mercury`, colored by `fishmlwk` and let shape correspond to `fisherman`. Use `facet_wrap` to look at both models side by side. Add a diagonal line for good measure, so we can see how close the fitted values correlate.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
# Here are our models again
fit_univariate <- lm(total_mercury~fisherman,data=fishdata)
fit_multiple <- lm(total_mercury~fisherman+weight+fishmlwk,data=fishdata)

# save augmented data here
fit_multiple_augment <- 
fit_univariate_augment <- 

# bind rows
augmented_data <- bind_rows("univariate"=,
                            "multiple"=,
                            .id="model")

# scatterplot of total mercury (x-axis) vs fitted values (y-axis), color fishmlwk and shape fisherman
ggplot(augmented_data,aes())+
    geom_point()+
    geom_abline()+
    facet_wrap()
```

*** =solution
```{r}
# Here are our models again
fit_univariate <- lm(total_mercury~fisherman,data=fishdata)
fit_multiple <- lm(total_mercury~fisherman+weight+fishmlwk,data=fishdata)

# save augmented data here
fit_multiple_augment <- augment(fit_multiple)
fit_univariate_augment <- augment(fit_univariate)

# bind rows
augmented_data <- bind_rows("univariate"=fit_univariate_augment,
                            "multiple"=fit_multiple_augment,.id="model")

ggplot(augmented_data,aes(x=total_mercury,y=.fitted,color=fishmlwk,shape=fisherman))+
    geom_point()+
    geom_abline(intercept=0,slope=1)+
    facet_wrap(~model)
```

*** =sct
```{r}
# should we add more tests for the ggplot?
ex() %>% check_function('augment',index=1) %>% check_result() %>% check_equal()
ex() %>% check_function('augment',index=2) %>% check_result() %>% check_equal()
ex() %>% check_function('bind_rows') %>% check_result() %>% check_equal()
test_ggplot()
success_msg("Super! You're really assessing that model fit, now!")

```


--- type:NormalExercise lang:r xp:100 skills:1 key:78cd02eef9
## Challenge 2: Proportions of fishpart by fisherman status 

Let's try and examine fishpart eating by fisherman status. 

Produce a proportional barplot ([Here's how if you forgot](https://campus.datacamp.com/courses/rbootcamp/ggplot2-and-categorical-data?ex=5))
of `fishpart` versus `fisherman`.

Then, use the `chisq.test` function to test for the association of `fishpart` with `fisherman`. Use broom to tidy up the result into a data frame.

Note: When we have simple tests with no covariate information like `t.test` and `chisq.test`, the `tidy` function just gives us all the model information just as `glance` does, and `augment` is not used.


*** =instructions

Use `geom_bar` to make a proportional barplot. Be sure to cast `fisherman` as a factor in ggplot `aes`. Then run a Chi-square test with `chisq.test` and look at the output with `tidy`.

*** =hint

*** =pre_exercise_code
```{r}
library(readr)
library(dplyr)
library(ggplot2)
library(broom)

fishdata <- read_csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_3864/datasets/fisherman_mercury_modified.csv")
fishdata$fisherman <- factor(fishdata$fisherman)
```

*** =sample_code
```{r}
# Use ggplot to create a proportional barplot
ggplot(fishdata, aes(x=,fill=)) + 
  geom_bar(position= "", color="black")
  
# Run a chi-square test for the association of these two categorical variables
# Hint, it's easiest if you use the table() function inside chisq.test()
chisq_fish <- chisq.test()
chisq_fish

# Tidy with tidy

```

*** =solution
```{r}
# Use ggplot to create a proportional barplot
ggplot(fishdata, aes(x=fishpart,fill=fisherman)) + 
  geom_bar(position= "fill", color="black")
  
# Run a chi-square test for the association of these two categorical variables
# Hint, it's easiest if you use the table() function inside chisq.test()
chisq_fish <- chisq.test(with(fishdata,table(fishpart,fisherman)))
chisq_fish

# Tidy with tidy
tidy(chisq_fish)
```

*** =sct
```{r}
test_ggplot()
# ex() %>% check_function('chisq.test') %>% check_result() %>% check_equal()
# how to check chisq.test when there are lots of ways to get same answer?
ex() %>% check_function('tidy') %>% check_result() %>% check_equal()

success_msg("Super! Now you're ready to use broom with lots of models!")
```


--- type:NormalExercise lang:r xp:100 skills:1 key:7d6b139aac
## What you learned in this chapter

- T.tests and linear regression in R
- `broom` functions to make model output `tidy`
- How to put it together with `dplyr` and `ggplot2` to assess model fit and visualize results
- How the `tidyverse` comes together to make data manipulation and statistics easier

*** =instructions

There are so many directions you can go in now that you know the basics of the `tidyverse`. Here are some
important links for going further.

+ [R for Data Science](http://r4ds.had.co.nz) - This is the foundational text for doing data science in R and will take you further in data manipulation
+ [Modern Dive](http://www.moderndive.com) - Chester and Albert's short but sweet book on foundational data science skills in R.

Need help with statistics/biostatistics at OHSU? There are some groups on campus that are there for you (they even have drop in hours):

- [Biostatistics & Design Program](http://www.ohsu.edu/xd/research/centers-institutes/octri/resources/octri-research-services/evaluating-data.cfm)
- [Knight Biostatistics Shared Resource](https://bridge.ohsu.edu/research/knight/resources/BSR/SitePages/Project%20Requests.aspx) for Knight Cancer Members

Also take some classes!

- Biostatistics classes in OHSU-PSU School of Public Health
- Computational Biology classes in DMICE
- Probability and Statistical Inference class in CS/EE
- Biostatistics classes in the Human Investigator Program


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