class Employee:
    def __init__(self, name, age, position, salary):
        self.name = name
        self.age = age
        self.position = position
        self.salary = salary

    def increase_ssalary(self, percent):
        self.salary += self.salary * (percent/100)

    # def info(self): # we took the string from this out and put it in the def __str__ method instead
    #     print(f"{self.name} is {self.age} years old. Employee is a {self.position} with the salary of ${self.salary}")

    def __str__(self):
        return f"{self.name} is {self.age} years old. Employee is a {self.position} with the salary of ${self.salary}"
        
employee1 = Employee("Ji-Soo", 38, "developer", 1200)
employee2 = Employee("Lauren", 44, "tester", 1000)
print(employee1) 
    