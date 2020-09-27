## ----message=FALSE, warning=FALSE, include=FALSE------------------------------
library(knitr)
options(knitr.kable.NA = '',
        digits=2,
        dpi=450)


if (!requireNamespace("ggplot2", quietly = TRUE)) {
  knitr::opts_chunk$set(eval = FALSE)
}

## ----message=FALSE, warning=FALSE---------------------------------------------
library(correlation)

data <- simulate_simpson(n=100, groups=10)

## ----message=FALSE, warning=FALSE---------------------------------------------
library(ggplot2)

ggplot(data, aes(x=V1, y=V2)) + 
  geom_point() +
  geom_smooth(colour="black", method="lm", se=FALSE) +
  theme_classic()

## ----message=FALSE, warning=FALSE---------------------------------------------
correlation(data)

## ----message=FALSE, warning=FALSE---------------------------------------------
library(ggplot2)

ggplot(data, aes(x=V1, y=V2)) + 
  geom_point(aes(colour=Group)) +
  geom_smooth(aes(colour=Group), method="lm", se=FALSE) + 
  geom_smooth(colour="black", method="lm", se=FALSE) + 
  theme_classic()

## ----message=FALSE, warning=FALSE---------------------------------------------
correlation(data, multilevel = TRUE)

