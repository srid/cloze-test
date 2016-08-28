module ClozeTest.Model exposing (..)

import ClozeTest.Sentence exposing (Sentence)
import ClozeTest.Sentence as Sentence
import ClozeTest.Test exposing (Test)
import ClozeTest.Test as Test
import ClozeTest.Data as Data

type alias Model = 
  { dataSource : String
  , sentences : List Sentence
  , test : Test
  , cloze : String 
  , userAnswer : String
  }

emptyModel : Model
emptyModel =
  Model "" [] [] "" ""
  |> changeSentences [Data.defaultSentence]

changeDataSource : String -> Model -> Model
changeDataSource url model =
  { model | dataSource = url }

changeSentences : List Sentence -> Model -> Model
changeSentences sentences model =
  { model | sentences = sentences }

changeTest : Test -> Model -> Model 
changeTest test model =
  let
    cloze = test
            |> List.filter .cloze 
            |> List.map .text
            |> List.head
            |> Maybe.withDefault "!! No cloze found !!"  -- this cannot happen.
  in
    { model | test = test 
    , cloze = cloze 
    , userAnswer = "" }