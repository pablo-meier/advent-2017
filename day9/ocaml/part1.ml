open Printf
open Core

type process_state = {
    total_score: int;
    group_score : int;
    garbage_character_sum : int;
    ignore_char : bool;
    in_garbage : bool
}

let process_char state curr_char =
    let {total_score; group_score; garbage_character_sum; ignore_char; in_garbage} = state in
    if ignore_char then {state with ignore_char=false}
    else match (curr_char, in_garbage) with
    | ('!', _) -> {state with ignore_char=true}
    | ('{', false) -> {state with group_score=(group_score + 1)}
    | ('}', false) -> {state with total_score=total_score + group_score; group_score=(group_score - 1)}
    | ('>', true) -> {state with in_garbage=false}
    | ('<', false) -> {state with in_garbage=true}
    | (_, true) -> {state with garbage_character_sum=(garbage_character_sum + 1)}
    | (_, false) -> state


let solve stream = 
    let init_state = {total_score=0; group_score=0; garbage_character_sum=0; ignore_char=false; in_garbage=false} in
    let processed = List.fold_left ~init:init_state ~f:process_char stream in
    (processed.total_score, processed.garbage_character_sum)

let explode str =
    let rec explode_recur i l =
        if i < 0 then l else explode_recur (i - 1) (str.[i] :: l) in
    explode_recur ((String.length str) - 1) []

let stream =
    In_channel.read_lines "../input.txt"
    |> List.hd
    |> Option.value_exn
    |> explode

let (part1, part2) = solve stream
let () = Printf.printf("Part 1: Group score is %d\n") part1
let () = Printf.printf("Part 2: Number of garbage characters are %d\n") part2
