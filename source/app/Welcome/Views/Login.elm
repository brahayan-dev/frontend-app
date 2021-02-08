module Welcome.Views.Login exposing
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
import Common.Services.Authorization as AuthService
import Common.Util as Util
import Html exposing (Html, section)
import Html.Events as E
import Router exposing (redirectTo)
import Store exposing (State)
import Welcome.Components.Hero as Hero


type Model
    = Model
        { email : String
        , password : String
        , isLoading : Bool
        , globalState : State
        , navigationKey : Key
        }


init : ( Key, State ) -> ( Model, State, Cmd Msg )
init ( key, state ) =
    ( Model
        { email = ""
        , password = ""
        , isLoading = False
        , globalState = state
        , navigationKey = key
        }
    , state
    , Cmd.none
    )


type Msg
    = ChangeEmail String
    | ChangePassword String
    | UserAuthorized String
    | GoToSignUp
    | MakeLogin


update : Msg -> Model -> ( Model, State, Cmd Msg )
update msg (Model ({ globalState, navigationKey } as model)) =
    case msg of
        ChangeEmail value ->
            ( Model { model | email = value }, globalState, Cmd.none )

        ChangePassword value ->
            ( Model { model | password = value }, globalState, Cmd.none )

        MakeLogin ->
            let
                { email, password } =
                    model
            in
            ( Model { model | isLoading = True }
            , globalState
            , { email = email, password = password }
                |> AuthService.encodeLoginModel
                |> AuthService.commonAuthorizationServiceSendLogin
            )

        GoToSignUp ->
            ( Model model
            , globalState |> Store.writeUserIsActive True
            , redirectTo navigationKey "/register"
            )

        UserAuthorized answer ->
            let
                model_ =
                    { model | isLoading = False }
            in
            case AuthService.decoder answer of
                Err _ ->
                    ( Model model_, globalState, Cmd.none )

                Ok _ ->
                    ( Model model, globalState, redirectTo navigationKey "/shop" )


subscriptions : Model -> Sub Msg
subscriptions _ =
    AuthService.commonAuthorizationServiceReceiveSchema UserAuthorized


viewForm : Model -> Html Msg
viewForm (Model { isLoading }) =
    section []
        [ "email"
            |> Input.default
            |> Input.addPlaceholder "Correo electrónico"
            |> Input.toHtml [ E.onInput ChangeEmail ]
        , "password"
            |> Input.default
            |> Input.addPlaceholder "Contraseña"
            |> Input.toHtml [ E.onInput ChangePassword ]
        , "Iniciar sesión"
            |> Button.default
            |> Util.when isLoading Button.setLoading
            |> Button.toHtml []
        , "Sign up"
            |> Link.default
            |> Link.toHtml [ E.onClick GoToSignUp ]
        ]


view : Model -> Html Msg
view model =
    "Inicie sesión"
        |> Hero.default
        |> Hero.toHtml [ E.onSubmit MakeLogin ] (viewForm model)
