"""
Name: Mohammed Alaa Eddine Mekibes
Date: 19 / 02 / 2026
Code: Sheet Nr 1 (Part 1) Exercise 4

"""

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