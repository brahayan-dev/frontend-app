module App exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Navigation
import Common.Core as Core
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Retail.Views.Shop as Shop
import Router
import Store exposing (State)
import Url exposing (Url)
import Welcome.Views.Login as Login
import Welcome.Views.Register as Register



---- MODEL ----


type Page
    = Register Register.Model
    | Login Login.Model
    | Shop Shop.Model
    | Redirect
    | NotFound


type alias Model =
    { element : Page
    , globalState : State
    , navigationKey : Navigation.Key
    }


initialModel : Navigation.Key -> Model
initialModel navigationKey =
    { element = Redirect
    , navigationKey = navigationKey
    , globalState = Store.createState
    }


{-| Esta función es ejecutada por el 'runtime' de ELM
-}
init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init () url navigationKey =
    setNewPage (Router.match url) (initialModel navigationKey)



---- VIEW ----


viewContent : Page -> ( String, Html Msg )
viewContent page =
    case page of
        Register registerModel ->
            ( "Register", Register.view registerModel |> Html.map RegisterMsg )

        Login loginModel ->
            ( "Login", Login.view loginModel |> Html.map LoginMsg )

        Shop shopModel ->
            ( "Lists", Shop.view shopModel |> Html.map ShopMsg )

        Redirect ->
            ( "Redirect", text "" )

        NotFound ->
            ( "Not Found"
            , div [ class "not-found" ]
                [ h1 [] [ text "Page Not Found" ] ]
            )


view : Model -> Document Msg
view model =
    let
        ( title, content ) =
            viewContent model.element
    in
    { title = title
    , body = [ content ]
    }



---- UPDATE ----


type Msg
    = Visit UrlRequest
    | ShopMsg Shop.Msg
    | LoginMsg Login.Msg
    | RegisterMsg Register.Msg
    | NewRoute (Maybe Router.Route)


setNewPage : Maybe Router.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute ({ globalState, navigationKey } as model) =
    case maybeRoute of
        Just Router.Register ->
            Register.init ( navigationKey, globalState )
                |> Core.process Register RegisterMsg model

        Just Router.Login ->
            Login.init ( navigationKey, globalState )
                |> Core.process Login LoginMsg model

        Just Router.Shop ->
            Shop.init ( navigationKey, globalState )
                |> Core.process Shop ShopMsg model

        Just Router.Redirect ->
            ( model, Router.redirectTo navigationKey "/login" )

        Nothing ->
            ( { model | element = NotFound }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ navigationKey, element } as model) =
    case ( msg, element ) of
        ( NewRoute maybeRoute, _ ) ->
            setNewPage maybeRoute model

        ( Visit (Browser.Internal url), _ ) ->
            ( model, Navigation.pushUrl navigationKey (Url.toString url) )

        ( LoginMsg loginMsg, Login loginModel ) ->
            Login.update loginMsg loginModel
                |> Core.process Login LoginMsg model

        ( RegisterMsg registerMsg, Register registerModel ) ->
            Register.update registerMsg registerModel
                |> Core.process Register RegisterMsg model

        ( ShopMsg shopMsg, Shop shopModel ) ->
            Shop.update shopMsg shopModel
                |> Core.process Shop ShopMsg model

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.element of
        Register registerModel ->
            Register.subscriptions registerModel
                |> Sub.map RegisterMsg

        Login loginModel ->
            Login.subscriptions loginModel
                |> Sub.map LoginMsg

        _ ->
            Sub.none



---- MAIN ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = Visit
        , onUrlChange = Router.match >> NewRoute
        }
