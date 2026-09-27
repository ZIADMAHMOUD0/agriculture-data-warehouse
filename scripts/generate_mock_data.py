import pandas as pd
import numpy as np
import os

# Set seed for reproducibility
np.random.seed(42)

# Configuration
num_records = 1000
output_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'data', 'incoming', 'farm_yield_data.csv')

# Data Pools
crops = ['Wheat', 'Rice', 'Corn', 'Soybeans', 'Cotton', 'Sugarcane']
regions = ['North', 'South', 'East', 'West', 'Central']
soils = ['Clay', 'Sandy', 'Loamy', 'Silt', 'Peaty']
irrigations = ['Drip', 'Sprinkler', 'Flood', 'Manual']
seasons = ['Kharif', 'Rabi', 'Summer', 'Monsoon']

# Generate Data
data = {
    'Farm_ID': np.random.randint(1001, 2000, size=num_records),
    'Crop_Type': np.random.choice(crops, size=num_records),
    'Region': np.random.choice(regions, size=num_records),
    'Soil_Type': np.random.choice(soils, size=num_records),
    'Irrigation_Type': np.random.choice(irrigations, size=num_records),
    'Fertilizer_Used': np.random.uniform(50, 500, size=num_records).round(2),
    'Pesticide_Used': np.random.uniform(5, 50, size=num_records).round(2),
    'Water_Usage': np.random.uniform(100, 1000, size=num_records).round(2),
    'Rainfall': np.random.uniform(200, 1500, size=num_records).round(2),
    'Temperature': np.random.uniform(15, 45, size=num_records).round(2),
    'Harvest_Season': np.random.choice(seasons, size=num_records),
    'Yield': np.random.uniform(1, 15, size=num_records).round(2)
}

df = pd.DataFrame(data)

# Save to CSV
os.makedirs(os.path.dirname(output_path), exist_ok=True)
df.to_csv(output_path, index=False)

print(f"Successfully generated {num_records} records at {output_path}")
