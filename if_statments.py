temperature = 15
if temperature > 30: 
    print("It's a hot day")
    print("Drink plenty of water")
elif temperature > 20:
    print("It's a nice day") #(20, 30]
elif temperature > 10: # (10, 20]
    print("It's a bit chilly")
else:
    print("It's cold")

print("Done")  

## Exercise: have a user input their weight, ask them if lbs or kg and have it return the weight in the proper unit
weight = int(input("Weight: "))  # you can use int or float
unit = input("(K)g or (L)bs: ")
if unit.upper() == "K":
    converted = weight / 0.45
    print("Weight in Lbs: " + str(converted ))
else:
    converted = weight * 0.45
    print("Weight in Kgs: " + str(converted))
