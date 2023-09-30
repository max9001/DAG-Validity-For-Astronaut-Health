import numpy as np

def generate_synthetic_data(n_samples=1000):
    # Generate random data for A
    mean_a = 0
    std_a = 1
    A = np.random.normal(mean_a, std_a, n_samples)

    # Generate data for B with a causal relationship from A
    causal_strength_ab = 0.8  # Strength of the causal relationship A -> B
    mean_b = 0
    std_b = 1
    B = causal_strength_ab * A + np.random.normal(mean_b, std_b, n_samples)

    # Generate data for C with a causal relationship from B
    causal_strength_bc = 0.7  # Strength of the causal relationship B -> C
    mean_c = 0
    std_c = 1
    C = causal_strength_bc * B + np.random.normal(mean_c, std_c, n_samples)

    # Create a NumPy array with the three variables as columns
    data = np.column_stack((A, B, C))

    return data