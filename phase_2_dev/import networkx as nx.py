import networkx as nx
from scipy.stats import pearsonr
import numpy as np
import time



if __name__ == "__main__":
    data = np.genfromtxt("C:/Users/max/Desktop/Home/DAG/publications/OSD-366/chromosomes/chromosome_1.csv", delimiter=",", dtype = None, encoding = None)
    names = data[0].tolist()
    data = data[1:]
    data = data.tolist()
    data = np.delete(data, 0, 1)
    data = np.delete(data, 27, 1)
    data = np.delete(data, 27, 1)
    print(data[:5])
    print("\n\n\n")
    print(names)
    
   

    # random_row_indices = np.random.choice(data.shape[0], size=200, replace=False)
    # data = data[random_row_indices]