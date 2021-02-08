module Router exposing
    ( Route(..)
    , match
    , redirectTo
    )

import Browser.Navigation as Navigation
import Url exposing (Url)
import Url.Parser as UrlParser exposing (Parser)


type Route
    = Redirect
    | Login
    | Register
    | Shop


match : Url -> Maybe Route
match url =
    UrlParser.parse routes url


paths : List String
paths =
    [ "/login"
    , "/register"
    , "/shop"
    ]


redirectTo : Navigation.Key -> String -> Cmd msg
redirectTo key path =
    Navigation.pushUrl key <|
        if List.member path paths then
            path

        else
            "/not-found"


routes : Parser (Route -> a) a
routes =
    UrlParser.oneOf
        [ UrlParser.map Redirect UrlParser.top
        , UrlParser.map Shop (UrlParser.s "shop")
        , UrlParser.map Login (UrlParser.s "login")
        , UrlParser.map Register (UrlParser.s "register")
        ]
