module Common.Components.Input exposing
    ( Input
    , addPlaceholder
    , default
    , makeLarge
    , toHtml
    )

import Html exposing (Attribute, Html, input)
import Html.Attributes as Att


type Size
    = Small
    | Medium
    | Large


type Input
    = Input
        { size : Size
        , kind : String
        , help : Maybe String
        , placeholder : String
        }


default : String -> Input
default type_ =
    Input
        { size = Medium
        , help = Nothing
        , kind = type_
        , placeholder = ""
        }


addPlaceholder : String -> Input -> Input
addPlaceholder placeholder (Input model) =
    Input { model | placeholder = placeholder }


makeLarge : Input -> Input
makeLarge (Input model) =
    Input { model | size = Large }


toHtml : List (Attribute msg) -> Input -> Html msg
toHtml events (Input model) =
    let
        attributes =
            List.append events
                [ Att.class style
                , Att.type_ model.kind
                , Att.placeholder model.placeholder
                ]
    in
    case model.size of
        Medium ->
            input attributes []

        _ ->
            input attributes []


style : String
style =
    """
    p-3
    mb-6
    w-full
    border
    shadow
    text-primary
    appearance-none
    focus:outline-none
    focus:shadow-outline
    leading-tight
    rounded-full
    text-center
    font-bold
    """
