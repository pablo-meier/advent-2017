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
    shift_pos : shifter;
    value_map : int String.Map.t
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
             shift_pos = shift;
             value_map = map} update_fn =
    let (new_dir, new_shift) = determine_dir_and_shifter dir shift in
    let new_pos = from_direction pos dir in
    let (new_value, new_map) = update_fn value new_pos map in
    {
        curr_value = new_value;
        curr_direction = new_dir;
        curr_position = new_pos;
        shift_pos = new_shift;
        value_map = new_map
    }


let part1_win_condition state target =
    state.curr_value = target

let part1_win_action state =
    let x = state.curr_position.x in
    let y = state.curr_position.y in
    (abs x) + (abs y)

let update_part1 value _ map =
    (value + 1, map)


let part2_win_condition state target =
    state.curr_value > target

let part2_win_action state =
    state.curr_value

let pos_to_string {x = x; y = y} = Printf.sprintf "%d%d" x y

let value_at pos map =
    let str_key = pos_to_string pos in
    match Map.find map str_key with
    | None -> 0
    | Some x -> x

let adjacent_sum {x = x; y = y} map =
    let ul = { x = x - 1; y = y + 1} in
    let uc = { x = x    ; y = y + 1} in
    let ur = { x = x + 1; y = y + 1} in
    let cl = { x = x - 1; y = y    } in
    let cr = { x = x + 1; y = y    } in
    let dl = { x = x - 1; y = y - 1} in
    let dc = { x = x    ; y = y - 1} in
    let dr = { x = x + 1; y = y - 1} in
    List.map ~f:(fun x -> value_at x map) [ul;uc;ur;cl;cr;dl;dc;dr]
    |> List.fold_left ~init:0 ~f:(+)

let update_part2 _ pos map =
    let new_value = adjacent_sum pos map in
    (new_value, Map.add map ~key:(pos_to_string pos) ~data:new_value)


(* The meat *)
let rec solve state target win_condition win_action update_fn = 
    if win_condition state target then win_action state
    else solve (advance state update_fn) target win_condition win_action update_fn

let start_state = {
    curr_value = 1;
    curr_direction = Right;
    curr_position = {x = 0; y = 0};
    shift_pos = {curr = 0; max = 0; till_increment = 1};
    value_map = Map.add String.Map.empty ~key:(pos_to_string {x = 0; y = 0}) ~data:1
}

let target = 347991 

let part1 = solve start_state target part1_win_condition part1_win_action update_part1
let () = Printf.printf "Part 1 distance: %d \n" part1


(* *)
let part2 = solve start_state target part2_win_condition part2_win_action update_part2
let () = Printf.printf("Part 2, first larger number than target: %d \n") part2
