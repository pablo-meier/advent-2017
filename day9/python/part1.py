# from collections import namedtuple
# from enum import Enum, auto


GROUP_START = '{'
GROUP_END = '}'
GARBAGE_START = '<'
GARBAGE_END = '>'

CANCEL = '!'


def process_stream(string):
    running_sum = 0
    curr_group_score = 0
    garbage_character_sum = 0
    ignore_char = False
    in_garbage = False
    for c in string:
        if ignore_char:
            ignore_char = False
        elif c is CANCEL:
            ignore_char = True
        elif c is GROUP_START and not in_garbage:
            curr_group_score += 1
        elif c is GROUP_END and not in_garbage:
            running_sum += curr_group_score
            curr_group_score -= 1
        elif c is GARBAGE_END and in_garbage:
            in_garbage = False
        elif c is GARBAGE_START and not in_garbage:
            in_garbage = True
        elif in_garbage:
            garbage_character_sum += 1
    return (running_sum, garbage_character_sum)


# def test_score(case, expected):
#     (result, _) = process_stream(case)
#     print('{} should be {}: {}'.format(case, expected, result))
#
#
# def test_gc(case, expected):
#     (_, result) = process_stream(case)
#     print('{} should be {}: {}'.format(case, expected, result))
#
#
# test_score('{}', 1)
# test_score('{{{}}}', 6)
# test_score('{{},{}}', 5)
# test_score('{{{},{},{{}}}}', 16)
# test_score('{<a>,<a>,<a>,<a>}', 1)
# test_score('{{<ab>},{<ab>},{<ab>},{<ab>}}', 9)
# test_score('{{<!!>},{<!!>},{<!!>},{<!!>}}', 9)
# test_score('{{<a!>},{<a!>},{<a!>},{<ab>}}', 3)
#
#
# test_gc('<>', 0)
# test_gc('<random characters>', 17)
# test_gc('<<<<>', 3)
# test_gc('<{!>}>', 2)
# test_gc('<!!>', 0)
# test_gc('<!!!>>', 0)
# test_gc('<{o"i!a,<{i<a>', 10)

with open('../input.txt') as f:
    (group_score, garbage_characters) = process_stream(f.readline().strip())
    print('Part 1: Sum of all group is {}'.format(group_score))
    print('Part 2: Number of garbage_characters {}'.format(garbage_characters))
