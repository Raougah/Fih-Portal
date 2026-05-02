# **Fiche**

[📄 View Fiche PDF](./lab1.pdf)

## **Solution**

### **Exo 1**

```python
# * Packages
import math

# ? ========== Q1 =========

print("\n========== Q1 =========\n")

a = 5
b = 10

print("Arithmetic operation with two integers:")
print("a + b = ", a + b)
print("a - b = ", a - b)
print("a * b = ", a * b)
print("a / b = ", a / b if b != 0 else "The division by 0 is impossible")

a = 5.36
b = 10.25

print("Arithmetic operation with two float numbers:")
print(f"a + b =  {a + b:.2f}")
print(f"a - b =  {a - b:.2f}")
print(f"a * b =  {a * b:.2f}")
print(f"a / b = {a / b:.2f}" if b != 0 else "The division by 0 is impossible")

# ? ========== Q2 =========

print("\n========== Q2 =========\n")

a = int(input("Enter the value of a: "))
b = int(input("Enter the value of b: "))

print("Arithmetic operation with two integers:")
print("a + b = ", a + b)
print("a - b = ", a - b)
print("a * b = ", a * b)
print("a / b = ", a / b if b != 0 else "The division by 0 is impossible")

a = float(input("Enter the value of a: "))
b = float(input("Enter the value of b: "))

print("Arithmetic operation with two float numbers:")
print(f"a + b =  {a + b:.2f}")
print(f"a - b =  {a - b:.2f}")
print(f"a * b =  {a * b:.2f}")
print(f"a / b = {a / b:.2f}" if b != 0 else "The division by 0 is impossible")


# ? ========== Q3 =========

print("\n========== Q3 =========\n")

r = float(input("Enter the value of radius: "))
print(f"The area of a circle = {math.pi * r ** 2:.2f}")
print(f"The circumference of a circle = {2 * math.pi * r:.2f}")

w = float(input("Enter the value of width: "))
l = float(input("Enter the value of length: "))
print(f"The area of a rectangle =  {w * l:.2f}")
print(f"The circumference of a rectangle = {(w + l) * 2:.2f}")

# ? ========== Q4 =========

print("\n========== Q4 =========\n")

c = float(input("Enter the value in celsius: "))
print(f"Celsius to Fahrenheit = {(c * 9 / 5) + 32:.2f}")

# ? ========== Q5 =========

print("\n========== Q5 =========\n")

a = int(input("Enter the value of a: "))
b = int(input("Enter the value of b: "))
c = int(input("Enter the value of c: "))

a += 1
print("increment a by 1:", a)

a += b
print("add a to b:", a)

c *= b
print("multiply b by c:", c)


# ? ========== Q6 =========

print("\n========== Q6 =========\n")

a = int(input("Enter a: "))
b = int(input("Enter b: "))
c = int(input("Enter c: "))

print("a is greater than b", a > b)
print("a is less than b", a < b)
print("a is equal to b", a == b)

print("b is greater than c", b > c)
print("b is less than c", b < c)
print("b is equal to c")

print("a equals b", a == b)
print("a does not equal b", a != b)
print("b is not equal to c", b != c)
print("b equals c", b == c)
```

### **Exo 2**

