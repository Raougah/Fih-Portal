import time
import array
def compDataStructure():
    size = 1_000_000

    # LIST
    start = time.time()
    lst = list(range(size))
    end = time.time()
    totalListTime = end - start
    print("List time:", totalListTime)

    # TUPLE
    start = time.time()
    tpl = tuple(range(size))
    end = time.time()
    totalTupleTime = end - start
    print("Tuple time:", totalTupleTime)

    # SET
    start = time.time()
    st = set(range(size))
    end = time.time()
    totalSetTime = end - start
    print("Set time:", totalSetTime)

    # DICT
    start = time.time()
    dct = {i: i for i in range(size)}
    end = time.time()
    totalDictTime = end - start
    print("Dict time:", totalDictTime)

    # ARRAY
    start = time.time()
    arr = array.array('i', range(size))
    end = time.time()
    totalArrayTime = end - start
    print("Array time:", totalArrayTime)

compDataStructure()