module Retail.Views.Shop exposing (Model, Msg, init, update, view)

import Browser.Navigation exposing (Key)
import Common.Util as Util
import Html exposing (Html)
import Retail.Widgets.Cabinet as Cabinet
import Retail.Widgets.Drawer as Drawer
import Router exposing (redirectTo)
import Store exposing (State)


type Model
    = Model
        { basket : Int
        , globalState : State
        , navigationKey : Key
        , drawerModel : Drawer.Model
        }


init : ( Key, State ) -> ( Model, State, Cmd Msg )
init ( key, state ) =
    let
        ( drawerModel, drawerCmd ) =
            Drawer.init
    in
    ( Model
        { basket = 0
        , globalState = state
        , navigationKey = key
        , drawerModel = drawerModel
        }
    , state
    , Util.join
        [ ( DrawerMsg, drawerCmd ) ]
        [ Util.guard NoOp <| Store.readUserIsActive state ]
    )


type Msg
    = NoOp Bool
    | DrawerMsg Drawer.Msg


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

        DrawerMsg localMsg ->
            Drawer.update localMsg model.drawerModel
                |> Util.routine model DrawerMsg (\l m -> { m | drawerModel = l })
                |> Util.pack Model globalState


view : Model -> Html Msg
view _ =
    Cabinet.default |> Cabinet.toHtml
