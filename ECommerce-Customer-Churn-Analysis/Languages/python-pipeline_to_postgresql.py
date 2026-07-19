import os
import pandas as pd
from sqlalchemy import create_engine

DB_USER = 'postgres'
DB_PASSWORD = '152911'
DB_HOST = 'localhost'
DB_PORT = '5432'
DB_NAME = 'postgres'

XLSX_FILE_PATH = r'C:\Users\shara\pythonstart\E Commerce Dataset (3).xlsx'

def load_and_clean_data(file_path):
    if not os.path.exists(file_path):
        print(f"[ERROR] Source file not found at: {file_path}")
        return None
    try:
        df = pd.read_excel(file_path, sheet_name='E Comm')
        
        for col in df.columns:
            if df[col].isnull().sum() > 0:
                if df[col].dtype in ['int64', 'float64']:
                    df[col] = df[col].fillna(df[col].median())
                else:
                    df[col] = df[col].fillna('Unknown')
                    
        df.columns = df.columns.str.lower()
        print(f"[INFO] Successfully loaded and cleaned {len(df)} rows.")
        return df
    except Exception as e:
        print(f"[ERROR] Failed to read or clean file: {e}")
        return None

def main():
    print("[INFO] Starting Data Pipeline...")
    
    df = load_and_clean_data(XLSX_FILE_PATH)
    if df is None:
        return
        
    try:
        connection_string = f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
        engine = create_engine(connection_string)
        
        print("[INFO] Ingesting data into PostgreSQL...")
        df.to_sql('ecommerce_churn', con=engine, if_exists='replace', index=False)
        
        print("[SUCCESS] Data Pipeline executed successfully. Data loaded to pgAdmin.")
        
    except Exception as e:
        print(f"[CRITICAL] Pipeline execution failed: {e}")

if __name__ == "__main__":
    main()