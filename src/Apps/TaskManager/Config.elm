module Apps.TaskManager.Config exposing (..)

import Time exposing (Time)
import Game.Servers.Processes.Models as Processes
import Apps.TaskManager.Messages exposing (..)


type alias Config msg =
    { toMsg : Msg -> msg
    , processes : Processes.Model
    , lastTick : Time
    , batchMsg : List msg -> msg
    , onPauseProcess : Processes.ID -> msg
    , onResumeProcess : Processes.ID -> msg
    , onRemoveProcess : Processes.ID -> msg
    }
