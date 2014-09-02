defmodule Presentir do
  alias Presentir.Presentation, as: Presentation
  alias Presentir.Slide, as: Slide
  alias Presentir.UnorderedList, as: UL

  def test do
    presentation = Presentation.new(
      "Functional Functional Programming", 
      "Bob Stockdale", 
      "A look into the awesomeness of functional programming",
      slides)
    # IO.puts Presentir.Render.as_text(presentation)
    # IO.puts Render.as_text(Presentation.slides(presentation))
    presentation
  end

  defp slides() do
    Enum.map(slide_order, &slide/1)
  end

  defp slide_order do
    [
      :goals,
      :intro,
      :why_functional_programming,
      :languages,
      :in_the_wild,
      :composition,
      :features_immutable,
      :features_first_class_fun,
      :features_higher_order_fun,
      :features_pure_functions,
      :features_lazy_eval,
      :features_recursion,
      :features_pattern_matching,
      :features_guards,
      :features_protocols,
      :features_automatic_currying,
      :types,
      :fp_conventions,
      :concurrency_models,
      :part_two_erlang,
      :beam_vm,
      :erlang_actor_model,
      :erlang_supervision,
      :erlang_fault_tolerance,
      :erlang_cluster,
      :erlang_scalable,
      :erlang_other,
      :moar_examples,
      :questions
    ]
  end

  defp slide(:goals) do
    Slide.new("Goals of this LnL", [
      UL.new([
        "Basic understanding of functional programming",
        "Insight into the benefits of functional programming",
        "Functional concepts that can be applied to non-functional software"
        ])
      ])
  end

  defp slide(:intro) do
    Slide.new("Intro to Functional Programming", [
      UL.new([
        "Style of building programs",
        "Based on lamda calculus",
        UL.new([
          "\"Provides a theoretical framework for describing functions and their evaluation\""
          ]),
        "Avoids state and mutable data",
        "Declarative - programming is done with expressions",
        "Eliminating side effects",
        UL.new([
          "changes in state that don't depend on function inputs"
          ]),
        "Functional programs are generally easier to understand and reason about"
        ])
      ])
  end

  defp slide(:why_functional_programming) do
    Slide.new("Why Functional Programming?", [
      UL.new([
        "Multi-core",
        "Highly concurrent systems",
        "(fault tolerant systems)"
        ])
      ])
  end

  defp slide(:languages) do
    Slide.new("Functional Languages", [
      UL.new([
        "Clojure",
        "Erlang",
        "Elixir",
        "Haskell",
        "LFE",
        "Lisp",
        "Scala (hybrid)",
        "OCaml",
        "..."
        ])
      ])
  end

  defp slide(:in_the_wild) do
    Slide.new("Functional Programming in the Wild", [ 
      UL.new([
        "Clojure",
        UL.new(["Akamai, Brand Karma, Citi"]),
        "Erlang",
        UL.new(["AdRoll, Amazon (SimpleDB), Facebook, Whatsapp, Ericcson, CouchDB, Riak, RabbitMQ, T-Mobile, Yahoo!"]),
        "Haskell",
        UL.new(["AT&T, Bank of America, Facebook, Google, Rackspace, Intel, NVIDIA"]),
        "Scala",
        UL.new(["Apple, eHarmony, Foursquare, LinkedIn, Quora, VMWare, Yammer, Twitter"]),
        ])
      ])
  end

  defp slide(:composition) do
    Slide.new("Functional Composition", [
      UL.new([
        "write many very small functions",
        UL.new([
          "easy to test",
          "easy to re-use",
          "languages encourage small functions by making it more difficult to write larger functions"
          ]),
        "compose them to build systems",
        ])
      ]) 
  end
  
  defp slide(:features_immutable) do
    Slide.new("Common Features: Immutable Data", [
      UL.new([
        "Data cannot be changed", 
        "Structure can be copied, replacing pieces in the copy",
        "More efficient than you'd think",
        UL.new([
          "List example:",
          UL.new([
            "foo = [1, 2, 3]",
            "[head|tail] = foo",
            "bar = [5|tail]"
            ])
          ]),
        UL.new([
          "Struct Example:",
          UL.new([
            "person1 = %Person{name: \"Joe\", last: \"Smith\"}",
            "person2 = %{person1 | name: \"John\"}",
            ])
          ])
        ])
      ]) 
  end

  defp slide(:features_first_class_fun) do
    Slide.new("Common Features: First Class Functions", [
        "Functions can be used anywhere in the program that other first-class entities can.",
        "print = fn (n) -> IO.puts n end"
      ]) 
  end

  defp slide(:features_higher_order_fun) do
    Slide.new("Common Features: Higher Order Functions", [
        UL.new([
          "Functions can operate on other functions",
          "Allow functions as arguments and results of other functions",
          UL.new([
            "print = fn (n) -> IO.puts n end",
            "Enum.each(list, print)",
            "def printer(n), do: fn -> IO.puts n end"
            ])
          ])
      ]) 
  end

  defp slide(:features_pure_functions) do
    Slide.new("Common Features: Pure Functions", [
      UL.new([
        "Functions with no memory or i/o side effects",
        "Same result every time it's called with the same arguments",
        "Compiler is free to do magic things on them, like re-order or combine them",
        "Super easy to write tests for"
        ])
      ]) 
  end

  defp slide(:features_lazy_eval) do
    Slide.new("Common Features: Lazy Evaluation", [
      UL.new([
          "Some functional languages support lazy evaluation of expressions",
          "Only evaluated when the result is needed",
          "Haskell is lazy by default",
          "Scala has a lazy keyword",
          UL.new([
            "lazy val foo = expensiveFunction()"
            ]),
          "Scala and Elixir have streams which are lazy (and potentially infinite)"
        ])
      ])
  end

  defp slide(:features_recursion) do
    Slide.new("Common Features: Recursion", [
      UL.new([
        "No for, while, etc.. loops",
        "Iteration is done with recursion",
        "Tail recursion prevents the call stack from growing during recursion",
        "Program can recurse forever",
        UL.new([
          "def loop(n), do: loop(n + 1)"
          ])
        ])
      ]) 
  end

  defp slide(:features_pattern_matching) do
    Slide.new("Common Features: Pattern Matching", [
      UL.new([
        "Match a variable against a pattern, executing the body that matches the pattern",
        "Example: ",
        UL.new([
          "def route({:foo, foo}), do: IO.puts \"Foo: \#{foo}\"",
          "def route({:bar, bar}), do: IO.puts \"Bar: \#{bar}\"",
          ]),
        "Unbound variables are bound as part of the match",
        "Bound variables are used as part of the match",
        "Common use is dispatching to the correct function based on paramters",
        "Pattern matching is highly optimized",
        "Example:",
        UL.new(["{min, max, avg} = stats"])
        ])
      ]) 
  end

  defp slide(:features_guards) do
    Slide.new("Common Features: Guards", [
      UL.new([
        "Available in Erlang, Elixir and Haskell",
        "Used to further restrict which function is called",
        "Example:",
        UL.new(["def double(n) when is_integer(n), do: 2 * n)"])
        ])
      ]) 
  end

  defp slide(:features_protocols) do
    Slide.new("Common Features: Polymorphism", [
      UL.new([
        "Clojure and Elixir have protocols",
        "Haskell has type classes and class instances",
        "Scala has case classes"
        ])
      ])
  end

  defp slide(:features_automatic_currying) do
    Slide.new("Less Common Feature: Automatic Currying", [
      UL.new([
        "Currying is when a function which returns another function is called, then the returned function is called",
        "Elixir example:",
        UL.new([
          "def sum(n), do: fun (m) -> n + m end)",
          "sum(2).(3)"
          ]),
        "Haskell has automatic currying",
        "Haskell example:",
        UL.new([
          "sum n m = n + m",
          "(sum 2 3)",
          "((sum 2) 3)"
          ])
        ])
      ]) 
  end

  defp slide(:types) do
    Slide.new("Type Systems", [
      UL.new([
        "Lispy languages (Clojure, LFE) are dynamically typed",
        "Erlang/Elixir are dynamically typed",
        UL.new([
          "Compile-time checking of fields in records and structs",
          "Pattern matching of records, structs, binaries at run time",
          "Guards can be used to check other types at run time",
          "Dialyzer can used to catch many type errors"
          ]),
        "Scala is statically typed, but uses type inference",
        "Haskell is statically typed and uses type inference"
        ])
      ]) 
  end

  defp slide(:fp_conventions) do
    Slide.new("FP Conventions", [
      UL.new([
        "Push state to the edge of the system",
        "Make most functions pure"
        ])
      ]) 
  end

  defp slide(:concurrency_models) do
    Slide.new("Concurrency", [
      UL.new([
        "Scala - threads, actors with Akka library",
        "Haskell - threads, actors, sparks, etc..",
        "Clojure - State Transactional Memory",
        "Elixir/Erlang - actor model"
        ])
      ]) 
  end

  defp slide(:part_two_erlang) do
    Slide.new("Part 2: Erlang Ecosystem", [])
  end

  defp slide(:beam_vm) do
    Slide.new("BEAM VM", [
      UL.new([
        "Bogdan/Björn's Erlang Abstract Machine",
        "Erlang, Elixir, LFE, Luerl, Erlog, ...",
        "One scheduler per core (by default, configurable)",
        "Process isolation",
        "Per-process garbage collection",
        "Erlang on Xen",
        UL.new([
          "Erlang close to the metal"
          ]),
        "Hitchhikers tour of the BEAM (Erlang Solutions)"
        ])
      ]) 
  end

  defp slide(:erlang_actor_model) do
    Slide.new("Erlang Actor Model", [
      UL.new([
        "Light-weight processes (<2k per process)",
        "Erlang processes are not OS processes or OS threads",
        "Processes are isolated",
        "No shared memory",
        "Communication by async message passing",
        "Not unusually to have hundreds of millions of processes",
        "OTP libraries provide some common patterns"
        ])
      ]) 
  end

  defp slide(:erlang_supervision) do
    Slide.new("Erlang Supervision", [
      UL.new([
        "Processes are composed into supervision hierarchies",
        "Supervisors notified when processes die",
        "Restart strategies"
        ])
      ])
  end

  defp slide(:erlang_fault_tolerance) do
    Slide.new("Erlang Fault Tolernace", [
      UL.new([
        "Supervision hierarchies can be as comprehensive as needed",
        "Let it crash",
        "Failures in one part of the system shouldn’t impact other parts of the system (unless that is the intention)"
        ])
      ])
  end

  defp slide(:erlang_cluster) do
    Slide.new("Erlang Clustering", [
      UL.new([
        "Erlang nodes can easily be joined to form clusters",
        "Seamless communication between processes across nodes in a cluster",
        "Supervision across nodes"
        ])
      ]) 
  end

  defp slide(:erlang_scalable) do
    Slide.new("Erlang is Super Scalable", [
      UL.new([
        "Cowboy developers tested 1 million active websocket connections on a single Amazon EC2",
        UL.new([
          "Takes about 20GB of memory",
          "~20KB per connection"
          ]),
        "Erlang systems should run N times faster on an N core processor"
        ])
      ]) 
  end

  defp slide(:erlang_other) do
    Slide.new("Other Erlang Awesomeness", [
      UL.new([
        "Hot code loading",
        "Erlang Applications",
        UL.new([
          "No keys... push to start",
          "Applications are built on top of other applications"
          ]),
        "Ericsson AXD301 switch has achieved 99.9999999% availability over 20 years (0.631 seconds downtime)"
        ])
      ]) 
  end

  defp slide(:moar_examples), do: Slide.new("Moar Examples")
  defp slide(:questions), do: Slide.new("Questions?")

  defp slide(_) do
    Slide.new("404", [
      "This is not the slide you're looking for"
      ])
  end

end
