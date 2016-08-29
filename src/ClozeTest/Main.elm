import Html.App as App

import Material

import ClozeTest.Controller as Controller
import ClozeTest.View exposing (view)
import ClozeTest.Model exposing (..)
import ClozeTest.Data as Data

main : Program Never
main =
  App.program 
    { init = init
    , view = view
    , update = Controller.update
    , subscriptions = Material.subscriptions Controller.Mdl  
    }

init : ( Model, Cmd Controller.Msg )
init =
  let 
    model = emptyModel |> changeDataSource Data.sampleUrl
  in
    -- XXX: not sure if good idea to explicitly pass model here. 
    model ! [Controller.getData model, Material.init Controller.Mdl]