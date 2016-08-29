module ClozeTest.Controller exposing (..)

import Http
import Task
import Random
import Material

import ClozeTest.Test exposing (Test)
import ClozeTest.Test as Test
import ClozeTest.Model exposing (Model)
import ClozeTest.Model as Model
import ClozeTest.Sentence exposing (Sentence)
import ClozeTest.Sentence as Sentence
import ClozeTest.Data as Data

type Msg 
  = LoadData String
  | Loaded String
  | Failed Http.Error
  | Answer String
  | ShowTest Test
  | Next
  | Mdl (Material.Msg Msg)

getData : Model -> Cmd Msg
getData model =
  Task.perform Failed Loaded (Http.getString model.dataSource)

generateTest : Model -> Cmd Msg
generateTest model =
  (Sentence.generateRandom model.sentences Data.defaultSentence) 
  `Random.andThen` Test.generateTests 
  |> Random.generate ShowTest

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadData url ->
      Model.changeDataSource url model
      |> andThen getData
    Loaded paragraph ->
      Model.changeSentences (Data.parse paragraph) model
      |> andThen generateTest
    Failed error ->
      -- XXX: proper error reporting
      update (Loaded <| "Loading failed: " ++ toString error) model
    Answer text ->
      ({ model | userAnswer = text }, Cmd.none)
    Next ->
      (model, generateTest model)
    ShowTest test ->
      (Model.changeTest test model, Cmd.none)
    Mdl msg' -> 
      Material.update msg' model

andThen : (Model -> Cmd Msg) -> Model -> (Model, Cmd Msg)
andThen f model =
  (model, f model)