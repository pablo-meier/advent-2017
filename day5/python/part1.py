
def add1(x):
    return x + 1


def sub1_unless_less_than_three(x):
    return x - 1 if x > 2 else x + 1


class HotStepper(object):
    '''
    Holy shit, an object! Kickin' it up a notch! While I was tempted not to make this
    a class in the spirit of Stop Making Classes ("two methods, one of them is init")
    the indexing of one field into another makes the syntax of doing this with a raw
    dictionary hairy (look at all those `self`s in there. Now imagine it with brackets
    and quotes...
    '''

    def __init__(self, array):
        self.position = 0
        self.array = list(array)
        self.num_steps = 0

    def run(self, update_fn):
        while self.position >= 0 and self.position < len(self.array):
            val = self.array[self.position]
            self.array[self.position] = update_fn(val)
            self.position += val
            self.num_steps += 1


with open('../input.txt') as f:
    array = [int(s) for s in f.readlines()]
    stepper = HotStepper(array)
    stepper.run(add1)
    print('Part 1: It takes {} steps to escape the array'.format(stepper.num_steps))

    second_stepper = HotStepper(array)
    second_stepper.run(sub1_unless_less_than_three)
    print('Part 2: It takes {} steps to escape the array'.format(second_stepper.num_steps))
