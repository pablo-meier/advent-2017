import itertools


def parse_row(string):
    '''
    Given a string with whitespace and numbers interspersed, return
    the list as Python numbers.
    '''
    return [int(x) for x in string.split()]


def reduce_row(row):
    '''
    Given a row of numbers, keep track of the min/max of them.
    '''
    return (max(row), min(row))


def reduce_part_two(row):
    '''
    Find the two numbers which divide cleanly, then put the bigger one in
    '''
    for x,y in itertools.combinations(row, 2):
        if x % y == 0:
            return (x, y)
        if y % x == 0:
            return (y, x)


with open('../input.txt') as f:
    lines = f.readlines()
    rows = [parse_row(x.rstrip()) for x in lines]

    minmax_pairs = [reduce_row(row) for row in rows]
    differences = [x[0] - x[1] for x in minmax_pairs]
    result1 = sum(differences)
    print('Part 1: Checksum is ' + str(result1))

    divisible_pairs = [reduce_part_two(row) for row in rows]
    quotients = [x[0] / x[1] for x in divisible_pairs]
    result2 = int(sum(quotients))
    print('Part 2: Checksum is ' + str(result2))


# YO PYTHON IS STUPID EVERYTHING WAS ALREADY DONE FOR ME
# I... ENJOYED THIS?!?!?
