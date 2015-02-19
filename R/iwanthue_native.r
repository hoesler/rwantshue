#' @include color.r
NULL

distance_order <- function(lab) {
  pairwise_distance <- as.matrix(dist(lab, diag=TRUE, upper=TRUE))
  order <- 1
  for (i in 1:nrow(pairwise_distance)-1) {
    candidates <- pairwise_distance[i, setdiff(1:ncol(pairwise_distance), order), drop = FALSE]
    next_index <- as.integer(colnames(candidates)[which.max(candidates)])
    order <- c(order, next_index)
  }
  order
}

iwanthue.kmeans <- function(n = 8, lch_range = list(L = c(0,100), C = c(0,100), H = c(0,360)), ...) {
	require(yaImpute)
  require(dplyr)

  sample_size <- 100000
  
  lab_samples <- LAB(runif(sample_size, 0,100), runif(sample_size, -100,100), runif(sample_size, -100,100))
	
  valid_colors <- as.data.frame(as(lab_samples, "RGB")@coords) %>%
    transmute(valid = R >= 0 & R <= 1 & G >= 0 & G <= 1 & B >= 0 & B <= 1)
  lab_samples <- subset(lab_samples, valid_colors$valid)

  valid_colors <- as.data.frame(as(lab_samples, "polarLAB")@coords) %>%
    transmute(valid = L >= lch_range[["L"]][1] & L <= lch_range[["L"]][2] &
      C >= lch_range[["C"]][1] * 141.4214 / 100 & C <= lch_range[["C"]][2] * 141.4214 / 100 &
      H >= lch_range[["H"]][1] & H <= lch_range[["H"]][2])
  filtered_samples <- subset(lab_samples, valid_colors$valid)

  # run k-means
  lab_means_coords <- kmeans(filtered_samples@coords, n, iter.max = 20)$centers

  # get nearest RGB convertable color to all means
	convertable_means <- lab_samples[yaImpute::ann(lab_samples@coords, lab_means_coords, 1, verbose = FALSE)$knnIndexDist[ ,1], ]

  # order colors by distance
  order <- distance_order(convertable_means@coords)

  # return hex value
	return(hex(convertable_means)[order])
}

iwanthue.ga <- function(n = 8, lch_range = list(L = c(0,100), C = c(0,100), H = c(0,360)), iterations = 100) {

  mutate <- function(lab_parent) {    
    lab_child <- lab_parent + matrix(rnorm(nrow(lab_parent) * ncol(lab_parent), 0, 4), nrow = nrow(lab_parent), ncol = ncol(lab_parent))
    lab_child <- limit_range(lab_child)
    lab_child <- fix_lab(lab_child)
    lab_child
  }

  fix_lab <- function(lab_coords) {
    lab_coords[lab_coords[, "L"] < 0, "L"] <- 0
    lab_coords[lab_coords[, "L"] > 100, "L"] <- 100
    lab_coords[lab_coords[, "A"] < -100, "A"] <- -100
    lab_coords[lab_coords[, "A"] > 100, "A"] <- 100
    lab_coords[lab_coords[, "B"] < -100, "B"] <- -100
    lab_coords[lab_coords[, "B"] > 100, "B"] <- 100
    lab_coords
  }

  limit_range <- function(lab_coords) {
    polarlab_child <- LAB_to_polarLAB(lab_coords)
    polarlab_child[polarlab_child[, "L"] < lch_range[["L"]][1], "L"] <- lch_range[["L"]][1]
    polarlab_child[polarlab_child[, "L"] > lch_range[["L"]][2], "L"] <- lch_range[["L"]][2]
    polarlab_child[polarlab_child[, "C"] < lch_range[["C"]][1], "C"] <- lch_range[["C"]][1]
    polarlab_child[polarlab_child[, "C"] > lch_range[["C"]][2], "C"] <- lch_range[["C"]][2]
    polarlab_child[polarlab_child[, "H"] < lch_range[["H"]][1], "H"] <- lch_range[["H"]][1]
    polarlab_child[polarlab_child[, "H"] > lch_range[["H"]][2], "H"] <- lch_range[["H"]][2]
    polarLAB_to_LAB(polarlab_child)
  }

  fitness <- function(lab_coords) {
    paiwise_distance <- dist(lab_coords)
    min(paiwise_distance) ^ 2 + mean(paiwise_distance)
  }

  population <- lapply(1:50, function(i) {
    polarLAB_to_LAB(cbind(
      L = runif(n, lch_range[["L"]][1], lch_range[["L"]][2]),
      C = runif(n, lch_range[["C"]][1], lch_range[["C"]][2]),
      H = runif(n, lch_range[["H"]][1], lch_range[["H"]][2])
    ))
  })

  for (i in 1:iterations) {
    # fitness
    population_fitness <- lapply(population, fitness)
    fitness_order <- order(unlist(population_fitness), decreasing = TRUE)
    
    # select (elitist)
    parents <- population[fitness_order[1:5]]

    # reproduce
    population <- unlist(lapply(parents, function(parent) {
      lapply(1:10, function(child_no) { mutate(parent) })
    }), recursive = F) 
  }

  population_fitness <- lapply(population, fitness)
  fitness_order <- order(unlist(population_fitness), decreasing = TRUE)
  optimal_colors <- population[[fitness_order[1]]]

  # Get the nearest RGB neighbor for each optimal LAB color
  # 1. sample the whole LAB space
  sample_size <- 100000
  lab_samples <- LAB(runif(sample_size, 0,100), runif(sample_size, -100,100), runif(sample_size, -100,100))  
  # 2. filter out RGB convertable values
  rgb_convertable <- as.data.frame(as(lab_samples, "RGB")@coords) %>%
    transmute(valid = R >= 0 & R <= 1 & G >= 0 & G <= 1 & B >= 0 & B <= 1)
  lab_samples <- subset(lab_samples, rgb_convertable$valid)
  # 3. nearest neighbor search
  optimal_colors_convertable <- lab_samples[yaImpute::ann(lab_samples@coords, optimal_colors, 1, verbose = FALSE)$knnIndexDist[ ,1], ]

  # order colors by distance
  order <- distance_order(optimal_colors_convertable@coords)

  # return hex value
  return(hex(optimal_colors_convertable)[order])
}