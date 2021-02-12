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
import Common.Util as Util
import Html exposing (Html, section)
import Html.Events as E
import Http
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
    | GotUser (Result Http.Error String)
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
            ( Model { model | isLoading = True }
            , globalState
            , Http.get
                { url = "https://jsonplaceholder.typicode.com/posts/1"
                , expect = Http.expectString GotUser
                }
            )

        GoToSignUp ->
            ( Model model
            , globalState |> Store.writeUserIsActive True
            , redirectTo navigationKey "/register"
            )

        GotUser answer ->
            Debug.log (Debug.toString answer) ( Model model, globalState, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


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
