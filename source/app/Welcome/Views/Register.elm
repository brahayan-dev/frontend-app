module Welcome.Views.Register exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Browser.Navigation exposing (Key)
import Common.Components.Button as Button
import Common.Components.Input as Input
import Common.Components.Link as Link
import Html exposing (Html, section)
import Html.Events as E
import Router exposing (redirectTo)
import Store exposing (State)
import Welcome.Components.Hero as Hero


type Model
    = Model
        { username : Maybe String
        , navigationKey : Key
        , globalState : State
        , password : String
        , isLoading : Bool
        , email : String
        }


init : ( Key, State ) -> ( Model, State, Cmd Msg )
init ( key, state ) =
    ( Model
        { email = ""
        , password = ""
        , isLoading = False
        , username = Nothing
        , globalState = state
        , navigationKey = key
        }
    , state
    , Cmd.none
    )


type Msg
    = ChangeEmail String
    | ChangePassword String
    | AccountCreated String
    | CreateAccount
    | GoToLogin


update : Msg -> Model -> ( Model, State, Cmd Msg )
update msg (Model ({ globalState, navigationKey } as model)) =
    case msg of
        ChangeEmail email ->
            ( Model { model | email = email }, globalState, Cmd.none )

        ChangePassword password ->
            ( Model { model | password = password }, globalState, Cmd.none )

        CreateAccount ->
            ( Model model, globalState, Cmd.none )

        GoToLogin ->
            ( Model model, globalState, redirectTo navigationKey "/shop" )

        AccountCreated _ ->
            ( Model model, globalState, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view _ =
    "This one is a title"
        |> Hero.default
        |> Hero.toHtml [ E.onSubmit CreateAccount ] viewForm


viewForm : Html Msg
viewForm =
    section []
        [ "email"
            |> Input.default
            |> Input.addPlaceholder "Correo electrónico"
            |> Input.toHtml [ E.onInput ChangeEmail ]
        , "password"
            |> Input.default
            |> Input.addPlaceholder "Contraseña"
            |> Input.toHtml [ E.onInput ChangePassword ]
        , "Crear cuenta"
            |> Button.default
            |> Button.toHtml []
        , "Sign in"
            |> Link.default
            |> Link.toHtml [ E.onClick GoToLogin ]
        ]
