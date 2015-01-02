f = open('file.txt', 'w')

try:
    pass
    # do stuff with f
finally:
    f.close()


# OR

with open('file.txt', 'r') as f:
    pass
    # do stuff with f
