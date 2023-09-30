options(digits = 0)
# require(bnlearn)
# install.packages("bnlearn")
library(bnlearn)
library(Rgraphviz)


# load predefined dataset. this dataset is from bnlearn
data(gaussian.test)

#print first couple rows
head(gaussian.test)

# output
#    A  B  C  D E  F G
# 1  1  2  7  9 1 25 9
# 2 -0 11 24 23 7 37 4
# 3  2  3 11 11 4 22 2
# 4  1  4 11 12 1 23 6
# 5  0  5 10 13 4 25 5
# 6  2  1  7  7 7 28 8

# (in actuality there are 5000 rows to this dataset)

# normalize values in table to be between 0 and 1 
# (represent continuous values or measurements (such as temperature, height, time, etc.))
max_value <- max(unlist(gaussian.test))

gaussian.test_normalized <- apply(gaussian.test, 2, function(x) x / max_value)

# Print the resulting normalized dataframe
head(gaussian.test_normalized)



# Use pc.stable to estimate the DAG structure
dag <- pc.stable(gaussian.test)

# Visualize the resulting DAG
graphviz.plot(dag)


# ======================================================
# Discretize tabular data
# ======================================================

# Discretize using the "interval" method
discretized_interval <- discretize(
    data = gaussian.test,
    method = "interval",
    breaks = 4,
    ordered = TRUE
)

# Discretize using the "quantile" method
discretized_quantile <- discretize(
    data = gaussian.test,
    method = "quantile",
    breaks = 4,
    ordered = TRUE
)

# Discretize using the "hartemink" method
discretized_hartemink <- discretize(
    data = gaussian.test,
    method = "hartemink",
    breaks = 4,
    ordered = TRUE
)


dag <- pc.stable(hartemink_interval)

# Visualize the resulting DAG
graphviz.plot(dag)




x <- 5L
print(class(x))

x <- as.numeric(x)
print(class(x))

x <- x * 1.1
print(x)

y <- 5
print(class(y))

y <- 5 * 1.1
print(y)

z <- pi
print(class(z))
print(z)

print(pi)

# =====================
# Notes
# =====================

# The algorithm starts by assuming that all variables (nodes) are connected

# Then, connections are removed to form the skeleton of the network
#     correlation coefficient is calculated for the pairs. removes connection if close to 0
#     information-theoretic measures are used to assess how much information one variable provides about another

























# ======================================================
# Discretize tabular data
# ======================================================
# 
# # Discretize using the "interval" method
# discretized_interval <- discretize(
#     data = gaussian.test,
#     method = "interval",
#     breaks = 4,
#     ordered = TRUE
# )
# 
# # Discretize using the "quantile" method
# discretized_quantile <- discretize(
#     data = gaussian.test,
#     method = "quantile",
#     breaks = 4,
#     ordered = TRUE
# )
# 
# # Discretize using the "hartemink" method
# discretized_hartemink <- discretize(
#     data = gaussian.test,
#     method = "hartemink",
#     breaks = 4,
#     ordered = TRUE
# )
# 
# # Store the discretized variables in a list
# list_M <- list(
#     interval = discretized_interval,
#     quantile = discretized_quantile,
#     hartemink = discretized_hartemink
# )
# 
# # summary(discretized_interval)
# # summary(discretized_quantile)
# # summary(discretized_hartemink)
# 





# v_algorithms <- c(
#     "pc.stable","gs","iamb","fast.iamb","inter.iamb","iamb.fdr","mmpc",
#     "si.hiton.pc", "hpc", "hc", "tabu", "rsmax2", "mmhc", "h2pc", 
#     "aracne", "chow.liu"
# )
# 
# list_bnlearn <- list()
# 
# for(j in v_algorithms) for(k in names(list_M)) try({
#     list_bnlearn[[j]][[k]] <- do.call(
#         what = j,
#         args = list(x = list_M[[k]])
#     )
#     M_arcs <-arcs(list_bnlearn[[j]][[k]])
#     for(l in 1:nrow(M_arcs)){
#         list_bnlearn[[j]][[k]] <- set.arc(
#             x = list_bnlearn[[j]][[k]],
#             from = M_arcs[l,1],
#             to = M_arcs[l,2],
#             check.cycles = FALSE,
#             check.illegal = FALSE            
#         )
#         list_bnlearn[[j]][[k]] <- choose.direction(
#             x = list_bnlearn[[j]][[k]],
#             arc = M_arcs[l,],
#             data = list_M[[k]]
#         )
#     }
# }, silent = FALSE)
# 
# 
# # =====================
# # scoring the networks
# # =====================
# 
# M_score <- matrix(
#     data = NA,
#     nrow = length(v_algorithms),
#     ncol = length(list_M),
# )
# 
# rownames(M_score) <- v_algorithms
# colnames(M_score) <- names(list_M)
# 
# for(j in v_algorithms) for(k in names(list_M)) try({
#     M_score[j,k] <- score(
#         x = list_bnlearn[[j]][[k]],
#         data = list_M[[k]],
#         type = "bic"
#     )
# })
# 
# # for(j in rownames(M_score)) M_score <- M_score[,order(M_score[j,])]
# # for(J in colnames(M_score)) M_score <- M_score[order(M_score[,j]),]
# 
# # for (j in rownames(M_score)) {
# #     M_score <- M_score[, order(M_score[j, ], na.last = NA)]
# # }
# # 
# # for (j in colnames(M_score)) {
# #     M_score <- M_score[order(M_score[, j], na.last = NA), ]
# # }
# 
# M_score
