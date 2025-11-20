def calculate_average_price(current_shares, current_price, new_shares, new_price):
    """
    Calculates the average purchase price after a new purchase.
    """
    current_total_value = current_shares * current_price
    new_total_value = new_shares * new_price
    total_shares = current_shares + new_shares
    total_value = current_total_value + new_total_value
    
    if total_shares == 0:
        return 0.0
    
    average_price = (total_value) / total_shares
    print(f"\nYour total inv amount is: {total_value:.2f}")
    return average_price

# Get user input for the share details
# Use float() for prices and int() for shares to ensure correct data types
print("--- Current Holding Details ---")
current_shares = int(input("Enter the number of shares currently owned: "))
current_price = float(input("Enter the average price of the current shares: "))

print("\n--- New Purchase Details ---")
new_shares = int(input("Enter the number of shares you want to buy: "))
new_price = float(input("Enter the price of the new shares: "))

# Calculate the new average price using the user input
new_avp = calculate_average_price(current_shares, current_price, new_shares, new_price)

# Print the result formatted to two decimal places
print(f"\nYour new average purchase price (AVP) will be: {new_avp:.2f} rs")

