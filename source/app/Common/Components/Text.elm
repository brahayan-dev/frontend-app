module Common.Components.Text exposing
    ( default
    , setAddon
    , setAlignment
    , setKind
    , toHtml
    )

import Dict
import Html exposing (Html)
import Html.Attributes as Att


type Text
    = Text
        { isBlock : Bool
        , alignment : String
        , label : String
        , addon : String
        , kind : String
        , tag : String
        }


default : String -> Text
default label =
    Text
        { tag = "p"
        , addon = ""
        , kind = "title"
        , alignment = "center"
        , isBlock = True
        , label = label
        }


setAlignment : String -> Text -> Text
setAlignment s (Text model) =
    Text { model | alignment = s }


setAddon : String -> Text -> Text
setAddon s (Text model) =
    Text { model | addon = s }


setKind : String -> Text -> Text
setKind s (Text model) =
    Text { model | kind = s }


toHtml : Text -> Html msg
toHtml (Text { kind, alignment, addon, tag, label }) =
    getTag tag
        [ Att.classList
            [ ( "font-sans", True )
            , ( getAlignment alignment, True )
            , ( getKind kind, True )
            , ( addon, True )
            ]
        ]
        [ Html.text label ]


getTag : String -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
getTag s =
    Dict.fromList
        [ ( "h1", Html.h1 )
        , ( "h2", Html.h2 )
        , ( "h3", Html.h3 )
        , ( "h4", Html.h4 )
        , ( "h5", Html.h5 )
        , ( "h6", Html.h6 )
        , ( "p", Html.p )
        , ( "span", Html.span )
        ]
        |> Dict.get s
        |> Maybe.withDefault Html.span


getAlignment : String -> String
getAlignment s =
    Dict.fromList
        [ ( "center", "text-center" )
        , ( "justify", "text-justify" )
        , ( "right", "text-right" )
        , ( "left", "text-left" )
        ]
        |> Dict.get s
        |> Maybe.withDefault "text-center"


getKind : String -> String
getKind s =
    let
        defaultStyle =
            "text-lg font-normal"
    in
    Dict.fromList
        [ ( "title", "text-4xl font-bold" )
        , ( "subtitle", "text-3xl font-medium" )
        , ( "error", "text-xs font-light text-red-400" )
        , ( "help", "text-xs font-light" )
        , ( "basic", defaultStyle )
        ]
        |> Dict.get s
        |> Maybe.withDefault defaultStyle