```python
# * Packages
import math

# ? ========== Q1 =========

print("\n========== Q1 =========\n")

a = int(input("Enter a: "))
b = int(input("Enter b: "))
c = int(input("Enter c: "))

if (a > b):
    print("a is greater than b")
elif (a < b):
    print("a is less than b")
else:
    print("a is equal to b")

if (b > c):
    print("b is greater than c")
elif (b < c):
    print("b is less than c")
else:
    print("b is equal to c")

# check if a == b
if (a == b):
    print("a equals b")
else:
    print("a does not equal b")

# check if b != c
if (b != c):
    print("b is not equal to c")
else:
    print("b equals c")

# ? ========== Q2 =========

print("\n========== Q2 =========\n")

r = float(input("Enter the value of radius: "))

if (r < 0):
    print("The radius should be positive")


print(f"The area of a circle = {math.pi * r ** 2:.2f}")
print(f"The circumference of a circle = {2 * math.pi * r:.2f}")

w = float(input("Enter the value of width: "))
l = float(input("Enter the value of length: "))

if (w < 0 or l < 0):
    print("The width and length should be positive")

print(f"The area of a rectangle =  {w * l:.2f}")
print(f"The circumference of a rectangle = {(w + l) * 2:.2f}")

# ? ========== Q3 =========

print("\n========== Q3 =========\n")

a = int(input("Enter a: "))
b = int(input("Enter b: "))
c = int(input("Enter c: "))

# EQ1 : ax + b = 0
print("\nEQ1 : ax + b = 0")

if (a != 0):
    x = -b / a
    print("Solution x =", x)
else:
    if (b == 0):
        print("Infinite solutions")
    else:
        print("No solution")


# EQ2 : ax² + bx + c = 0
print("\nEQ2 : ax² + bx + c = 0")

if (a == 0):
    # => bx + c = 0
    if (b != 0):
        x = -c / b
        print("One solution x =", x)
    else:
        if c == 0:
            print("Infinite solutions")
        else:
            print("No solution")

else:
    delta = b * b - 4 * a * c
    print("Delta = ", delta)

    if delta > 0:
        x1 = (-b + delta**0.5) / (2 * a)
        x2 = (-b - delta**0.5) / (2 * a)
        print("Two solutions:", x1, "and", x2)

    elif delta == 0:
        x = -b / (2 * a)
        print("One double solution:", x)

    else:
        print("No real solution")

# ? ========== Q4 =========

print("\n========== Q4 =========\n")

age = int(input("Enter age: "))

if (age < 18):
    print("The age is", age, "Minor")
elif (age < 60):
    print("The age is", age, "Adult")
else:
    print("The age is", age, "Senior")

# ? ========== Q5 =========

print("\n========== Q5 =========\n")

num = int(input("Enter a number: "))

if (num % 5 == 0 and num % 7 == 0):
    print("Multiple of 5 and 7")
else:
    print("Not a multiple of 5 and 7")


# ? ========== Q6 =========

print("\n========== Q6 =========\n")

n = int(input("Enter positive number: "))

# Using for loop
total = 0
for i in range(1, n + 1):
    total += i

print("Sum using for:", total)

# Using while loop
total = 0
i = 1

while (i <= n):
    total += i
    i += 1

print("Sum using while:", total)

# ? ========== Q7 =========

print("\n========== Q7 =========\n")

number = int(input("Enter number to test prime: "))

if (number <= 1):
    print("Not prime")
else:
    is_prime = True

    for i in range(2, number):
        if number % i == 0:
            is_prime = False
            break

    if is_prime:
        print("Prime number")
    else:
        print("Not prime")


# ? ========== Q8 =========

print("\n========== Q8 =========\n")

n = int(input("Enter how many numbers you want to read: "))

numbers = []
for i in range(n):
    num = float(input(f"Enter number {i+1}: "))
    numbers.append(num)

total = sum(numbers)

product = 1
for num in numbers:
    product *= num

average = total / n

print("Sum =", total)
print("Product =", product)
print("Average =", average)


# ? ========== Q9 =========

print("\n========== Q9 =========\n")

numbers = []

while (True):
    value = input("Enter a float (or 'q' to stop): ")

    if (value.lower() == 'q'):
        break

    numbers.append(float(value))

total = sum(numbers)

product = 1
for num in numbers:
    product *= num

average = total / len(numbers)

print("Sum =", total)
print("Product =", product)
print("Average =", average)
print("Min =", min(numbers))
print("Max =", max(numbers))


# ? ========== Q10 =========

print("\n========== Q10 =========\n")

# Factorial — Loop

n = int(input("Enter number for factorial: "))

fact = 1
for i in range(1, n + 1):
    fact *= i

print("Factorial (loop) =", fact)

# Factorial — Recursion

def factorial_recursive(n):
    """Recursive Function calculate factorial"""
    if (n == 0 or n == 1):
        return 1
    return n * factorial_recursive(n - 1)

print("Factorial (recursion) =", factorial_recursive(n))

# Fibonacci — Loop

n = int(input("Enter position for Fibonacci: "))

a, b = 0, 1

for _ in range(n):
    a, b = b, a + b

print("Fibonacci (loop) =", a)

# Fibonacci — Recursion

def fibonacci_recursive(n):
    """Recursive Function calculate fibonacci"""
    if (n <= 1):
        return n
    return fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2)

print("Fibonacci (recursion) =", fibonacci_recursive(n))
```

### **Exo 3**

