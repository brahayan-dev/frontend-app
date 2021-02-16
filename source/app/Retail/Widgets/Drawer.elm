module Retail.Widgets.Drawer exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type Model
    = Model Int


init : ( Model, Cmd Msg )
init =
    ( Model 0, Cmd.none )


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        Increment ->
            ( Model <| model + 1, Cmd.none )

        Decrement ->
            ( Model <| model - 1, Cmd.none )


view : Model -> Html Msg
view (Model model) =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]
