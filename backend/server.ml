(* server.ml *)
let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ -> Dream.html "<h1>Cigarette Smokers!</h1>");
    Dream.get "/api/simulation" (fun _ ->
      (* Trigger the smokers simulation *)
      Smokers.run_smokers_simulation ();

      (* Create a JSON response manually *)
      let response = `Assoc [("message", `String "Simulation started")] in
      let response_string = Yojson.Safe.to_string response in
      Dream.json response_string
    );
  ]