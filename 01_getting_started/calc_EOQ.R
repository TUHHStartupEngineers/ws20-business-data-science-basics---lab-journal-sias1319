calc_EOQ <- function(D = 1000) {
  K <- 5
  h <- 0.25
  Q <- sqrt(2*D*K/h)
  Q
}

roll <- function(faces = 1:6, numOfDice = 1, probDice = NULL) {
  dice <- sample(faces, size = numOfDice, replace = TRUE, prob = probDice)
  sum(dice)
}

