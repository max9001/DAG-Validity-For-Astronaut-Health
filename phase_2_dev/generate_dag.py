import networkx as nx
from test_dataset import generate_synthetic_data
from pcalg import estimate_cpdag
from pcalg import estimate_skeleton
from scipy.stats import pearsonr
import numpy as np
import time


def custom_pearsonr(data_matrix, i, j, S):
    # Extract columns from the data matrix based on indices i, j, and S
    xi = data_matrix[:, i]
    xj = data_matrix[:, j]
    xs = data_matrix[:, list(S)]

    # Perform Pearson correlation test
    correlation_coefficient, p_value = pearsonr(xi, xj)

    # Return True if p-value is greater than the significance level (independence holds)
    return p_value > 0.01  # Adjust the significance level as needed

if __name__ == "__main__":
    # Test the function by generating synthetic data
    # data = np.genfromtxt("C:/Users/max/Desktop/Home/DAG/publications/OSD-366/chromosomes/chromosome_1.csv", delimiter=",", names=True, dtype=None)
    # data = data.tolist()
    # data = np.delete(data, 0, 1)
    # data = np.delete(data, 27, 1)
    # data = np.delete(data, 27, 1)

    # random_row_indices = np.random.choice(data.shape[0], size=200, replace=False)
    # data = data[random_row_indices]

    data = np.random.rand(4646,4646)
    print(data[:5])

    print(data.shape)
    print(data.dtype)

    t1 = time.time()
    (graph, sep_set) = estimate_skeleton(indep_test_func=custom_pearsonr,
                                         data_matrix=data,
                                         alpha=0.01)
    t2 = time.time()
    graph = estimate_cpdag(skel_graph=graph, sep_set=sep_set)
    
    print(t2-t1)
    # print(nx.edges(graph))
