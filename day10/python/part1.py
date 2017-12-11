from collections import namedtuple
from functools import reduce


STANDARD_SUFFIX = [17, 31, 73, 47, 23]
STRING_SIZE = 256


HashState = namedtuple('HashState', ['lst', 'current_position', 'skip_size'])


def circular_reverse(lst, lst_length, cut_length, curr_pos):
    copy = list(lst)
    reverse_me = None
    unchecked_end = curr_pos + cut_length
    if unchecked_end >= lst_length:
        remainder = (unchecked_end % lst_length)
        reverse_me = copy[curr_pos:lst_length] + copy[0:remainder]
    else:
        reverse_me = copy[curr_pos:unchecked_end]
    reverse_me.reverse()
    for i in range(cut_length):
        copy[(curr_pos + i) % lst_length] = reverse_me[i]
    return copy


def advance_state(state, length):
    lst_length = len(state.lst)

    new_list = circular_reverse(state.lst, lst_length, length, state.current_position)
    new_pos = (state.current_position + length + state.skip_size) % lst_length
    new_skip_size = (state.skip_size + 1) % lst_length
    return HashState(lst=new_list, current_position=new_pos, skip_size=new_skip_size)


def init_hash():
    return HashState(lst=list(range(STRING_SIZE)), current_position=0, skip_size=0)


def perform_knot_hash_round(state, lengths):
    for l in lengths:
        state = advance_state(state, l)
    return state


def perform_entire_knot_hash(input_line):
    part2_input = [ord(c) for c in input_line] + STANDARD_SUFFIX
    part2_state = init_hash()
    for i in range(64):
        part2_state = perform_knot_hash_round(part2_state, part2_input)
    dense = dense_hash(part2_state)
    as_string = "".join(["%02x" % x for x in dense])
    return as_string


def dense_hash(state):
    i = 0
    dense = []
    while i <= 255:
        end_index = i + 16
        sublist = state.lst[i:end_index]
        xored = reduce(lambda i, j: i ^ j, sublist)
        dense.append(xored)
        i = end_index
    return dense


with open('../input.txt') as f:
    line = f.readline().strip()
    lengths = [int(x) for x in line.split(',')]
    init_state = init_hash()
    state = perform_knot_hash_round(init_state, lengths)

    product = state.lst[0] * state.lst[1]
    print('Part 1: Product of first two numbers is {}'.format(product))

    as_string = perform_entire_knot_hash(line)
    print('Part 2: The full knot hash is {}'.format(as_string))
