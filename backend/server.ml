(* server.ml *)
let () =
  Dream.run (fun _ ->
    Smokers.run_smokers_simulation ();  (* Call the smoker simulation *)
    Dream.html "Avril Lavigne Rocks!!!")