import pandas as pd
data = pd.read_csv("C:/Users/Ashutosh Giri/OneDrive/Pictures/Documents/Project_2_Superstore_Analysis/data/Superstore.csv",encoding='latin1')

# print(data)
# print(data.head())
# print(data.columns)
# print(data.info())
# print(data.describe())
data["Order Date"] = pd.to_datetime(data["Order Date"], errors="coerce", dayfirst= True)
data["Ship Date"] = pd.to_datetime(data["Ship Date"], errors="coerce" , dayfirst= True)
data["Order Year"] = data["Order Date"].dt.year
data["Order Month Number"] = data["Order Date"].dt.month
data["Order Month Name"] = data["Order Date"].dt.month_name()
data["Day Name"] = data["Order Date"].dt.day_name()
data["Shipping Days"] = (data["Ship Date"] - data["Order Date"]).dt.days
data["Shipping Days"] = data["Shipping Days"].fillna(0)
def Delivery_Speed(days):
    if days == 0:
        return "Unknown"
    elif days <= 75:
        return "Fast Delivery"
    elif 3 <= days <= 150:
        return "Medium Delivery"
    else:
        return "Slow Delivery"
data["Delivery Speed"] = data["Shipping Days"].apply(Delivery_Speed)
Order_Date_NaT = data["Order Date"].isna().sum()
print(f"Number of NaT values in Order Date: {Order_Date_NaT:,}")
Ship_Date_NaT = data["Ship Date"].isna().sum()
print(f"Number of NaT values in Ship Date: {Ship_Date_NaT:,}")
Max_Order_Month = data.groupby("Order Month Name")["Order ID"].count().idxmax()
print(f"The Maximum Order in a Month is: {Max_Order_Month}")
MaxDiscount = data["Discount"].max()
print(f"The Maximum Discount is: {MaxDiscount}")
MinDiscount = data["Discount"].min()
print(f"The Minimum Discount is: {MinDiscount}")
def Discount_Level(Discount):
    if Discount <= 0.2:
        return "Low Discount"
    elif  0.2 < Discount <= 0.5:
        return "Medium Discount"
    else:
        return "High Discount"
data["Discount Level"] = data["Discount"].apply(Discount_Level)
data = data.dropna(subset=["Order Date", "Ship Date"])
data["Discount Level"] = data["Discount"].apply(Discount_Level)
data = data.dropna(subset=["Order Date", "Ship Date"])
data["Discount Level"] = data["Discount"].apply(Discount_Level)

data = data.dropna(subset=["Order Date", "Ship Date"])

data["Order Date"] = data["Order Date"].dt.strftime("%Y-%m-%d")
data["Ship Date"] = data["Ship Date"].dt.strftime("%Y-%m-%d")

data.to_csv("cleaned_superstore.csv", index=False)