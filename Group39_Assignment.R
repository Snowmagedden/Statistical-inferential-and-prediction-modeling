########################

# Group 39
#Dennis Hokke 2045370/u589426
#Arati Sharma: 2047448/ u289062
#Yaohua Liu : 2041746/ u844976


#########################
library(mice)
library(MLmetrics)
library(jtools)
#library(VIM)

dataDir  <- "../data/"
plotDir <- "../figs/"
wave6 <- readRDS(paste0(dataDir, "wvs_data.rds"))

#cleaning the data
wave6_matrix<- apply(wave6, 2, function(x) ifelse(x<0, NA, x))
wv6<- as.data.frame(matrix(unlist(wave6_matrix), nrow = 13156))

#Replacing column names and row ID's
colnames(wv6) <- colnames(wave6)
rownames(wv6) <- rownames(wave6)

#Summary of data compared with original
str(wave6)
str(wv6)
summary(wave6)
summary(wv6)
head(wave6)
head(wv6)
dim(wave6)
dim(wv6)

#Missing data
cm <- colSums(is.na(wv6))
pm <- colMeans(is.na(wv6))

#Observed data
co <- colSums(!is.na(wv6))
po <- colMeans(!is.na(wv6))

# Double check using Missing data pattern
pat <- md.pattern(wv6, plot = FALSE)
summary(pat)

pat[nrow(pat), ]
pat[ , ncol(pat)]
as.numeric(rownames(pat))

#Covariance coverage
cc <- md.pairs(wv6)$rr / nrow(wv6)

## Summarize coverages:
range(cc)
## Check that coverage exceeds some threshold:
eps <- 0.9
all(cc > eps)

## Find problematic pairs:
prob <- cc <= eps
apply(prob, 1, function(x) names(x)[x])

cc[lower.tri(cc)]

#Extracting variables for further use
part1 <- wv6[,c('V240','V242','V10','V11','V23','V45','V46','V47','V52','V57','V58','V59','V107','V132','V139', 'V239', 'V237', 'V233', 'V231', 'V232', 'V229', 'V226', 'V227', 'V141', 'V142', 'V213','V190', 'V191', 'V189', 'V188','V184','V183','V182','V181','V180','V179','V178','V177','V173','V174', 'V175','V172','V171','V170')]

# Missing data graph
#mice_plot <- aggr(part1, col=c('navyblue','yellow'),
#                    numbers=TRUE, sortVars=TRUE,
#                    labels=names(part1), cex.axis=.7,
#                    gap=3, ylab=c("Missing data","Pattern"))

#impute missing data
imputed_Data_pmm <- mice(part1, m=10, maxit = 5, method = 'pmm', seed = 2045370)
summary(imputed_Data_pmm)
imputed_Data_pmm$imp$V10

#trace plot pdf
pdf(paste0(plotDir, "miceTracePlots_pmm.pdf"), onefile = TRUE)
plot(imputed_Data_pmm)
dev.off()

#density plot
pdf(paste0(plotDir, "miceDensityPlots_normboot.pdf"), onefile = TRUE)
densityplot(imputed_Data_pmm)
dev.off()

#Outliers
impList <- complete(imputed_Data_pmm, "all")
olList <- lapply(impList, mdOutliers, critProb = 0.99)
summary(olList)
olCounts <- table(unlist(olList))
olCounts
list5 <- complete(imputed_Data_pmm,5)
sum(is.na(list5))

olCounts <- table(unlist(olList))
summary(olCounts)

# Inferential modeling
# Question explored:
# Are conservative attitudes good or bad for your psychological well-being?

# dependent variable
# V10: Feeling of happiness


## Define a function to extract p-values from a fitted lm object:
getP <- function(obj, what) summary(obj)$coef[what, "Pr(>|t|)"]

## Define function to figure out if variable is significant:
isSig <- function(obj, what, alpha = 0.05)
  ifelse(getP(obj, what) < alpha, "YES", "NO")

# model 1
# independent variables
# looking at the impact of attitudes towards gender roles, no controls

out1_nc <-lm(V10 ~ V45+ V47+V52+V139+V46+V107, data = list5)
summary(out1_nc)
summ(out1_nc)

# control for health status, marrital status and financial status
out1_c <-update(out1_nc, ". ~ . + V57+V59+V11")
summary(out1_c)
summ(out1_c)

isSig(out1_nc, 'V45', alpha=0.05)
isSig(out1_nc, 'V47', alpha=0.05)
isSig(out1_nc, 'V52', alpha=0.05)

isSig(out1_nc, 'V139', alpha=0.05)
isSig(out1_nc, 'V46', alpha=0.05)
isSig(out1_nc, 'V107', alpha=0.05)

isSig(out1_c, 'V45', alpha=0.05)
isSig(out1_c, 'V47', alpha=0.05)
isSig(out1_c, 'V52', alpha=0.05)

