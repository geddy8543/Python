# After the inheritance lesson
class Employee:  #Employee class will serve as a Parent class in the hierarchy
    __slots__ = ("name", "age", "salary")

    def __init__(self, name, age, salary):
        self.name = name
        self.age = age
        self.salary = salary

    def increase_salary(self, percent):
        self.salary += self.salary * (percent/100)

class SlotsInspectorMixin: #mixin tells you it will be used in a multiple inheritance scenario; you can add it to any class
    def has_slots(self):
        return hasattr(self, "__slots__")

class Developer(SlotsInspectorMixin, Employee): #2 superclasses, it will inherit from both
    __slots__ = ("framework") #add any additional attributes in the subclass
    
    def __init__(self, name, age, salary, framework):
        super().__init__(name, age, salary)
        self.framework = framework
        
    def increase_salary(self, percent, bonus=0):
        super().increase_salary(percent)
        #Employee.increase_salary(self, percent)
        self.salary += bonus

employee1 = Tester("Lauren", 44, 1000)

employee1.increase_salary(20)
print(employee1.salary)
employee1.run_tests()

try:
    #something that raises the FloatingPointError or the ZeroDivisionError
    raise FloatingPointError("Watch out, a floating point error!")
except ArithmeticError as e:
    #handle this error
    print(e)