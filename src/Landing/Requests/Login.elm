module Landing.Requests.Login exposing (Data, Errors(..), loginRequest)

import Json.Decode as Decode exposing (Decoder, Value, decodeValue)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Requests.Requests as Requests exposing (report)
import Requests.Topics as Topics
import Requests.Types exposing (FlagsSource, Code(..))


type alias Data =
    Result Errors ( String, String )


type Errors
    = WrongCreds
    | NetworkError
    | UnknownError


loginRequest : String -> String -> FlagsSource a -> Cmd Data
loginRequest username password flagsSrc =
    flagsSrc
        |> Requests.request Topics.login (encoder username password)
        |> Cmd.map (uncurry <| receiver flagsSrc)



-- internals


encoder : String -> String -> Value
encoder username password =
    Encode.object
        [ ( "username", Encode.string username )
        , ( "password", Encode.string password )
        ]


receiver : FlagsSource a -> Code -> Value -> Data
receiver flagsSrc code value =
    case code of
        OkCode ->
            value
                |> decodeValue decoder
                |> report "Landing.Login" code flagsSrc
                |> Result.mapError (always UnknownError)

        NotFoundCode ->
            Err WrongCreds

        _ ->
            Err NetworkError


decoder : Decoder ( String, String )
decoder =
    decode (,)
        |> required "token" Decode.string
        |> required "account_id" Decode.string
