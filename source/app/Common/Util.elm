module Common.Util exposing (process, when, guard)

import Task

when : Bool -> (m -> m) -> m -> m
when isTrue modifier model =
    if isTrue then
        modifier model

    else
        model


process :
    (elementModel -> element)
    -> (elementMsg -> msg)
    -> { m | element : element, globalState : globalState }
    -> ( elementModel, globalState, Cmd elementMsg )
    -> ( { m | element : element, globalState : globalState }, Cmd msg )
process createElement wrapMsg model ( elementModel, globalState, elementCmd ) =
    ( { model | element = createElement elementModel, globalState = globalState }
    , Cmd.map wrapMsg elementCmd
    )

guard : (a -> msg) -> a -> Cmd msg
guard action value =
    Task.perform action (Task.succeed value)
