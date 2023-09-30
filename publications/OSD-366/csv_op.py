import pandas as pd

file_path = "C:/Users/max/Desktop/Home/DAG/publications/OSD-366/GLDS-366_GWAS_processed_associations.csv"
OSD366 = pd.read_csv(file_path, low_memory= False)

cols_to_remove = [col for col in OSD366.columns if col.endswith('.1')]
OSD366 = OSD366.drop(columns=cols_to_remove)
num_na_per_row = OSD366.isna().sum(axis=1)
OSD366 = OSD366[num_na_per_row < 32]

print(OSD366.shape)
OSD366 = OSD366.drop_duplicates(subset=['position.b38.'])

print(OSD366.shape)

print(OSD366)

# unique_chromosomes = OSD366['chromosome'].unique()
# for chromosome in unique_chromosomes:
#     OSD366[chromosome] = (OSD366['chromosome'] == chromosome).astype(int)
# OSD366.drop(columns=['chromosome'], inplace=True)

# OSD366.to_csv( "C:/Users/max/Desktop/Home/DAG/publications/OSD-366/GLDS-366_GWAS_processed_associations_fix.csv", index=False)


chromosome_types = OSD366['chromosome'].unique()

# Iterate through each chromosome type and save to a separate CSV file
for chromosome_type in chromosome_types:
    # Create a filter to select rows with the current chromosome type
    filter_condition = OSD366['chromosome'] == chromosome_type
    
    # Filter the DataFrame
    filtered_data = OSD366[filter_condition]
    
    # Define the filename for the CSV file
    filename = f"C:/Users/max/Desktop/Home/DAG/publications/OSD-366/chromosomes/chromosome_{chromosome_type}.csv"
    
    # Save the filtered data to a CSV file
    filtered_data.to_csv(filename, index=False)
