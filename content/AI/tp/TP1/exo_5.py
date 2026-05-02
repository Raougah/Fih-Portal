"""
Name: Mohammed Alaa Eddine Mekibes
Date: 19 / 02 / 2026
Code: Sheet Nr 1 (Part 1) Exercise 5

"""
# ? ========== Qa =========

print("\n========== Qa =========\n")

def errorHandling():
    while True:
        try:
            num = float(input("Enter a number: "))
            break
        except ValueError:
            print("Invalid Input")

    print("Valid number:", num)

errorHandling()

# ? ========== Qb =========

print("\n========== Qb =========\n")

class Account:
    def __init__(self, account_number, balance=0):
        self.account_number = account_number
        self.balance = balance

    def deposit(self, amount):
        self.balance += amount

    def withdraw(self, amount):
        if amount <= self.balance:
            self.balance -= amount
        else:
            print("Insufficient funds")

    def get_balance(self):
        return self.balance


acc = Account("12345", 1000)
acc.deposit(500)
acc.withdraw(200)
print("Balance:", acc.get_balance())

# ? ========== Qc =========

print("\n========== Qc =========\n")

class SavingAccount(Account):
    def __init__(self, account_number, balance, interest_rate):
        super().__init__(account_number, balance)
        self.interest_rate = interest_rate

    def compute_interest(self):
        return self.balance * self.interest_rate


sav = SavingAccount("999", 2000, 0.05)
print("Interest:", sav.compute_interest())

# ? ========== Qd =========

print("\n========== Qd =========\n")

class CheckingAccount(Account):
    def __init__(self, account_number, balance, overdraft_limit):
        super().__init__(account_number, balance)
        self.overdraft_limit = overdraft_limit

    def withdraw(self, amount):
        if amount <= self.balance + self.overdraft_limit:
            self.balance -= amount
        else:
            print("Overdraft limit exceeded")


chk = CheckingAccount("777", 1000, 500)
chk.withdraw(1300)
print("Balance:", chk.get_balance())

# ? ========== Qe =========

print("\n========== Qe =========\n")

class Vehicle:
    def __init__(self, mark, model, year):
        self.mark = mark
        self.model = model
        self.year = year

    def start(self):
        print("Vehicle started")

    def stop(self):
        print("Vehicle stopped")

    def accelerate(self):
        print("Vehicle accelerating")


class Car(Vehicle):
    def __init__(self, mark, model, year, number_of_doors, roof):
        super().__init__(mark, model, year)
        self.number_of_doors = number_of_doors
        self.roof = roof

    def open_roof(self):
        if self.roof:
            print("Roof opened")
        else:
            print("No roof system")


car = Car("Toyota", "Corolla", 2022, 4, True)
car.start()
car.open_roof()

# ? ========== Qf =========

print("\n========== Qf =========\n")

class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def info(self):
        print(f"{self.name}, {self.age} years old")


class Patient(Person):
    def __init__(self, name, age, disease):
        super().__init__(name, age)
        self.disease = disease

    def diagnosis(self):
        print(f"Patient has {self.disease}")


p = Patient("Ali", 30, "Flu")
p.info()
p.diagnosis()