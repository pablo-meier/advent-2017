open Printf
open Core

type loop_length = Unsolved | Solved of int

type stepper = {
    value_map : int String.Map.t;
    arr : int array;
    num_turns : int;
    length_of_loop : loop_length
}

let initial_state arr =
    {
        value_map = String.Map.empty;
        arr = arr;
        num_turns = 0;
        length_of_loop = Unsolved
    }

let string_key arr =
    Array.map ~f:string_of_int arr
    |> String.concat_array ?sep:(Some "|")

let redistribute_beads arr =
    let rec step to_distribute index = 
        if to_distribute = 0 then ()
        else let new_index = (index + 1) % (Array.length arr) in
             let val_at = arr.(new_index) in
             let () = arr.(new_index) <- val_at + 1 in
             step (to_distribute - 1) new_index
    in
    let rec get_curr_max index (max, max_index) =
        if index = (Array.length arr) then (max, max_index)
        else let new_index = index + 1 in 
             let candidate = arr.(index) in
             if candidate > max then get_curr_max new_index (candidate, index)
             else get_curr_max new_index (max, max_index)
    in
    let (curr_max, curr_max_index) = get_curr_max 0 (-1,-1) in
    let () = arr.(curr_max_index) <- 0 in
    step curr_max curr_max_index

let rec solve {value_map; arr; num_turns; length_of_loop} = 
    let () = redistribute_beads arr in
    let new_turns = num_turns + 1 in
    let str_key = string_key arr in
    let new_map = (Map.add value_map ~key:str_key ~data:new_turns) in
    match (Map.find value_map str_key) with
    | Some x -> {
        value_map = new_map;
        arr = arr;
        num_turns = new_turns;
        length_of_loop = Solved (new_turns - x)
    } 
    | None -> solve {
        value_map = new_map;
        arr = arr;
        num_turns = new_turns;
        length_of_loop = Unsolved
    } 


let input_row =
    let line_processor line = 
        String.split_on_chars line ~on:['\t';'\n';' ']
        |> List.filter ~f:(fun x -> x <> "")
        |> List.map ~f:int_of_string
    in
    In_channel.read_lines "../input.txt"
        |> List.hd_exn
        |> line_processor

let length_to_string = function
    | Unsolved -> "unsolved"
    | Solved x -> string_of_int x

let solved = solve (initial_state (Array.of_list input_row))
let () = Printf.printf "Part 1: It requires %d steps\n" solved.num_turns
let () = Printf.printf "Part 2: The loop is %s steps long \n" (length_to_string solved.length_of_loop)
