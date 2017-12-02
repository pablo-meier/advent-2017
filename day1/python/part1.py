
def sum_of_matches(digits, offset):
    '''
    Finds the list of matching digits given +offset positions per the problem spec.
    '''
    running_sum = 0
    list_length = len(digits)
    for i in range(0, list_length):
        first_digit = digits[i]
        second_digit_offset = (i + offset) % list_length
        second_digit = digits[second_digit_offset]
        if first_digit == second_digit:
            running_sum += digits[i]
    return running_sum


with open('../input.txt') as f:
    line = f.readline()
    digits = [int(x) for x in list(line.rstrip())]

    result1 = sum_of_matches(digits, 1)
    print('Part 1: CAPTCHA IS ' + str(result1))

    offset = int(len(digits) / 2)
    result2 = sum_of_matches(digits, offset)
    print('Part 2: CAPTCHA IS ' + str(result2))
