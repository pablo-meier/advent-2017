

def board_to_string(arr):
    as_str = [str(x) for x in arr]
    return '|'.join(as_str)


def init_state(arr):
    '''
    The state we carry: a set keyed on a string of reps we've seen before,
    the array, and a count of how many "advances" we've done.
    '''
    visited_states = {}
    visited_states[board_to_string(arr)] = 0
    return {
            'num_turns': 0,
            'array': arr,
            'boards': visited_states,
            'length_of_loop': None
    }


def redistribute_beads(array):
    '''
    Redistributes the Mancala beads
    '''
    curr_max = None
    bucket_index = None
    for x in range(0, len(array)):
        if curr_max is None or array[x] > curr_max:
            curr_max = array[x]
            bucket_index = x

    to_distribute = array[bucket_index]
    array[bucket_index] = 0
    while to_distribute > 0:
        bucket_index = (bucket_index + 1) % len(array)
        array[bucket_index] += 1
        to_distribute -= 1


def advance_state(state):
    '''
    Performs a "mancala" advance.
    '''
    redistribute_beads(state['array'])
    state['num_turns'] += 1
    as_string = board_to_string(state['array'])
    if as_string in state['boards']:
        state['length_of_loop'] = state['num_turns'] - state['boards'][as_string]
        return True
    else:
        state['boards'][as_string] = state['num_turns']
        return False


with open('../input.txt') as f:
    array = [int(s) for s in f.readline().split()]
    stepper = init_state(array)

    while True:
        completed = advance_state(stepper)
        if completed:
            break

    print('Part 1: It takes {} steps see the same as before'.format(stepper['num_turns']))
    print('Part 2: The two are {} steps apart'.format(stepper['length_of_loop']))
