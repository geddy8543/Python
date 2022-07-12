numbers = range(5)
for number in numbers:
    print(number)   # this will print numbers from 0 to 4 (will not include 5)

numbers = range(5, 10)  # will print numbers 5-9
for number in numbers:
    print(number)     
    
numbers = range(5, 10, 2) # will skip numbers (go by 2's)
for number in numbers:
    print(number)

for number in range(5): # you don't have to store as a variable, can just call it like this
    print(number)