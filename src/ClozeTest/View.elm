module ClozeTest.View exposing (view) 

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)

import ClozeTest.Model exposing (..)
import ClozeTest.Controller as Controller
import ClozeTest.Sentence exposing (Sentence)
import ClozeTest.Sentence as Sentence

perAnswer : Model -> a -> a -> a
perAnswer model correct wrong =
  case model.userAnswer == model.cloze of
    True  -> correct
    False -> wrong

view : Model -> Html Controller.Msg 
view model =
  div [] [
    h1 [] [ text "Cloze Test"]
  , span [] [ text "Data source:" ]
  , input [ value model.dataSource
          , style [("width", "80%")] 
          , onInput Controller.LoadData ] []
  , h2 [] [text "Current test"]
  , viewTest model
  , hr [] []
  , viewControls model
  ]

viewControls : Model -> Html Controller.Msg
viewControls model =
  div [] 
    [ button [ onClick Controller.Next ] [ text "Next" ]]

viewTest : Model -> Html Controller.Msg
viewTest model =
  viewSentence model model.test

viewSentence : Model -> Sentence -> Html Controller.Msg
viewSentence model sentence =
  div [] <| List.map (viewPart model) sentence

viewPart : Model -> Sentence.Part -> Html Controller.Msg
viewPart model part =
  case part.cloze of
    False ->
      text part.text
    True ->
      viewCloze model part.text

viewCloze : Model -> String -> Html Controller.Msg
viewCloze model cloze =
  let 
    colorStyle = ("color", perAnswer model "darkgreen" "auto")
  in
    input [ title cloze
          , style [colorStyle]
          , onInput Controller.Answer
          , autofocus <| perAnswer model False True
          , value model.userAnswer ] [ ]
