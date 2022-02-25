# Import data
mtcars = as_tibble(mtcars)
mtcars %>% head(2)

# Linear regression
linear_reg = lm(mpg ~ wt, data=mtcars)
print(summary(linear_reg))

# Linear regression summary
linear_reg_summary = summary(linear_reg )
linear_reg_summary$r.squared

# Residual plot
resids = as.vector(linear_reg$residuals) #Yhat list of predicted values

reg_df = mtcars  %>% select(wt, mpg) #Create new df
reg_df = reg_df %>% mutate(yhat = resids)
reg_df

reg_df %>% ggplot(aes(mpg, yhat))+ geom_point()


# Linear regression by hand

X = as.matrix(mtcars %>% select(wt)) 
X = cbind(X,rep(1,length(X)))
Y = as.matrix(mtcars %>% select(mpg))

A = solve(t(X)%*%X)
bhat_hand = A  %*% t(X) %*% Y 
print(bhat_hand)

## Above answer is equivalent
lm(mpg ~ wt, data=mtcars)


## Panel data
install.packages('plm')
library(plm)

data("Grunfeld", package="plm")

res = plm(inv ~ value+capital, 
               data = Grunfeld, 
               model = "random" #FE: within #RE: random
    )

summary(res)





