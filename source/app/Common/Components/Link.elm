module Common.Components.Link exposing
    ( Link
    , default
    , toHtml
    )

import Html exposing (Attribute, Html, a, text)
import Html.Attributes as A


type Link
    = Link Model


type alias Model =
    { color : Color
    , label : String
    }


type Color
    = Basic


default : String -> Link
default label =
    Link
        { label = label
        , color = Basic
        }


toHtml : List (Attribute msg) -> Link -> Html msg
toHtml events (Link { color, label }) =
    case color of
        _ ->
            a (List.append events [ A.class basicStyle ])
                [ text label ]


basicStyle : String
basicStyle =
    """
    text-primary
    cursor-pointer
    font-bold
    underline
    center
    mt-4
    """
