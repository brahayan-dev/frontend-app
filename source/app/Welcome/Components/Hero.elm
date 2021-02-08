module Welcome.Components.Hero exposing
    ( Layout
    , addBackground
    , default
    , toHtml
    )

import Html exposing (Attribute, Html, div, form, p, text)
import Html.Attributes as Att


type Layout
    = Layout
        { title : String
        , background : String
        }


default : String -> Layout
default title =
    Layout { title = title, background = "" }


addBackground : String -> Layout -> Layout
addBackground background (Layout model) =
    Layout { model | background = background }


toHtml : List (Attribute msg) -> Html msg -> Layout -> Html msg
toHtml events form_ model =
    div [ Att.class "grid grid-cols-2" ]
        [ self model
        , form (List.append events [ Att.class "center m-2" ])
            [ form_ ]
        ]


self : Layout -> Html msg
self (Layout { title, background }) =
    let
        image =
            "url('" ++ background ++ "')"
    in
    div
        [ Att.class "flex flex-col w-full h-screen bg-primary"
        , Att.style "background-size" "cover"
        , Att.style "background-image" image
        ]
        [ div [ Att.class "center flex-grow" ]
            [ p [ Att.class "font-bold text-6xl text-center text-white" ]
                [ text title ]
            ]
        ]
