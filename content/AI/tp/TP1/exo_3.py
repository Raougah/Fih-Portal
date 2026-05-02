"""
Name: Mohammed Alaa Eddine Mekibes
Date: 19 / 02 / 2026
Code: Sheet Nr 1 (Part 1) Exercise 3

"""

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
