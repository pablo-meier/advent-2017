open Printf
open Core

type stepper = {
    position : int;
    arr : int array;
    num_steps : int
}

let rec solve {position; arr; num_steps} update_fn = 
    if position < 0 || position >= Array.length arr then num_steps
    else 
        let val_at = arr.(position) in
        let new_pos = val_at + position in
        let () = arr.(position) <- (update_fn val_at) in
        solve {position = new_pos; arr = arr; num_steps = (num_steps + 1)} update_fn


let input_rows =
    In_channel.read_lines "../input.txt"
        |> List.map ~f:Pervasives.int_of_string

let part1_update x = x + 1
let part2_update x = if x > 2 then x - 1 else x + 1

let part1 = solve {position = 0; arr = (Array.of_list input_rows); num_steps = 0} part1_update
let () = Printf.printf "Part 1: There are %d valid passwords\n" part1

let part2 = solve {position = 0; arr = (Array.of_list input_rows); num_steps = 0} part2_update
let () = Printf.printf "Part 2: There are %d valid password \n" part2