```python
# * Packages
import math
import statistics
import sys

# ? ========== Q1 =========

print("\n========== Q1 =========\n")

def age_test(age):
    """Function test your age (minor, adult, senior)"""
    if age < 18:
        print("The age is", age, "Minor")
    elif age < 60:
        print("The age is", age, "Adult")
    else:
        print("The age is", age, "Senior")

age_test(10)
age_test(50)
age_test(100)

# ? ========== Q2 =========

print("\n========== Q2 =========\n")

# Fibonacci — def

def fibonacciCalc(n):
    """Function calculate fibonacci"""
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a


print("Fibonacci =", fibonacciCalc(10))

# Factorial — def

def factorial_calc(n):
    """Recursive Function calculate factorial"""
    fact = 1
    for i in range(1, n + 1):
        fact *= i

    return fact

print("Factorial (loop) =", factorial_calc(10))


# ? ========== Q3 =========

print("\n========== Q3 =========\n")

def manyNums_calc(n):
    numbers = []
    for i in range(n):
        num = float(input(f"Enter number {i+1}: "))
        numbers.append(num)

    total = sum(numbers)

    product = 1
    for num in numbers:
        product *= num

    average = total / n

    print("Sum =", total)
    print("Product =", product)
    print("Average =", average)

n = int(input("Enter how many numbers you want to read: "))
manyNums_calc(n)

# ? ========== Q4 =========

print("\n========== Q4 =========\n")

def read_float():
    numbers = []

    while True:
        value = input("Enter a float (or 'q' to stop): ")

        if (value.lower()) == 'q':
            break

        numbers.append(float(value))

    total = sum(numbers)

    product = 1
    for num in numbers:
        product *= num

    if(len(numbers) == 0):
        print("You don't have any number :(")
        sys.exit()

    average = total / len(numbers)

    print("Sum =", total)
    print("Product =", product)
    print("Average =", average)
    print("Min =", min(numbers))
    print("Max =", max(numbers))

read_float()

# ? ========== Q5 =========

print("\n========== Q5 =========\n")


def circle_calc(r):
    r = float(input("Enter the value of radius: "))
    print(f"The area of a circle = {math.pi * r ** 2:.2f}")
    print(f"The circumference of a circle = {2 * math.pi * r:.2f}")

circle_calc(5)
# ? ========== Q6 =========

print("\n========== Q6 =========\n")

def statistics_calc():
    nums = []
    n = int(input("How many numbers you want: "))

    for i in range(n):
        print(i + 1, ":")
        x = float(input("Give a float number "))
        nums.append(x)

    print(f"The mean = {statistics.mean(nums):.2f}")
    print(f"The variance = {statistics.variance(nums):.2f}")
    # print("The covariance = ", statistics.covariance(nums,))
    print("The min = ", min(nums))
    print("The max = ", max(nums))


statistics_calc()
```

### **Exo 4**

