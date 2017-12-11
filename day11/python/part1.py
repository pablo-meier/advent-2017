from collections import namedtuple
from enum import Enum
from functools import reduce

# God bless the kind person who wrote this:
#   https://www.redblobgames.com/grids/hexagons/


StepCounter = namedtuple('StepCounter', ['pos', 'max_distance_seen'])


class Step(Enum):
    NORTH = "n"
    NORTHEAST = "ne"
    NORTHWEST = "nw"
    SOUTH = "s"
    SOUTHEAST = "se"
    SOUTHWEST = "sw"


def apply_step(stepcounter, step):
    (x, y, z) = stepcounter.pos

    new_pos = None
    if step is Step.NORTH:
        new_pos = (x, y + 1, z - 1)
    elif step is Step.NORTHEAST:
        new_pos = (x + 1, y, z - 1)
    elif step is Step.NORTHWEST:
        new_pos = (x - 1, y + 1, z)
    elif step is Step.SOUTH:
        new_pos = (x, y - 1, z + 1)
    elif step is Step.SOUTHWEST:
        new_pos = (x - 1, y, z + 1)
    elif step is Step.SOUTHEAST:
        new_pos = (x + 1, y - 1, z)

    dist = distance(new_pos)
    max_dist = stepcounter.max_distance_seen
    if dist > max_dist:
        max_dist = dist

    return StepCounter(pos=new_pos, max_distance_seen=max_dist)


def distance(position):
    (x, y, z) = position
    return int((abs(x) + abs(y) + abs(z)) / 2)


with open('../input.txt') as f:
    steps = [Step(x) for x in f.readline().strip().split(',')]
    final = reduce(apply_step, steps, StepCounter(pos=(0, 0, 0), max_distance_seen=0))

    num_steps_required = distance(final.pos)
    print('Part 1: Number of steps required is {}'.format(num_steps_required))
    print('Part 2: Furthest distance traveled is {}'.format(final.max_distance_seen))
