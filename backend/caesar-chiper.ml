(* Encrypt function to shift each letter by n positions *)
let encrypt str shift =
  String.map (fun c ->
    let base, offset =
      if 'A' <= c && c <= 'Z' then ('A', 65) (* ASCII code for 'A' *)
      else if 'a' <= c && c <= 'z' then ('a', 97) (* ASCII code for 'a' *)
      else (c, 0) (* non-alphabetic characters remain unchanged *)
    in
    if offset > 0 then
      Char.chr ((Char.code c - offset + shift) mod 26 + offset)
    else
      base
  ) str
;;

(* Test case for the Caesar cipher function *)
let test_encrypt () =
  (* Arrange *)
  let input = "hello" in
  let shift = 2 in
  let expected_output = "jgnnq" in

  (* Act *)
  let actual_output = encrypt input shift in

  (* Assert *)
  assert (String.equal expected_output actual_output);

  (* Output result *)
  Printf.printf "Test passed: '%s' encrypted with shift %d is '%s'\n"
    input shift actual_output
;;

(* Run the test case *)
test_encrypt ()