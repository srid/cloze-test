module ClozeTest.Sentence exposing (Sentence, Part, parse, generateRandom)

import Regex exposing (regex)
import Random

type alias Part = 
  { text :  String 
  , cloze : Bool
  }

type alias Sentence = List Part

parse : String -> Sentence
parse sentenceRaw =
  let
    -- Apply P or Cloze to given part and return the new arguments with constructors reversed, for use in foldr.
    construct part (sentence, isCloze) =
      (Part part isCloze :: sentence, not isCloze)
  in
    sentenceRaw
    |> normalize
    |> Regex.split Regex.All (regex "[{}]")
    |> List.foldr construct ([], False) 
    |> fst

normalize : String -> String
normalize s =
  -- To ensure that sentences never, technically, begin with a cloze,
  -- because the `construct` function above makes a cloze=false part first.
  " " ++ s

generateRandom : List Sentence -> Sentence -> Random.Generator Sentence
generateRandom sentences defaultSentence =
  let
    listSelect list default idx = 
      list
      |> List.drop idx 
      |> List.head 
      |> Maybe.withDefault default
  in
    List.length sentences - 1
    |> Random.int 0
    |> Random.map (listSelect sentences defaultSentence)