names = ["John", "Bob", "Mosh", "Sam", "Mary", "Genie"]
names[0] = "Jon" # If you need to change a name, call it's index and then the new value
print(names[-1])
print(names[0:3]) # Python will return the indices of 0, 1 and 2 but not 3 Up to but not including

numbers = [1, 2, 3, 4, 5]
numbers.append(6)   # append will add to the end of the list
numbers.insert(0, -1) # will insert -1 at the beginning; the 0 is the index; you can add any type
numbers.remove(3)   # will remove the 3 from the list
print(numbers)

# numbers.clear() # would remove all of the numbers
print(1 in numbers) # will check to see if 1 is in your list and will return a boolean
print(len(numbers)) # built in function that will return the length of your list