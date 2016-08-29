module ClozeTest.Model exposing (..)

import Material

import ClozeTest.Sentence exposing (Sentence)
import ClozeTest.Sentence as Sentence
import ClozeTest.Test exposing (Test)
import ClozeTest.Test as Test
import ClozeTest.Data as Data

type alias Model = 
  { dataSource : String
  , state : State
  , sentences : List Sentence
  , test : Test
  , cloze : String 
  , userAnswer : String
  , mdl : Material.Model
  }

type State = Ready | Loading

emptyModel : Model
emptyModel =
  Model "" Ready [] [] "" "" Material.model 
  |> changeSentences [Data.defaultSentence]

changeDataSource : String -> Model -> Model
changeDataSource url model =
  { model | dataSource = url, state = Loading }

changeSentences : List Sentence -> Model -> Model
changeSentences sentences model =
  { model | sentences = sentences, state = Ready }

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