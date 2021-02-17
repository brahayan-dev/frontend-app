module Common.Core exposing (guard, pack, process)

import Task


process :
    (innerModel -> element)
    -> (innerMsg -> msg)
    -> { m | element : element, globalState : globalState }
    -> ( innerModel, globalState, Cmd innerMsg )
    -> ( { m | element : element, globalState : globalState }, Cmd msg )
process createElement wrapMsg model ( innerModel, globalState, innerCmd ) =
    ( { model | element = createElement innerModel, globalState = globalState }
    , Cmd.map wrapMsg innerCmd
    )


pack : (model -> kind) -> state -> ( model, cmd ) -> ( kind, state, cmd )
pack toOpaque state ( model, cmd ) =
    ( toOpaque model, state, cmd )


guard : (a -> msg) -> a -> Cmd msg
guard action value =
    Task.perform action (Task.succeed value)
