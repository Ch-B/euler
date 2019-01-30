module Main exposing (main)

import BigInt
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type alias Model =
    { result : BigInt.BigInt
    , count : Int
    }


initialModel : Model
initialModel =
    { result = BigInt.fromInt 1
    , count = 1
    }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model
                | count = model.count + 1
                , result =
                    BigInt.mul model.result <|
                        BigInt.fromInt <|
                            model.count
                                + 1
            }

        Decrement ->
            { model
                | count = model.count - 1
                , result =
                    BigInt.div model.result <|
                        BigInt.fromInt <|
                            model.count
            }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Increment ] [ text "+1" ]
        , div [] [ text <| String.fromInt model.count, text "! =" ]
        , div [] [ text <| BigInt.toString model.result ]
        , button [ onClick Decrement ] [ text "-1" ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
