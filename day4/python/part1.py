
def reduce_row(row, part2=False):
    '''
    Given a row of passwords, returns 1 if it's valid or 0 if not
    '''
    seen = set()
    for password in row:
        if part2:
            password = ''.join(sorted(password))
        if password in seen:
            return 0
        else:
            seen.add(password)
    return 1

with open('../input.txt') as f:
    lines = f.readlines()
    rows = [string.split() for string in lines]
    as_valid = [reduce_row(row, False) for row in rows]
    result1 = sum(as_valid)
    print('Part 1: There are {} valid passwords'.format(result1))

    as_valid = [reduce_row(row, True) for row in rows]
    result2 = sum(as_valid)
    print('Part 2: There are {} valid passwords'.format(result2))
