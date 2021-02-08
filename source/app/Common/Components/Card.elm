module Common.Components.Card exposing (Card, default, setEnclosed, setHighShadow, setLowShadow, setMiddleShadow, setRounded, toHtml)

import Html exposing (Html, div)
import Html.Attributes exposing (classList)


type Shadow
    = Low
    | High
    | Middle


type Card
    = Card
        { rounded : Bool
        , enclosed : Bool
        , shadow : Shadow
        }


default : Card
default =
    Card { rounded = False, enclosed = False, shadow = Low }


setRounded : Card -> Card
setRounded (Card model) =
    Card { model | rounded = True }


setEnclosed : Card -> Card
setEnclosed (Card model) =
    Card { model | enclosed = True }


setLowShadow : Card -> Card
setLowShadow (Card model) =
    Card { model | shadow = Low }


setHighShadow : Card -> Card
setHighShadow (Card model) =
    Card { model | shadow = High }


setMiddleShadow : Card -> Card
setMiddleShadow (Card model) =
    Card { model | shadow = Middle }


toHtml : List (Html msg) -> Card -> Html msg
toHtml body (Card model) =
    div
        [ classList
            [ ( "w-64 border", True )
            , ( "p-8", model.enclosed )
            , ( "rounded-lg", model.rounded )
            , ( getShadowClass model.shadow, True )
            ]
        ]
        body


getShadowClass : Shadow -> String
getShadowClass shadow =
    case shadow of
        Low ->
            "shadow"

        Middle ->
            "shadow-md"

        High ->
            "shadow-2xl"
