module ClozeTest.Test exposing (Test, create, generateTests)

import Random

import ClozeTest.Sentence exposing (Sentence)
import ClozeTest.Sentence as Sentence


-- XXX: Do type checking on numCloze=1. How?
type alias Test = Sentence

create : Sentence -> Int -> Test
create sentence clozeIdx =
  let 
    f part (clozeIdx, test) =
      case (clozeIdx, part.cloze) of
        (0, True) ->
          (clozeIdx - 1, part :: test)
        (_, True) ->
          (clozeIdx - 1, { part | cloze = False} :: test)
        (_, False) ->
          (clozeIdx, part :: test)
  in
    List.foldr f (clozeIdx, []) sentence |> snd


generateTests : Sentence -> Random.Generator Test
generateTests sentence =
  let
    numClozes = sentence |> List.filter .cloze |> List.length
  in
    Random.int 0 (numClozes - 1)
    |> Random.map (create sentence)

