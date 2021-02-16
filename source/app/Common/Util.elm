module Common.Util exposing (guard, join, process, routine, when, pack)

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
    model
    -> (localMsg -> msg)
    -> (localModel -> model -> model)
    -> ( localModel, Cmd localMsg )
    -> ( model, Cmd msg )
routine model wrapMsg updateModel ( localModel, localCmd ) =
    ( updateModel localModel model, Cmd.map wrapMsg localCmd )

pack : (model -> kind) -> state -> (model, cmd) -> (kind, state, cmd)
pack toOpaque s (m, c) = (toOpaque m, s, c)

guard : (a -> msg) -> a -> Cmd msg
guard action value =
    Task.perform action (Task.succeed value)


join : List ( localMsg -> msg, Cmd localMsg ) -> List (Cmd msg) -> Cmd msg
join locals msgs =
    Cmd.batch <|
        List.append msgs <|
            List.map (\( m, l ) -> Cmd.map m l) locals
