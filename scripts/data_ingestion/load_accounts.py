# libraries and packages
from pathlib import Path
import pandas as pd
import pyodbc


def load_accounts():

    # ----------------------------------------
    # Load data
    # ----------------------------------------

    BASE_DIR = Path(__file__).resolve().parents[2]

    FILE_NAME = "accounts.csv"
    DATA_PATH = BASE_DIR / "data" / "processed" / FILE_NAME

    df = pd.read_csv(DATA_PATH)


    # ----------------------------------------
    # Create connection
    # ----------------------------------------

    conn = pyodbc.connect(
        "Driver={ODBC Driver 18 for SQL Server};"
        "Server=localhost\\SQLEXPRESS;"
        "Database=BankChurn;"
        "Trusted_Connection=yes;"
        "TrustServerCertificate=yes;"
    )

    cursor = conn.cursor()


    # ----------------------------------------
    # Push account to database
    # ----------------------------------------
    
    for index, row in df.iterrows():
        cursor.execute("""
            INSERT INTO account (
                CustomerId,
                Tenure, 
                Balance,     
                NumProducts,
                HasCreditCard,
                IsActive
            )
            VALUES (?, ?, ?, ?, ?, ?)
        """,
        int(row.CustomerId),
        int(row.Tenure),
        float(row.Balance),
        int(row.NumProducts),
        int(row.HasCreditCard),
        int(row.IsActive),
        )
       
    conn.commit()

    print("Accounts data inserted successfully")


    # ----------------------------------------
    # Close connection
    # ----------------------------------------

    cursor.close()
    conn.close()