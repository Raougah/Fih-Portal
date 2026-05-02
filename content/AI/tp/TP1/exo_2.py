"""
Name: Mohammed Alaa Eddine Mekibes
Date: 12 / 02 / 2026
Code: Sheet Nr 1 (Part 1) Exercise 2

"""

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
