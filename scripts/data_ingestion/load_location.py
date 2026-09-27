# libraries and packages
from pathlib import Path
import pandas as pd
import pyodbc


def load_location():

    # ----------------------------------------
    # Load data
    # ----------------------------------------

    BASE_DIR = Path(__file__).resolve().parents[2]

    FILE_NAME = "location.csv"
    DATA_PATH = BASE_DIR / "data" / "processed" / FILE_NAME

    df = pd.read_csv(DATA_PATH)

    location_df = df[["LocationId", "Geography"]].drop_duplicates()


    # ----------------------------------------
    # Create connection
    # ----------------------------------------

    conn = pyodbc.connect(
        "Driver={SQL Server};"
        "Server=LocalHost\\SQLEXPRESS;"
        "Database=BankChurn;"
        "Trusted_Connection=yes;"
    )

    cursor = conn.cursor()


    # ----------------------------------------
    # Push location to database
    # ----------------------------------------

    cursor.execute("SET IDENTITY_INSERT location ON")

    for index, row in location_df.iterrows():
        cursor.execute("""
            INSERT INTO location (
                LocationId,
                Geography
            )
            VALUES (?, ?)
        """,
        int(row.LocationId),
        row.Geography
        )

    cursor.execute("SET IDENTITY_INSERT location OFF")

    conn.commit()

    print("Location data inserted successfully")


    # ----------------------------------------
    # Close connection
    # ----------------------------------------

    cursor.close()
    conn.close()