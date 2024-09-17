(* Semaphore implementation for synchronization *)
module Semaphore = struct
  type t = {
    mutable value: int;
    condition: Condition.t;
    lock: Mutex.t;
  }

  let create n = { value = n; condition = Condition.create (); lock = Mutex.create () }

  let p sem = (* Wait operation *)
    Mutex.lock sem.lock;
    while sem.value <= 0 do
      Condition.wait sem.condition sem.lock
    done;
    sem.value <- sem.value - 1;
    Mutex.unlock sem.lock

  let v sem = (* Signal operation *)
    Mutex.lock sem.lock;
    sem.value <- sem.value + 1;
    Condition.signal sem.condition;
    Mutex.unlock sem.lock
end

(* Define the semaphores for each smoker and the agent *)
let lock = Semaphore.create 1
let smoker_tobacco = Semaphore.create 0
let smoker_paper = Semaphore.create 0
let smoker_match = Semaphore.create 0
let agent = Semaphore.create 1

(* Agent process *)
let agent_process () =
  let rec loop count =
    if count > 0 then (
      Semaphore.p lock;
      let rand_num = Random.int 3 in
      (* Pick a random pair of ingredients and notify the correct smoker *)
      if rand_num = 0 then (
        print_endline "Agent puts tobacco and paper on the table.";
        Semaphore.v smoker_match  (* Wake up smoker with matches *)
      )
      else if rand_num = 1 then (
        print_endline "Agent puts tobacco and matches on the table.";
        Semaphore.v smoker_paper  (* Wake up smoker with paper *)
      )
      else (
        print_endline "Agent puts paper and matches on the table.";
        Semaphore.v smoker_tobacco  (* Wake up smoker with tobacco *)
      );
      Semaphore.v lock;
      Semaphore.p agent; (* Agent sleeps until smoker wakes it up *)
      Unix.sleepf 1.0; (* Delay of 1 second *)
      loop (count - 1)  (* Decrement count and continue loop *)
    )
    else (
      print_endline "That's all I have for now, deal with it.";
      ()
    )
  in
  loop 8  (* Start with 8 iterations *)

(* Smoker process: takes missing ingredient and smokes *)
let smoker_with_tobacco () =
  let rec loop () =
    Semaphore.p smoker_tobacco;  (* Wait for agent to place paper and match *)
    Semaphore.p lock;
    print_endline "Smoker with tobacco picks up paper and matches.";
    Semaphore.v agent;  (* Wake the agent *)
    Semaphore.v lock;
    print_endline "Smoker with tobacco smokes.";
    loop ()
  in
  loop ()

let smoker_with_paper () =
  let rec loop () =
    Semaphore.p smoker_paper;  (* Wait for agent to place tobacco and match *)
    Semaphore.p lock;
    print_endline "Smoker with paper picks up tobacco and matches.";
    Semaphore.v agent;  (* Wake the agent *)
    Semaphore.v lock;
    print_endline "Smoker with paper smokes.";
    loop ()
  in
  loop ()

let smoker_with_match () =
  let rec loop () =
    Semaphore.p smoker_match;  (* Wait for agent to place tobacco and paper *)
    Semaphore.p lock;
    print_endline "Smoker with match picks up tobacco and paper.";
    Semaphore.v agent;  (* Wake the agent *)
    Semaphore.v lock;
    print_endline "Smoker with match smokes.";
    loop ()
  in
  loop ()

(* Function to run the smoker simulation *)
let run_smokers_simulation () =
  Random.self_init ();
  (* Create threads for agent and smokers *)
  let agent_thread = Thread.create agent_process () in
  let smoker_tobacco_thread = Thread.create smoker_with_tobacco () in
  let smoker_paper_thread = Thread.create smoker_with_paper () in
  let smoker_match_thread = Thread.create smoker_with_match () in
  (* Join all threads to keep the simulation running *)
  Thread.join agent_thread;
  Thread.join smoker_tobacco_thread;
  Thread.join smoker_paper_thread;
  Thread.join smoker_match_thread

