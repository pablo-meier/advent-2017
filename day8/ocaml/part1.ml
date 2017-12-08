open Printf
open Core
open Re2.Std
open Re2.Infix

type bin_op = GT | LT | LTE | GTE | EQ | NEQ
type action = Inc | Dec

type command = {
    label : string;
    action : action;
    amount : int;
    left_operand : string;
    bin_op : bin_op;
    right_operand : int
}

type vm = {
    commands : command list;
    registers : int String.Map.t;
    max_seen : int option;
}

let string_regex : Re2.regex = Re2.create_exn "([a-z]+) (inc|dec) (-?\\d+) if ([a-z]+) ([<=>!]+) (-?\\d+)"
let command_spec_from_string str =
    let bin_op_from_str = function
        | ">" -> GT
        | ">=" -> GTE
        | "<" -> LT
        | "<=" -> LTE
        | "==" -> EQ
        | _ -> NEQ in
    let action_from_string = function
        | "inc" -> Inc
        | "dec" -> Dec
        | _ -> invalid_arg "bad action" in
    let matches = Re2.find_submatches_exn string_regex str in
    let label = matches.(1) |> Option.value_exn in
    let action = matches.(2) |> Option.value_exn |> action_from_string in
    let amount = matches.(3) |> Option.value_exn |> int_of_string in
    let left = matches.(4) |> Option.value_exn in
    let op = matches.(5) |> Option.value_exn |> bin_op_from_str in
    let right = matches.(6) |> Option.value_exn |> int_of_string in
    { label = label;
      action = action;
      amount = amount;
      left_operand = left;
      bin_op = op;
      right_operand = right;
    }

let execute {label; action; amount; left_operand; bin_op; right_operand} registers max_seen =
    let register_lookup x = match Map.find registers x with
        | None -> 0
        | Some x -> x in
    let condition_holds = 
        let l_value = register_lookup left_operand in
        match bin_op with
            | GT -> l_value > right_operand
            | LT -> l_value < right_operand
            | LTE -> l_value <= right_operand
            | GTE -> l_value >= right_operand
            | EQ -> l_value == right_operand
            | NEQ -> l_value != right_operand in
    let performed_action =
        let l_value = register_lookup label in
        let new_total = match action with
            | Inc -> l_value + amount
            | Dec -> l_value - amount in
        let updated_registers = Map.add registers ~key:label ~data:new_total in
        let updated_max_seen = match max_seen with
            | None -> Some new_total
            | Some x -> if new_total > x then Some new_total else Some x in
        (updated_registers, updated_max_seen) in
    if condition_holds then performed_action else (registers, max_seen)


let rec solve {commands; registers; max_seen} =
    let most_in = Map.fold ~init:0 ~f:(fun ~key:_ ~data:value accum -> if value > accum then value else accum) in
    match commands with
    | [] -> let highest = most_in registers in (highest, max_seen)
    | command::rest ->
            let (updated_registers, updated_max_seen)  = execute command registers max_seen in
            solve {commands = rest; registers = updated_registers; max_seen = updated_max_seen}


let input_state =
    let commands = In_channel.read_lines "../input.txt"
        |> List.map ~f:command_spec_from_string in
    {commands = commands; registers = String.Map.empty; max_seen = None}

let (part1, part2) = solve input_state
let () = Printf.printf "Part 1: %d is the largest register value after executing\n" part1
let () = Printf.printf "Part 2: %d is the largest register value to have been recorded\n" (Option.value_exn part2)

(*
let part2 = solve {position = 0; arr = (Array.of_list input_rows); num_steps = 0} part2_update
let () = Printf.printf "Part 2: There are %d valid password \n" part2
*)
