module ClozeTest.View exposing (view) 

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)

import Material
import Material.Scheme
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Layout as Layout

import ClozeTest.Model exposing (..)
import ClozeTest.Controller as Controller
import ClozeTest.Sentence exposing (Sentence)
import ClozeTest.Sentence as Sentence

type alias Mdl = 
  Material.Model 

perAnswer : Model -> a -> a -> a
perAnswer model correct wrong =
  case model.userAnswer == model.cloze of
    True  -> correct
    False -> wrong

view : Model -> Html Controller.Msg 
view model =
  Layout.render Controller.Mdl model.mdl
    [ Layout.fixedHeader
    ]
    { header = [ div [] 
                  [ h1 [] [ text "Cloze Test : " 
                          , text <| toString model.state ]
                  ]
               ]
    , drawer = []
    , tabs = ([], [])
    , main = [ div []
              [ Textfield.render Controller.Mdl [2] model.mdl
                  [ Textfield.label "Data source"
                  , Textfield.floatingLabel
                  , Textfield.text'
                  , Textfield.value model.dataSource
                  , Textfield.onInput Controller.LoadData 
                  ] 
              , h2 [] [text "Current test"]
              , viewTest model
              , hr [] []
              , viewControls model
              ] ]
    }
    |> Material.Scheme.top
    
view2 model =
  div [] 
    [ h1 [] [ text "Cloze Test"]
    , p [] [ text <| toString model.state ]
    , span [] [ text "Data source:" ]
    , input [ value model.dataSource
            , style [("width", "80%")]
            , disabled <| model.state == Loading 
            , onInput Controller.LoadData ] []
    , h2 [] [text "Current test"]
    , viewTest model
    , hr [] []
    , viewControls model
    ]
  |> Material.Scheme.top

viewControls : Model -> Html Controller.Msg
viewControls model =
  div [] 
    [ Button.render Controller.Mdl [0] model.mdl 
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Button.onClick Controller.Next
        ]
        [ text "Next" ]
    ]

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
    label = if model.userAnswer == model.cloze then
              "Correct!"
            else
              "What comes here?"
  in
    Textfield.render Controller.Mdl [1] model.mdl
      [ Textfield.label label
      , Textfield.floatingLabel
      , Textfield.onInput Controller.Answer
      , Textfield.autofocus
      , Textfield.value model.userAnswer ]
