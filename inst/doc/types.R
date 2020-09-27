## ----message=FALSE, warning=FALSE, include=FALSE------------------------------
library(knitr)
options(knitr.kable.NA = '')
knitr::opts_chunk$set(comment=">",
  dpi=450)
options(digits=2)

set.seed(333)


if (!requireNamespace("see", quietly = TRUE) ||
    !requireNamespace("tidyr", quietly = TRUE) ||
    !requireNamespace("dplyr", quietly = TRUE) ||
    !requireNamespace("ggplot2", quietly = TRUE)) {
  knitr::opts_chunk$set(eval = FALSE)
}

## ----message=FALSE, warning=FALSE---------------------------------------------
library(correlation)
library(bayestestR)
library(see)

library(ggplot2)
library(tidyr)
library(dplyr)

## ----message=FALSE, warning=FALSE---------------------------------------------
generate_results <- function(r, n = 100, transformation = "none"){
  data <- bayestestR::simulate_correlation(round(n), r = r)
  if(transformation != "none"){
    var <- ifelse(grepl("(", transformation, fixed = TRUE), "data$V2)", "data$V2")
    transformation <- paste0(transformation, var)
    data$V2 <- eval(parse(text = transformation))
  }
  out <- data.frame(n = n, transformation = transformation, r = r)
  
  out$Pearson <- cor_test(data, "V1", "V2", method = "pearson")$r
  out$Spearman <- cor_test(data, "V1", "V2", method = "spearman")$rho
  out$Kendall <- cor_test(data, "V1", "V2", method = "kendall")$tau
  out$Biweight <- cor_test(data, "V1", "V2", method = "biweight")$r
  out$Distance <- cor_test(data, "V1", "V2", method = "distance")$r
  out$Distance <- cor_test(data, "V1", "V2", method = "distance")$r
  out
}

## ----message=FALSE, warning=FALSE---------------------------------------------
data <- data.frame()
for(r in seq(0, 0.999, length.out = 200)){
  for(n in c(100)){
    for(transformation in c("none", "exp(", "log10(1+max(abs(data$V2))+", "1/", "tan(", "sin(", "cos(", "cos(2*","abs(", "data$V2*", "data$V2*data$V2*", "ifelse(data$V2>0, 1, 0)*(")){
      data <- rbind(data, generate_results(r, n, transformation = transformation))
    }
  }
}


data %>% 
  tidyr::pivot_longer(-c(n, r, transformation), names_to = "Type", values_to = "Estimation") %>%
  dplyr::mutate(Type = forcats::fct_relevel(Type, "Pearson", "Spearman", "Kendall", "Biweight", "Distance")) %>% 
  ggplot(aes(x = r, y = Estimation, fill = Type)) +
  geom_smooth(aes(color = Type), method = 'loess', alpha = 0) +
  geom_vline(aes(xintercept = 0.5), linetype = "dashed") +
  geom_hline(aes(yintercept = 0.5), linetype = "dashed") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  see::theme_modern() +
  scale_color_flat_d(palette = "rainbow") +
  scale_fill_flat_d(palette = "rainbow") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  facet_wrap(~transformation)

model <- data %>% 
  tidyr::pivot_longer(-c(n, r, transformation), names_to = "Type", values_to = "Estimation") %>%
  lm(r ~ Type / Estimation, data = .) %>% 
  parameters::parameters()
dplyr::arrange(model[6:10,], desc(Coefficient))
