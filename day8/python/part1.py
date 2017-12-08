from collections import namedtuple, defaultdict
from enum import Enum, auto
import re

COMMAND_PATTERN = re.compile('([a-z]+) (inc|dec) (-?\d+) if ([a-z]+) ([<=>!]+) (-?\d+)')
MAX_KEY = 'MAX'


class BinOp(Enum):
    GREATER_THAN = auto()
    GREATER_THAN_EQUALS = auto()
    LESS_THAN = auto()
    LESS_THAN_EQUALS = auto()
    EQUALS = auto()
    NOT_EQUALS = auto()


class Action(Enum):
    INC = auto()
    DEC = ()


Command = namedtuple('Command', ['label', 'action', 'amount', 'binop', 'left_operand', 'right_operand'])


class MaxHolder(object):
    def __init__(self):
        self.max = None

    def consider(self, val):
        if self.max is None or val > self.max:
            self.max = val


def string_to_action(s):
    if s == "inc":
        return Action.INC
    else:
        return Action.DEC


def string_to_binop(s):
    if s == ">":
        return BinOp.GREATER_THAN
    elif s == ">=":
        return BinOp.GREATER_THAN_EQUALS
    elif s == "<":
        return BinOp.LESS_THAN
    elif s == "<=":
        return BinOp.LESS_THAN_EQUALS
    elif s == "==":
        return BinOp.EQUALS
    elif s == "!=":
        return BinOp.NOT_EQUALS


def parse_command(s):
    match = COMMAND_PATTERN.match(s)

    return Command(label=match.group(1),
                   action=string_to_action(match.group(2)),
                   amount=int(match.group(3)),
                   left_operand=match.group(4),
                   binop=string_to_binop(match.group(5)),
                   right_operand=int(match.group(6)))


def apply_command(command, registers, max_holder):
    if applied_condition(command, registers):
        apply_action(command, registers, max_holder)


def applied_condition(command, registers):
    left = registers[command.left_operand]
    c = command.binop
    if c is BinOp.GREATER_THAN:
        return left > command.right_operand
    elif c is BinOp.GREATER_THAN_EQUALS:
        return left >= command.right_operand
    elif c is BinOp.LESS_THAN:
        return left < command.right_operand
    elif c is BinOp.LESS_THAN_EQUALS:
        return left <= command.right_operand
    elif c is BinOp.EQUALS:
        return left == command.right_operand
    elif c is BinOp.NOT_EQUALS:
        return left != command.right_operand


def apply_action(command, registers, max_holder):
    if command.action is Action.INC:
        registers[command.label] += command.amount
    elif command.action is Action.DEC:
        registers[command.label] -= command.amount
    max_holder.consider(registers[command.label])


with open('../input.txt') as f:
    commands = [parse_command(s) for s in f.readlines()]
    registers = defaultdict(int)
    max_holder = MaxHolder()

    for command in commands:
        apply_command(command, registers, max_holder)

    print('Part 1: Largest register value is {}'.format(max(registers.values())))
    print('Part 2: Largest register value ever is {}'.format(max_holder.max))
