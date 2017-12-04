open Printf
open Core

let input_rows =
    In_channel.read_lines "../input.txt"
        |> List.map ~f:(String.split ~on:' ')

let sum_list = List.fold_left ~f:(+) ~init:0

let solve reduce_fn = 
    List.map ~f:reduce_fn input_rows
    |> sum_list

(* Core.Std and internal default List modules can't agree and the type system's not making
 * any goddamned sense when I try to use `List.mem`, complaining it's missing `equal` but it's
 * not showing up in the Core docs either. Boo-urns. *)
let member_ugh elem lst =
    (List.length (List.filter ~f:(fun x -> x = elem) lst)) > 0

let sorted_str str =
    String.to_list str
    |> List.sort ~cmp:Pervasives.compare
    |> String.of_char_list

let reducer part1 =
    fun row ->
        let rec checker elem lst accum =
            let new_elem = if part1 then elem else sorted_str elem in
            if member_ugh new_elem accum then 0
            else match lst with
                | [] -> 1
                | x::xs -> checker x xs (new_elem::accum) in
        match row with
        | [] -> invalid_arg "Empty List"
        | x::xs -> checker x xs []

let part1 = solve (reducer true)
let () = Printf.printf("Part 1: There are %d valid passwords\n") part1

let part2 = solve (reducer false)
let () = Printf.printf("Part 2: There are %d valid password \n") part2
