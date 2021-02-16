module Common.Core exposing (guard, join, pack, process, routine, when)

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


routine :
    (innerMsg -> msg)
    -> (innerModel -> model)
    -> ( innerModel, Cmd innerMsg )
    -> ( model, Cmd msg )
routine wrapMsg updateModel ( innerModel, innerCmd ) =
    ( updateModel innerModel, Cmd.map wrapMsg innerCmd )


pack : (model -> kind) -> state -> ( model, cmd ) -> ( kind, state, cmd )
pack toOpaque state ( model, cmd ) =
    ( toOpaque model, state, cmd )


guard : (a -> msg) -> a -> Cmd msg
guard action value =
    Task.perform action (Task.succeed value)


join : List ( localMsg -> msg, Cmd localMsg ) -> List (Cmd msg) -> Cmd msg
join locals msgs =
    Cmd.batch <|
        List.append msgs <|
            List.map (\( m, l ) -> Cmd.map m l) locals
