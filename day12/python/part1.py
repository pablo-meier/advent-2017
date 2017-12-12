import functools
import re
import queue

GRAPH_PATTERN = re.compile('^(\d+) <-> ([0-9, ]+)')


def feed_to_dict(dictionary, string):
    match = GRAPH_PATTERN.match(string)
    node_id = int(match.group(1))
    children = [int(x.strip()) for x in match.group(2).split(',')]
    dictionary[node_id] = children
    return dictionary


def get_cluster(seed, registry):
    seen = set()
    remaining = queue.Queue()
    remaining.put(seed)

    while not remaining.empty():
        elem = remaining.get()
        seen.add(elem)
        for child in registry[elem]:
            if child not in seen:
                remaining.put(child)
    return seen


with open('../input.txt') as f:
    registry = functools.reduce(feed_to_dict, f.readlines(), {})
    zero_cluster = get_cluster(0, registry)
    print('Part 1: Number of items in the 0 cluster is {}'.format(len(zero_cluster)))

    set_of_all = set(registry.keys())
    keep_workin = set_of_all - zero_cluster
    num_clusters = 1

    while len(keep_workin) > 0:
        new_cluster = get_cluster(keep_workin.pop(), registry)
        num_clusters += 1
        keep_workin -= new_cluster

    print('Part 2: Number of clusters is {}'.format(num_clusters))
