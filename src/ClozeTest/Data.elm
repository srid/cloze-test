
module ClozeTest.Data exposing (parse, sampleUrl, defaultSentence)

import List
import Regex

import ClozeTest.Sentence exposing (Sentence)
import ClozeTest.Sentence as Sentence

-- This URL is served by elm-reactor
sampleUrl : String
sampleUrl = 
  "http://localhost:8000/src/ClozeTest/sample.txt"

-- XXX: We shouldn't need this if parser had proper error handing.
defaultSentence : Sentence
defaultSentence = "No sentences available" |> Sentence.parse

parse : String -> List Sentence.Sentence
parse =
  let
    withDefault default list =
      if List.isEmpty list then
        default
      else
        list
  in
    splitParagraph 
    >> List.map Sentence.parse 
    >> withDefault [defaultSentence]

splitParagraph : String -> List String
splitParagraph paragraph =
  splitAt paragraph "([^\\. ]\\.\\s+)"

splitAt : String -> String -> List String
splitAt s re =
  s
  |> Regex.split Regex.All (Regex.regex re)
  |> reconstructSplits

reconstructSplits : List String -> List String
reconstructSplits splits =
  if (List.length splits) < 2 then
    splits
  else
    let
      firstTwo = splits |> List.take 2 |> List.foldr (++) ""
      rest     = splits |> List.drop 2 |> reconstructSplits
    in
      firstTwo :: rest
  
