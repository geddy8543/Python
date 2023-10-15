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

    def __str__(self): #output will be human readable form for str
        return f"{self.name} is {self.age} years old. Employee is a {self.position} with the salary of ${self.salary}"

    def __repr__(self): #output will be more formal; for developers (but it will not create a new employee object)
        return (
            f"Employee("
            f"{repr(self.name)}, {repr(self.age)}, "
            f"{repr(self.position)}, {repr(self.salary)})"
        )
    
    def __add__(self, other_employee):
        # e.g. combines their age and returns a new employee
        return Employee("New", self.age + other_employee.age, "dev", 2000)
    
employee1 = Employee("Ji-Soo", 38, "developer", 1200)
employee2 = Employee("Lauren", 44, "tester", 1000)

employee3 = employee1 + employee2

# print(str(employee1)) #use this only when you need the str
print(repr(employee1))


    