```python
# * Packages
import statistics
import random
import time
import array
import re
# ? ========== Q1 =========

print("\n========== Q1 =========\n")
def readRandom():
    nums = []

    for _ in range(20):
        nums.append(random.randint(0, 100))

    print("nums:", nums)
    print(f"The mean = {statistics.mean(nums):.2f}")
    print(f"The variance = {statistics.variance(nums):.2f}")
    print("The min = ", min(nums))
    print("The max = ", max(nums))

readRandom()

# ? ========== Q2 =========

print("\n========== Q2 =========\n")

def editArray():
    # String list
    fruits = ['apple', 'banana', 'cherry', 'date', 'fig']

    print("Length:", len(fruits))

    fruits.append('grape')
    fruits.remove('banana')
    fruits.sort()
    fruits.reverse()
    fruits.insert(1, 'orange')

    print(fruits)

    # Numbers list
    nums = [10, 20, 30, 40]

    print("Sum:", sum(nums))
    print("Max:", max(nums))
    print("Min:", min(nums))
    print("Count:", len(nums))

editArray()
# ? ========== Q3 =========

print("\n========== Q3 =========\n")

def dictEdit():
    my_dict = {1: 1, 2: 4, 3: 9, 4: 16, 5: 25}

    print("Length:", len(my_dict)) # Length

    my_dict[6] = 36      # add
    del my_dict[1]       # remove
    my_dict[1] = 0       # update

    print("Keys:", my_dict.keys())
    print("Values:", my_dict.values())

dictEdit()

# ? ========== Q4 =========

print("\n========== Q4 =========\n")

def listDict():
    students = [
        {"name": "Ali", "age": 20, "grade": 15},
        {"name": "Sara", "age": 22, "grade": 17},
        {"name": "Omar", "age": 19, "grade": 14}
    ]

    print("Length:", len(students))

    age_sum = sum(s["age"] for s in students)
    grade_sum = sum(s["grade"] for s in students)

    print("Sum of ages:", age_sum)
    print("Sum of grades:", grade_sum)

listDict()

# ? ========== Q5 =========

print("\n========== Q5 =========\n")

def coursesDict():
    courses = {
        'math': [85, 90, 78, 92],
        'science': [88, 91, 84, 89],
        'english': [76, 82, 79, 85]
    }

    print("Length:", len(courses))
    print("Keys:", courses.keys())
    print("Values:", courses.values())

    math_scores = courses['math']

    print("Math sum:", sum(math_scores))
    print("Math average:", sum(math_scores) / len(math_scores))
    print("Math max:", max(math_scores))
    print("Math min:", min(math_scores))

coursesDict()

# ? ========== Q6 =========

print("\n========== Q6 =========\n")

def setTupleList():
    # --- SET ---
    numbers = {1, 2, 3, 4, 5}

    print("Set:", numbers)
    print("Length:", len(numbers))
    print("Min:", min(numbers))
    print("Max:", max(numbers))

    numbers.add(6)
    numbers.remove(2)
    numbers.update({7, 8})
    numbers.discard(10)  # This is safe then remove (if the element is not found no error appears)

    print("Updated set:", numbers)

    # --- TUPLE ---
    t = (1, 2, 3, 4, 5)
    print("tuple:", t)
    print("Tuple length:", len(t))
    print("Tuple min:", min(t))
    print("Tuple max:", max(t))

    # Tuple is immutable So we can't add/remove

    # --- LIST ---
    l = [1, 2, 3, 4, 5]
    print("list", l)
    l.append(6)
    l.remove(2)

    print("List:", l)

    # Comparison:
    # List → ordered, mutable
    # Tuple → ordered, immutable
    # Set → unordered, unique values only

    """ Result

    List time: 0.024470806121826172 => faster
    Tuple time: 0.051145076751708984
    Set time: 0.05814957618713379
    Dict time: 0.09595656394958496
    Array time: 0.10058283805847168 

     """
    # List > Tuple > Set > Dict | Array

setTupleList()

# ? ========== Q7 =========

print("\n========== Q7 =========\n")

def compDataStructure():
    size = 1_000_000
    timeTotal = {}
    # LIST
    start = time.time()
    lst = list(range(size))
    end = time.time()
    timeTotal["list"] = end - start
    print("List time:", timeTotal["list"])

    # TUPLE
    start = time.time()
    tpl = tuple(range(size))
    end = time.time()
    timeTotal["tuple"] = end - start
    print("Tuple time:", timeTotal["tuple"])

    # SET
    start = time.time()
    st = set(range(size))
    end = time.time()
    timeTotal["set"] = end - start
    print("Set time:", timeTotal["set"])

    # DICT
    start = time.time()
    dct = {i: i for i in range(size)}
    end = time.time()
    timeTotal["dict"] = end - start
    print("Dict time:", timeTotal["dict"])

    # ARRAY
    start = time.time()
    arr = array.array('i', range(size))
    end = time.time()
    timeTotal["arr"] = end - start
    print("Array time:", timeTotal["arr"])


compDataStructure()

# ? ========== Q8 =========

print("\n========== Q8 =========\n")

def stringOperation():
    text = "Artificial intelligence, have 100 percent fun, in learning it"

    # Length
    print("Length:", len(text))

    # Upper / Lower
    print(text.upper())
    print(text.lower())

    # Replace
    print(text.replace("o", "0"))

    # Split by comma
    print(text.split(","))

    # Starts / Ends
    print("Starts with 'fun':", text.startswith("fun"))
    print("Ends with 'it':", text.endswith("it"))

    # Slicing
    print("First 10 chars:", text[:10])

    # Indexing
    print("Index of '100':", text.find("100"))

    # Concatenation
    new_text = text + "!!!"
    print(new_text)

stringOperation()

# ? ========== Q9 =========

print("\n========== Q9 =========\n")

def regularExpr():
    text = "Artificial intelligence, have 100 percent fun, in learning it"

    # Words
    words = re.findall(r"[A-Za-z]+", text)
    print("Words:", words)

    # Digits
    digits = re.findall(r"\d+", text)
    print("Digits:", digits)

    # Email, URL, Date test
    test_string = "Email: test@gmail.com, URL: https://example.com, Date: 10/02/2026"

    email = re.findall(r"\S+@\S+\.\S+", test_string) # \S : non whitespace characters
    url = re.findall(r"https?://\S+", test_string)
    date = re.findall(r"\d{2}/\d{2}/\d{4}", test_string) # \d : number

    print("Email:", email)
    print("URL:", url)
    print("Date:", date)

regularExpr()
```

### **Exo 5**

```python
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
```
