(* server.ml *)
let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html "<h1>Cigarette Smokers!</h1>");
    Dream.get "/run-smokers" (fun _ ->
      (* Trigger the smokers simulation *)
      Smokers.run_smokers_simulation ();
      Dream.html "Smokers simulation is running!"
    );
  ]