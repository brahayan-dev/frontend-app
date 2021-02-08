module Common.Components.Button exposing
    ( Button
    , default
    , setDisabled
    , setLoading
    , toHtml
    )

import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (class)
import Svg exposing (circle, svg)
import Svg.Attributes as Att


type Button
    = Button Model


type alias Model =
    { state : State
    , label : String
    , block : Bool
    }


type State
    = Loading
    | Disabled
    | Ready


default : String -> Button
default label =
    Button
        { label = label
        , block = False
        , state = Ready
        }


setDisabled : Button -> Button
setDisabled (Button model) =
    Button { model | state = Disabled }


setLoading : Button -> Button
setLoading (Button model) =
    Button { model | state = Loading }


toHtml : List (Attribute msg) -> Button -> Html msg
toHtml events (Button { state, label }) =
    case state of
        Ready ->
            button (List.append events [ class activeStyle ])
                [ text label ]

        _ ->
            div [ class phantomStyle ] [ spinner ]


spinner : Html msg
spinner =
    svg [ Att.class "spinner", Att.viewBox "0 0 30 30" ]
        [ circle
            [ Att.fill "none"
            , Att.class "path"
            , Att.strokeWidth "3"
            , Att.cx "15"
            , Att.cy "15"
            , Att.r "10"
            ]
            []
        ]


activeStyle : String
activeStyle =
    """
    text-white
    bg-primary
    font-bold
    rounded-full
    w-full
    h-12
    """


phantomStyle : String
phantomStyle =
    """
    center
    border-b-4
    bg-gray-300
    border-gray-400
    cursor-not-allowed
    font-bold
    rounded-full
    w-full
    h-12
    """
