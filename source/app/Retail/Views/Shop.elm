module Retail.Views.Shop exposing (Model, Msg, init, update, view)

import Browser.Navigation exposing (Key)
import Common.Core as Core
import Html exposing (Html)
import Retail.Widgets.Cabinet as Cabinet
import Router exposing (redirectTo)
import Store exposing (State)


type Model
    = Model
        { basket : Int
        , globalState : State
        , navigationKey : Key
        }


init : ( Key, State ) -> ( Model, State, Cmd Msg )
init ( key, state ) =
    ( Model
        { basket = 0
        , globalState = state
        , navigationKey = key
        }
    , state
    , Core.guard NoOp <| Store.readUserIsActive state
    )


type Msg
    = NoOp Bool


update : Msg -> Model -> ( Model, State, Cmd Msg )
update msg (Model ({ navigationKey, globalState } as model)) =
    case msg of
        NoOp isOpen ->
            ( Model model
            , globalState
            , if isOpen then
                Cmd.none

              else
                redirectTo navigationKey "/login"
            )


view : Model -> Html Msg
view _ =
    Cabinet.default |> Cabinet.toHtml
