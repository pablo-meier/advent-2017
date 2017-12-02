
main() :-
    open("../input.txt", read, Str),
    read_file(Str, Lines),
    close(Str),
    solve(Lines, Answer1, Answer2),
    writef('PART 1 CAPTCHA: %t \n', [Answer1]),
    writef('PART 2 CAPTCHA: %t \n', [Answer2]).

read_file(Stream, X) :-
    read_string(Stream, _, L),
    split_string(L, "\n", "\s\t\n", X).

solve([Line|[]], Answer1, Answer2):-
    integer_list_from_line(Line, IntegerList),
    length(IntegerList, Length),
    calculate_offset(part1, Length, Part1Offset),
    calculate_offset(part2, Length, Part2Offset),
    running_sum(0, Part1Offset, Length, IntegerList, Answer1),
    running_sum(0, Part2Offset, Length, IntegerList, Answer2).

integer_list_from_line(Line, IntegerList):-
    string_chars(Line, Codes),
    maplist(atom_number, Codes, IntegerList).

calculate_offset(part1, _, 1).
calculate_offset(part2, Length, Offset):-
    Offset is (Length / 2).

running_sum(X, _, X, _, 0).
running_sum(Index, Offset, Length, List, Sum):-
    nth0(Index, List, FirstCompare),
    TotalOffset is (Index + Offset) mod Length,
    nth0(TotalOffset, List, FirstCompare),

    NewIndex is Index + 1,
    running_sum(NewIndex, Offset, Length, List, Rest),
    Sum is Rest + FirstCompare.

running_sum(Index, Offset, Length, List, Sum):-
    NewIndex is Index + 1,
    running_sum(NewIndex, Offset, Length, List, Sum).
