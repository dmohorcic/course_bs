data {
  int<lower=1> n;          // number of data points
  int<lower=0> m;          // number of independent variables
  matrix[n,m] X;           // independent variables
  array[n] int<lower=0> y; // dependent variable 
}

parameters {
  real alpha;
  vector[m] beta;
}

model {
  // poisson model
  for (i in 1:n) {
    y[i] ~ poisson(exp(alpha + X[i] * beta));
  }
}

generated quantities {
  // lambdas
  vector<lower=0>[n] lambda;

  // predictions
  array[n] int<lower=0> pred;

  for (i in 1:n) {
    // calculate the lambda
    lambda[i] = exp(alpha + X[i] * beta);
    // use the lambda and the random poisson generator to get the prediction
    pred[i] = poisson_rng(lambda[i]);
  }
}
