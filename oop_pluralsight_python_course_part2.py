# After the inheritance lesson
class Employee:  #Employee class will serve as a Parent class in the hierarchy
    def __init__(self, name, age, salary):
        self.name = name
        self.age = age
        self.salary = salary

    def increase_salary(self, percent):
        self.salary += self.salary * (percent/100)

class Tester(Employee): # the tester subclass (child class) will inherit all of the methods from the employee class
    pass   

employee1 = Tester("Lauren", 44, 1000)

employee1.increase_salary(20)
print(employee1.salary)