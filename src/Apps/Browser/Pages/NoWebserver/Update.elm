module Apps.Browser.Pages.NoWebserver.Update exposing (update)

import Core.Dispatch as Dispatch exposing (Dispatch)
import Utils.Update as Update
import Game.Data as Game
import Apps.Browser.Pages.NoWebserver.Models exposing (..)
import Apps.Browser.Pages.NoWebserver.Messages exposing (..)
import Apps.Browser.Widgets.HackingToolkit.Model as HackingToolkit


type alias UpdateResponse =
    ( Model, Cmd Msg, Dispatch )


update :
    Game.Data
    -> Msg
    -> Model
    -> UpdateResponse
update data msg model =
    case msg of
        GlobalMsg _ ->
            -- Treated in Browser.Update
            Update.fromModel model

        UpdatePasswordField str ->
            onUpdatePasswordField str model


onUpdatePasswordField : String -> Model -> UpdateResponse
onUpdatePasswordField newPassword model =
    let
        toolkit =
            HackingToolkit.setPassword newPassword model.toolkit
    in
        Update.fromModel { model | toolkit = toolkit }
