import pandas as pd
from sqlalchemy import create_engine

# =========================
# DATABASE CONNECTION
# =========================

username = "emeka"
password = "Emmizzy119?"
host = "localhost"
port = "3306"
database = "retail_business_db"

engine = create_engine(
    f"mysql+pymysql://{username}:{password}@{host}:{port}/{database}"
)

# =========================
# FILE PATHS
# =========================

base_path = "/home/emeka/GoogleDrive/ML_Portfolio/sql-retail-business-intelligence/data/raw/"

files = {
    "customers": "olist_customers_dataset.csv",
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "products": "olist_products_dataset.csv",
    "payments": "olist_order_payments_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "category_translation": "product_category_name_translation.csv"
}

# =========================
# LOAD TABLES
# =========================

for table_name, file_name in files.items():

    print(f"\nLoading {table_name}...")

    file_path = base_path + file_name

    df = pd.read_csv(file_path)

    df.to_sql(
        name=table_name,
        con=engine,
        if_exists="replace",
        index=False
    )

    print(f"{table_name} loaded successfully.")

print("\nAll tables loaded.")