isSig(out1_c, 'V139', alpha=0.05)
isSig(out1_c, 'V46', alpha=0.05)
isSig(out1_c, 'V107', alpha=0.05)

isSig(out1_c, 'V57', alpha=0.05)
isSig(out1_c, 'V59', alpha=0.05)
isSig(out1_c, 'V11', alpha=0.05)

## Predictive modeling
# Question explored: Prediction of satisfaction with life
# Dependent variable: V23 Satisfaction with your life

set.seed(235711)

index <- sample(c(rep("train", 9209), rep('test', 3947)))
yps2  <- split(list5, index)
train <- yps2$train
test <- yps2$test

#add models
# first model, financial status+type of job
#V239 Scale of incomes
#V237 Family savings during past year
#V233 Nature of tasks: independence
#V231 Nature of tasks: manual vs. intellectual
#V232 Nature of tasks: routine vs. creative
#V229 Employment status
#V190 In the last 12 month, how often have you or your family: Gone without needed medicine or
#treatment that you needed
#V191 In the last 12 month, how often have you or your family: Gone without a cash income
#V188 In the last 12 month, how often have you or your family: Gone without enough food to eat
#V182 Worries: Not being able to give one's children a good education
#V181 Worries: Losing my job or not finding a job

#model 2

#V226 Vote in elections: local level
#V227 Vote in elections: National level
#V141 How democratically is this country being governed today
#V142 How much respect is there for individual human rights nowadays in this country
#V213 I see myself as part of my local community

#model 3

#V189 In the last 12 month, how often have you or your family: Felt unsafe from crime in your own home
#V184 Worries: A terrorist attack
#V183 Worries: A war involving my country
#V180 Respondent's family was victim of a crime during last year
#V179 Respondent was victim of a crime during the past year
#V178 Things done for reasons of security: Carried a knife, gun or other weapon
#V177 Things done for reasons of security: Preferred not to go out at night
#V173 How frequently do the following things occur in your neighborhood: Police or military interfere with people’s private life
#V174 How frequently do the following things occur in your neighborhood: Racist behavior
#V175 How frequently do the following things occur in your neighborhood: Drug sale in streets
#V172 How frequently do the following things occur in your neighborhood: Alcohol consumed in the
#V171 How frequently do the following things occur in your neighborhood: Robberies
#V170 Secure in neighborhood

# model 4
#V190	 In the last 12 month, how often have you or your family: Gone without needed medicine or
#trea	tment that you needed
#V191	 In the last 12 month, how often have you or your family: Gone without a cash income
#V188	 In the last 12 month, how often have you or your family: Gone without enough food to eat
#V182	 Worries: Not being able to give one's children a good education
#V181	 Worries: Losing my job or not finding a job
#V231	 Nature of tasks: manual vs. intellectual
#V213	 I see myself as part of my local community
#V189	 In the last 12 month, how often have you or your family: Felt unsafe from crime in your own home
#V184	 Worries: A terrorist attack
#V183	 Worries: A war involving my country
#V180	 Respondent's family was victim of a crime during last year
#V179	 Respondent was victim of a crime during the past year
#V178	 Things done for reasons of security: Carried a knife, gun or other weapon
#V177	 Things done for reasons of security: Preferred not to go out at night
#V173	 How frequently do the following things occur in your neighborhood: Police or military interfere with people’s private life
#V174	 How frequently do the following things occur in your neighborhood: Racist behavior
#V175	 How frequently do the following things occur in your neighborhood: Drug sale in streets
#V172	 How frequently do the following things occur in your neighborhood: Alcohol consumed in the streets
#V171	 How frequently do the following things occur in your neighborhood: Robberies
#V170	 Secure in neighborhood

mods <- paste(stem,
              c("V239 + V237 + V233 + V231+V232+V229+V190+V191+V188+V182+V181",
                "V226 + V227 + V141+V142+V213",
                "V189 + V184+V183+V180+V179+V178+V177+V173+V174+V175+V172+V171+V170",
                "V239+V237+V232+V233+V231+V229+V189+V190+V191+V188+V170+V171+V174+V179+V180+V173"),
              
              sep = " + ")

### Check the formulas by training the models:
fits <- lapply(mods, lm, data = train)
lapply(fits, summary)

### Perform the cross-validation:
cve <- cv.lm(data = train, models = mods, K = 10, seed = 235711)

## 3a) When comparing the models you tested in (2) based on their relative
##     cross-validation errors, which model should be preferred?
cve[which.min(cve)]

# use the test data to predict 
MSE(y_pred = predict(fits[[which.min(cve)]], newdata = test),
    y_true = test$V23)

# Regressing Imputed Data V10 on V23 and V45.
miFit1 <- lm.mids(V10 ~ V23 + V45, data = imputed_Data_pmm)
summary(miFit1)

miPool1 <- pool(miFit1)
summary(miPool1)
