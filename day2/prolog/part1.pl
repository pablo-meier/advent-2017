:- use_module(library(apply)).
:- use_module(library(lists)).

main() :-
    open("../input.txt", read, Stream),
    read_file(Stream, Lines),
    close(Stream),
    solve(Lines, Answer1, Answer2),
    writef('Part 1 Checksum: %t \n', [Answer1]),
    writef('Part 2 Checksum: %t \n', [Answer2]).

read_file(Stream, X) :-
    read_string(Stream, _, L),
    split_on_lines(L, X).

split_on_lines(Str, Out):-
    split_string(Str, "\n", "\s\t\n", Out).

kill_tabs(Str, Out):-
    split_string(Str, "\s\t\n", "", Out).

is_empty("").
no_empties(In, Out):-
    exclude(is_empty, In, Out).
as_ints(In, Out):-
    maplist(number_codes, In, Out).

solve(Lines, Answer1, Answer2):-
    maplist(kill_tabs, Lines, Split),
    maplist(no_empties, Split, Filtered),
    maplist(as_ints, AsInts, Filtered),

    maplist(as_differences, AsInts, Differences),
    sum_list(Differences, Answer1),

    maplist(as_even_quotients, AsInts, Quotients),
    sum_list(Quotients, Answer2).

as_differences(Row, Difference):-
    min_member(Min, Row),
    max_member(Max, Row),
    Difference is Max - Min.

as_even_quotients(Row, Quotient):-
    pairs(Row, Pairs),
    maplist(even_quotient, Pairs, Quotients),
    sum(Quotients, Quotient).

% Oh shit, I have to write real code!
pairs([], []).
pairs([H|T], Accum):-
    applyAllTo(H, T, AllWithH),
    pairs(T, OtherPairs),
    append(AllWithH, OtherPairs, Accum).

applyAllTo(_, [], []).
applyAllTo(Root, [H|T], Accum):-
    applyAllTo(Root, T, NewAccum),
    Accum = [[Root, H]|NewAccum].

even_quotient([A,B], Quot):-
    (0 is A mod B,
    Quot is A / B);
    (0 is B mod A,
    Quot is B / A).
even_quotient(_, 0).

sum([], 0).
sum([H|T], Sum):-
    sum(T, Rest),
    Sum is H + Rest.
