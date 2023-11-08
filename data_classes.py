from dataclasses import dataclass

class Project:
    def __init__(self, name, payment, client):
        self.name = name
        self.payment = payment
        self.client = client

    def __repr__(self):
        return f"Project(name={repr(self.name)}, payment={repr(self.payment)}, client={repr(self.client)})"
        
class Employee:
    def __init__(self, name, age, salary, project):
        self.name = name
        self.age = age
        self.salary = salary
        self.project = project

p = Project("Django app", 20000, "Globomantics") #the project instance is an attribute of the employee instance
e = Employee("Ji-Soo", 38, 1000, p) #create a new employee instance and pass the project instance to it as a last argument
print(e.project)

#Composition: the relationship between classes; it employs the 'has a' relationship vs inheritance which uses an 'is a' relationship. Composition is usually better 
#Employee 'has a' project

        