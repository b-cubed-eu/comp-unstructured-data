# Make figure to illustrate the principle of comparing trends

set.seed(123)

# Generate three types of relationships
n <- 20

# 1. Strong positive correlation
data1_pos <- cumsum(rnorm(n))
data2_pos <- data1_pos + rnorm(n, sd = 1)
cor_pos <- cor(data1_pos, data2_pos)

# 2. No correlation
data1_none <- cumsum(rnorm(n))
data2_none <- rnorm(n)
cor_none <- cor(data1_none, data2_none)

# 3. Strong negative correlation
data1_neg <- cumsum(rnorm(n))
data2_neg <- -data1_neg + rnorm(n, sd = 1)
cor_neg <- cor(data1_neg, data2_neg)

# Set up 3 rows and 2 columns of plots
par(mfrow = c(3, 2), mar = c(4, 4, 3, 1))

# ----------- Positive Correlation -----------
# Time series
plot(data1_pos,
     type = "l",
     col = "#1B9E77",
     lwd = 2,
     ylim = range(c(data1_pos, data2_pos)),
     ylab = "Value",
     xlab = "Time",
     main = "Two trends with positive correlation")
lines(data2_pos, col = "#D95F02", lwd = 2)
legend("topleft",
       legend = c("Data 1", "Data 2"),
       col = c("#1B9E77", "#D95F02"),
       lwd = 2)

# Scatterplot
plot(data1_pos, data2_pos, pch = 19, col = "darkgreen",
     xlab = "Value in dataset 1", ylab = "Value in dataset 2",
     main = paste("R =", round(cor_pos, 2)))
abline(lm(data2_pos ~ data1_pos), col = "black", lwd = 2, lty = 2)

# ----------- No Correlation -----------
plot(data1_none,
     type = "l",
     col = "#1B9E77",
     lwd = 2,
     ylim = range(c(data1_none, data2_none)),
     ylab = "Value", xlab = "Time",
     main = "Two trends with no correlation")
lines(data2_none, col = "#D95F02", lwd = 2)
legend("topleft",
       legend = c("Data 1", "Data 2"),
       col = c("#1B9E77", "#D95F02"),
       lwd = 2)

plot(data1_none, data2_none, pch = 19, col = "darkgreen",
     xlab = "Value in dataset 1", ylab = "Value in dataset 2",
     main = paste("R =", round(cor_none, 2)))
abline(lm(data2_none ~ data1_none), col = "black", lwd = 2, lty = 2)

# ----------- Negative Correlation -----------
plot(data1_neg,
     type = "l",
     col = "#1B9E77",
     lwd = 2,
     ylim = range(c(data1_neg, data2_neg)),
     ylab = "Value",
     xlab = "Time",
     main = "Two trends with negative correlation")
lines(data2_neg, col = "#D95F02", lwd = 2)
legend("topleft",
       legend = c("Data 1", "Data 2"),
       col = c("#1B9E77", "#D95F02"), lwd = 2)

plot(data1_neg, data2_neg, pch = 19, col = "darkgreen",
     xlab = "Value in dataset 1", ylab = "Value in dataset 2",
     main = paste("R =", round(cor_neg, 2)))
abline(lm(data2_neg ~ data1_neg), col = "black", lwd = 2, lty = 2)
