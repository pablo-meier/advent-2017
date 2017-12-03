open Printf
open Core

let input_rows =
    let line_processor line = 
        String.split_on_chars line ~on:['\t';'\n';' ']
        |> List.filter ~f:(fun x -> x <> "")
        |> List.map ~f:int_of_string in
    In_channel.read_lines "../input.txt"
        |> List.map ~f:line_processor

let sum_list = List.fold_left ~f:(+) ~init:0

let solve reduce_fn = 
    List.map ~f:reduce_fn input_rows
    |> sum_list

let part1_reduce row =
    let most_er = fun fn -> function
        [] -> invalid_arg "Empty List"
        | x::xs -> List.fold_left ~f:fn ~init:x xs in
    let min_value = (most_er min) row in
    let max_value = (most_er max) row in
    max_value - min_value

let part2_reduce row = 
    let rec pairs lst =
        let allWith root = List.map ~f:(fun (x) -> (root, x)) in
        match lst with
        | [] -> []
        | y::ys -> List.concat [(allWith y ys);(pairs ys)] in
    let divides_evenly pair =
        let (x,y) = pair in
        match ((x mod y, y mod x)) with
        | (0, _) -> x / y
        | (_, 0) -> y / x
        | (_, _) -> 0 in
    pairs row
        |> List.map ~f:divides_evenly
        |> sum_list


let part1 = solve part1_reduce
let () = Printf.printf("Part 1 Checksum: %d \n") part1

let part2 : int = solve part2_reduce
let () = Printf.printf("Part 2 Checksum: %d \n") part2
