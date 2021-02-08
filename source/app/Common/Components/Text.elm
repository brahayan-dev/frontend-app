module Common.Components.Text exposing
    ( addClasses
    , default
    , setCenter
    , setJustify
    , setLeft
    , setRight
    , toHtml
    )

import Html as H exposing (Html)
import Html.Attributes as Att


type Kind
    = Title
    | Subtitle


type Alignment
    = Center
    | Justify
    | Right
    | Left


type Tag
    = H1
    | H2
    | H3
    | H4
    | H5
    | H6
    | Paragraph
    | Help
    | Error


type Text
    = Text
        { label : String
        , isBlock : Bool
        , kind : Kind
        , alignment : Alignment
        , tag : Tag
        , classes : String
        }


default : String -> Text
default label =
    Text
        { label = label
        , kind = Title
        , isBlock = True
        , tag = Paragraph
        , alignment = Center
        , classes = ""
        }


addClasses : String -> Text -> Text
addClasses classes (Text model) =
    let
        addons =
            if String.isEmpty model.classes then
                model.classes

            else
                model.classes ++ " "
    in
    Text { model | classes = addons ++ classes }


setCenter : Text -> Text
setCenter (Text model) =
    Text { model | alignment = Center }


setRight : Text -> Text
setRight (Text model) =
    Text { model | alignment = Right }


setLeft : Text -> Text
setLeft (Text model) =
    Text { model | alignment = Left }


setJustify : Text -> Text
setJustify (Text model) =
    Text { model | alignment = Justify }


toHtml : Text -> Html msg
toHtml (Text model) =
    case model.tag of
        _ ->
            H.p
                [ Att.classList
                    [ ( "text-xs font-sans", True )
                    , ( getClassOfAlignment model.alignment, True )
                    , ( model.classes, True )
                    ]
                ]
                [ H.text model.label ]


getClassOfAlignment : Alignment -> String
getClassOfAlignment alignment =
    case alignment of
        Center ->
            "text-center"

        Justify ->
            "text-justify"

        Right ->
            "text-right"

        Left ->
            "text-left"
