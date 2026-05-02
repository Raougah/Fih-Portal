"""
Name: Mohammed Alaa Eddine Mekibes
Date: 12 / 02 / 2026
Code: Sheet Nr 1 (Part 1) Exercise 1

"""

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
