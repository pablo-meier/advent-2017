open Printf
open Core

(* Travel directions *)
type direction = | Left | Right | Up | Down

(* Curr position on the board *)
type position = {
    x : int;
    y : int
}

(* State tracking for when to change direction. I observe that you increment how many
 * squares to travel every two steps. *)
type shifter = {
    curr : int;
    max : int;
    till_increment : int
}

(* Record holding all of our state *)
type spiral_tracker = {
    curr_value : int;
    curr_direction : direction;
    curr_position : position;
    shift_pos : shifter
}

let from_direction {x = x_val; y = y_val} = function
    | Right -> {x = x_val + 1; y = y_val}
    | Up -> {x = x_val; y = y_val + 1}
    | Left -> {x = x_val - 1; y = y_val}
    | Down -> {x = x_val; y = y_val - 1}

let turn = function
    | Right -> Up
    | Up -> Left
    | Left -> Down
    | Down -> Right

let determine_dir_and_shifter dir {curr = curr; max = max; till_increment = till_increment} =
    let new_dir = turn dir in
    match (curr, max, till_increment) with
    | (0, _, 0) ->
        let new_max = max + 1 in
        (new_dir, {curr = new_max; max = new_max; till_increment = 1})
    | (0, _, _) -> (new_dir, {curr = max; max = max; till_increment = till_increment - 1})
    | (_, _, _) -> (dir, {curr = curr - 1; max = max; till_increment = till_increment})

let dir_string = function
    | Up -> "up"
    | Down -> "down"
    | Left -> "left"
    | Right -> "right"

let advance {curr_value = value;
             curr_direction = dir;
             curr_position = pos;
             shift_pos = shift} =
    let (new_dir, new_shift) = determine_dir_and_shifter dir shift in
    let new_pos = from_direction pos dir in
    {
        curr_value = value + 1;
        curr_direction = new_dir;
        curr_position = new_pos;
        shift_pos = new_shift
    }

let manhattan_distance tracker =
    let x = tracker.curr_position.x in
    let y = tracker.curr_position.y in
    (abs x) + (abs y)

(* The meat *)
let rec solve state target = 
    if state.curr_value = target then manhattan_distance state
    else solve (advance state) target

let start_state = {
    curr_value = 1;
    curr_direction = Right;
    curr_position = {x = 0; y = 0};
    shift_pos = {curr = 0; max = 0; till_increment = 1}
}
let part1 = solve start_state 347991
let () = Printf.printf "Part 1 distance: %d \n" part1

(*
let part2 = solve
let () = Printf.printf("Part 2 distance: %d \n") part2
*)
