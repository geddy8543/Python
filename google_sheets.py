import pandas as pd

# Read CSV file into a pandas DataFrame
csv_file = "/Users/gail.eddy/Desktop/Disrupted Definition data.csv"
df = pd.read_csv(csv_file)
print(df)

# Write the DataFrame to a Parquet file using pyarrow
# df.to_parquet("output_file.parquet", engine="pyarrow")