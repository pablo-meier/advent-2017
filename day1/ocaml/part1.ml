open Printf
open Core


(* Best I've got for "PABLO" -> ["P";"A";"B";"L";"O"] *)
let explode str =
    let rec explode_recur i l =
        if i < 0 then l else explode_recur (i - 1) ((Char.to_string str.[i]) :: l) in
    explode_recur ((String.length str) - 1) []


let input_digits =
    In_channel.read_lines "../input.txt"
    |> List.hd
    |> Option.value_exn
    |> explode
    |> List.map ~f:int_of_string


let solve offset digits = 
    let len = List.length digits in
    let digit_val curr = 
        let first = Option.value_exn (List.nth digits curr) in
        let total_offset = (curr + offset) % len in
        let snd =  Option.value_exn (List.nth digits total_offset) in
        match first = snd with
        | true -> first
        | false -> 0 in
    let rec solve_rec curr sum =
        if curr = List.length digits then sum
        else solve_rec (curr + 1) (sum + (digit_val curr)) in
    solve_rec 0 0


let part1 = solve 1 input_digits
let () = Printf.printf("Part 1 CAPTCHA: %d \n") part1

let offset : int = (List.length input_digits) / 2
let part2 : int = solve offset input_digits
let () = Printf.printf("Part 2 CAPTCHA: %d \n") part2
