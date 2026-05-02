# file = open("test.txt")
# print(file)
# print(file.read())

file = open("test2.txt", "w")
file.write("Hi" * 4)
file.write("Hi\n" * 4)

file = open("test2.txt", "r")
print(file.read())

file = open("test2.txt", "a")
file.write("Alaa")

file = open("test2.txt", "r")
print(file.read())