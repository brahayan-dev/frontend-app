port module Common.Services.Authorization exposing
    ( Authorization
    , Failure
    , commonAuthorizationServiceReceiveSchema
    , commonAuthorizationServiceSendLogin
    , commonAuthorizationServiceSendRegister
    , decoder
    , encodeLoginModel
    , encodeRegisterModel
    , getAccessToken
    , getErrorMessage
    , getUserId
    )

import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E


type Authorization
    = Authorization
        { accessToken : String
        , userId : String
        }


type Failure
    = Failure ( String, String )


type alias Schema =
    { accessToken : Maybe String
    , errorCode : Maybe String
    , userId : Maybe String
    }


emptySchema : Schema
emptySchema =
    Schema Nothing Nothing Nothing


parseSchema : D.Decoder Schema
parseSchema =
    D.succeed Schema
        |> required "userId" (D.nullable D.string)
        |> required "errorCode" (D.nullable D.string)
        |> required "accessToken" (D.nullable D.string)


decodeSchema : String -> Schema
decodeSchema rawData =
    Result.withDefault emptySchema <| D.decodeString parseSchema rawData



-- TODO: Define failure response for empty schema
-- TODO: Define answers for every failure


map : Schema -> Result Failure Authorization
map { errorCode, userId, accessToken } =
    case errorCode of
        Nothing ->
            case ( userId, accessToken ) of
                ( Just userIdValue, Just tokenValue ) ->
                    Ok
                        (Authorization
                            { userId = userIdValue
                            , accessToken = tokenValue
                            }
                        )

                _ ->
                    Err (Failure ( "base/not-error-code", "¡Todo esta vacio!" ))

        Just code ->
            Err (Failure ( code, "¡Si hay error registrado!" ))


decoder : String -> Result Failure Authorization
decoder =
    decodeSchema >> map


getErrorMessage : Failure -> String
getErrorMessage (Failure ( _, errorMessage )) =
    errorMessage


getAccessToken : Authorization -> String
getAccessToken (Authorization { accessToken }) =
    accessToken


getUserId : Authorization -> String
getUserId (Authorization { userId }) =
    userId


type alias LoginModel =
    { email : String
    , password : String
    }


encodeLoginModel : LoginModel -> E.Value
encodeLoginModel { email, password } =
    E.object
        [ ( "email", E.string email )
        , ( "password", E.string password )
        ]



-- FIXME: Solve business logic modeling


type alias RegisterModel =
    { email : String
    , password : String
    , username : Maybe String
    }


encodeRegisterModel : RegisterModel -> E.Value
encodeRegisterModel { email, password, username } =
    E.object
        [ ( "email", E.string email )
        , ( "password", E.string password )
        , ( "username"
          , case username of
                Just value ->
                    E.string value

                Nothing ->
                    E.null
          )
        ]


port commonAuthorizationServiceSendLogin : E.Value -> Cmd msg


port commonAuthorizationServiceSendRegister : E.Value -> Cmd msg


port commonAuthorizationServiceReceiveSchema : (String -> msg) -> Sub msg
