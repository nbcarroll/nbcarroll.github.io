import pandas as pd
import os

files = [file for file in os.listdir('.') if file.endswith('.csv')] 

all_dataframes = []
for file in files:
    df = pd.read_csv(file)  
    all_dataframes.append(df)

unioned_df = pd.concat(all_dataframes, ignore_index=True)

unioned_df.to_csv('alaska_air_seatac_departure_2015_to_2023.csv', index=False)
