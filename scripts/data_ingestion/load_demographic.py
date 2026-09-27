# libraries and packages
from pathlib import Path
import pandas as pd
import pyodbc


def load_demographic():

    # ----------------------------------------
    # Load data
    # ----------------------------------------

    BASE_DIR = Path(__file__).resolve().parents[2]

    FILE_NAME = "demographic.csv"
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
    # Push demographic to database
    # ----------------------------------------

    cursor.execute("SET IDENTITY_INSERT demographic ON")

    for _, row in df.iterrows():

        cursor.execute("""
            INSERT INTO demographic (
                CustomerId,
                Gender,
                Age,
                Salary,
                LocationId,
                Churned
            )
            VALUES (?, ?, ?, ?, ?, ?)
        """,
            int(row.CustomerId),
            row.Gender,
            int(row.Age),
            float(row.Salary),
            int(row.LocationId),
            int(row.Churned)
        )

    cursor.execute("SET IDENTITY_INSERT demographic OFF")

    conn.commit()

    print("Demographic data inserted successfully")


    # ----------------------------------------
    # Close connection
    # ----------------------------------------

    cursor.close()
    conn.close()