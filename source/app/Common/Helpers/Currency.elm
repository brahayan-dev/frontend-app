module Common.Helpers.Currency exposing (defineAsCOP, fromInt, toString)


type Code
    = COP


type Currency a
    = Currency { value : a, decimals : Int, code : Code }


fromInt : Int -> Currency Int
fromInt value =
    Currency { value = value, decimals = 0, code = COP }


defineAsCOP : Currency a -> Currency a
defineAsCOP (Currency model) =
    Currency { model | code = COP }


toString : Currency Int -> String
toString (Currency model) =
    String.fromInt model.value
        |> format model.code
        |> String.append (getSymbol model.code)


getSymbol : Code -> String
getSymbol code =
    case code of
        COP ->
            "$"


format : Code -> String -> String
format code value =
    let
        listOfIntegers =
            String.toList value
                |> List.map String.fromChar

        take_ amount =
            String.join "" <| List.take amount listOfIntegers

        drop_ amount =
            String.join "" <| List.drop amount listOfIntegers
    in
    case List.length listOfIntegers of
        4 ->
            String.join "." [ take_ 1, drop_ 1 ]

        5 ->
            String.join "." [ take_ 2, drop_ 2 ]

        6 ->
            String.join "." [ take_ 3, drop_ 3 ]

        7 ->
            String.join "." [ take_ 1, format code (drop_ 1) ]

        _ ->
            value
