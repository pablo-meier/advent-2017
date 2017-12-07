'''
I'm super ashamed of this code its awful.
'''
import re
from collections import defaultdict

DISC_PATTERN = re.compile('(\w+) \((\d+)\)(?: -> ([a-z, ]+))?')


class Disc(object):

    def __init__(self, string):
        match = DISC_PATTERN.match(string)

        self.label = match.group(1)
        self.weight = int(match.group(2))
        children = match.group(3)
        if children:
            self.children = children.split(', ')
        else:
            self.children = []

        self.all_weight = None

    def resolve_children(self, registry):
        mapped = [registry[child] for child in self.children]
        self.children = mapped

    def total_weight(self):
        if not self.all_weight:
            totes = 0
            for child in self.children:
                totes += child.total_weight()
            totes += self.weight
            self.all_weight = totes
        return self.all_weight

    def __str__(self):
        return self.label + " (" + str(self.total_weight()) + ")"

    def find_anomaly(self):
        by_weight = defaultdict(list)
        for child in self.children:
            by_weight[child.total_weight()].append(child)

        if len(by_weight.keys()) > 1:
            deviant = None
            non_deviant = None
            for k, v in by_weight.items():
                if len(v) == 1:
                    deviant = v[0]
                else:
                    non_deviant = v[0]
            value = deviant.find_anomaly()
            if value == -1:
                difference = non_deviant.total_weight() - deviant.total_weight()
                good_weight = deviant.weight + difference
                return good_weight
            else:
                return value
        else:
            return -1


with open('../input.txt') as f:
    discs = [Disc(s) for s in f.readlines()]
    registry = {}
    for disc in discs:
        registry[disc.label] = disc

    for disc in discs:
        disc.resolve_children(registry)

    seen = set()
    for disc in discs:
        for child in disc.children:
            seen.add(child.label)

    root = None
    for disc in discs:
        if disc.label not in seen:
            root = disc
            break
    print('Part 1: The root node is {}'.format(root.label))

    root.total_weight()
    deviant_weight = root.find_anomaly()
    print('Part 2: The deviant would have to weight {}'.format(deviant_weight))
