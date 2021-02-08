module Store exposing
    ( State
    , createState
    , readUserIsActive
    , writeUserIsActive
    )


type State
    = State
        { userIsActive : Bool
        , apiToken : String
        }


createState : State
createState =
    State { userIsActive = False, apiToken = "" }


writeUserIsActive : Bool -> State -> State
writeUserIsActive b (State base) =
    State { base | userIsActive = b }


readUserIsActive : State -> Bool
readUserIsActive (State { userIsActive }) =
    userIsActive
