library(withr)
library(tibble)
library(rlang)
library(tidyverse)
library(rstan)
library(loo)

rstan_options(auto_write = TRUE)
options(mc.cores = 8)

# casecqmu.tsv from dataset cqmu
data <- read_tsv(file = "casecqmu.tsv")


data <- data %>% 
  mutate(tSymptomOnset = as.integer((Onsetdate %>% as.Date(format = "%Y/%m/%d")) - as.Date("2020-01-10")),
         tStartExposure = as.integer((Firstdate %>% as.Date(format = "%Y/%m/%d")) - as.Date("2020-01-10")),
         tEndExposure = as.integer((Lastdate %>% as.Date(format = "%Y/%m/%d")) - as.Date("2020-01-10")),
         tFamgen=as.integer(group_gen)) %>%
  mutate(tStartExposure = ifelse(is.na(tStartExposure), tEndExposure-2, tStartExposure)) %>%
  mutate(tEndExposure = ifelse(tEndExposure > tSymptomOnset, tSymptomOnset, tEndExposure))

tdata2=NULL

# tFamgen= 2，3，4 for G2,G3,G4
tdata2=data[data$tFamgen==c(3),]


input.data <- list(
  N = nrow(tdata2),
  tStartExposure = tdata2$tStartExposure,
  tEndExposure = tdata2$tEndExposure,
  tSymptomOnset = tdata2$tSymptomOnset)


#-------Weibull---------------------------------------------------

# compile model: weibull

model.wbl <- stan(data = input.data, 
                  chains = 1, 
                  iter =1,
                  model_code = "
data{
  int <lower = 1> N;
  vector[N] tStartExposure;
  vector[N] tEndExposure;
  vector[N] tSymptomOnset;
}

parameters{
  real<lower = 0> alphaInc; 	// Shape parameter of weibull distributed incubation period
  real<lower = 0> sigmaInc; 	// Scale parameter of weibull distributed incubation period
  vector<lower = 0, upper = 1>[N] uE;	// Uniform value for sampling between start and end exposure
}

transformed parameters{
  vector[N] tE; 	// infection moment
  tE = tStartExposure + uE .* (tEndExposure - tStartExposure);
}

model{
  // Contribution to likelihood of incubation period
  target += weibull_lpdf(tSymptomOnset -  tE  | alphaInc, sigmaInc);
}

generated quantities {
  // likelihood for calculation of looIC
  vector[N] log_lik;
  for (i in 1:N) {
    log_lik[i] = weibull_lpdf(tSymptomOnset[i] -  tE[i]  | alphaInc, sigmaInc);
  }
}
"
)

weibllfit.w <- NULL

weibllfit.w <- stan(fit = model.wbl, data = input.data, 
                    init = "random",
                    warmup = 34000,
                    iter = 54000, 
                    chains = 8)

# modelfit
LL = extract_log_lik(weibllfit.w, parameter_name = 'log_lik')
loo(LL)

# results
alpha <- rstan::extract(weibllfit.w)$alphaInc
sigma <- rstan::extract(weibllfit.w)$sigmaInc

IcubationPeriod <- (sigma*gamma(1+1/alpha))
hist(IcubationPeriod)

# posterior median and 95%CI of mean
quantile(IcubationPeriod, probs = c(0.025,0.5,0.975))

