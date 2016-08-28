import Html.App as Html

import ClozeTest.Data as Data
import ClozeTest.Controller as Controller
import ClozeTest.View exposing (view)
import ClozeTest.Model exposing (..)

main : Program Never
main =
  Html.program 
    { init = init
    , view = view
    , update = Controller.update
    , subscriptions = subscriptions 
    }

init : (Model, Cmd Controller.Msg)
init =
  emptyModel
  |> Controller.update (Controller.LoadData Data.sampleUrl)

subscriptions : Model -> Sub Controller.Msg
subscriptions model =
  Sub.none
