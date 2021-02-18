module Retail.Widgets.Cabinet exposing
    ( Cabinet
    , default
    , pickProduct
    , toHtml
    )

import Common.Components.Button as Button
import Common.Components.Card as Card
import Common.Components.Text as Text
import Common.Helpers.Currency as Currency
import Html exposing (Html, img, section)
import Html.Attributes as Att
import List exposing (product)


type alias Product =
    { isPicked : Bool
    , description : String
    , imageUrl : String
    , price : Int
    , id : String
    }


type Cabinet
    = Cabinet
        { products : List Product
        , picked : List String
        }


default : Cabinet
default =
    Cabinet
        { products =
            List.repeat 25
                { id = "ABA23432"
                , description = "Detergente Polvo Fab Floral 4 Kg"
                , imageUrl = "https://jumbocolombiafood.vteximg.com.br/arquivos/ids/3506801-1000-1000/7702191000014.jpg?v=637261953794770000"
                , isPicked = False
                , price = 29890
                }
        , picked = []
        }


pickProduct : Product -> Cabinet -> Cabinet
pickProduct { id } (Cabinet model) =
    Cabinet { model | picked = id :: model.picked }


toHtml : Cabinet -> Html msg
toHtml (Cabinet model) =
    printProducts model.products


printProducts : List Product -> Html msg
printProducts products =
    let
        defineGrid =
            "m-4 grid grid-cols-7 gap-4"
    in
    section [ Att.class defineGrid ] <| List.map createProduct products


createProduct : Product -> Html msg
createProduct product =
    Card.default
        |> Card.setRounded
        |> Card.setEnclosed
        |> Card.setMiddleShadow
        |> Card.toHtml
            [ img [ Att.src product.imageUrl ] []
            , product.description
                |> Text.default
                |> Text.setAlignment "center"
                |> Text.setAddon "m-4"
                |> Text.toHtml
            , product.price
                |> Currency.fromInt
                |> Currency.defineAsCOP
                |> Currency.toString
                |> Text.default
                |> Text.toHtml
            , "Agregar"
                |> Button.default
                |> Button.toHtml []
            ]
