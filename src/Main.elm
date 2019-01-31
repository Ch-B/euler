module Main exposing (main)

import Browser
import Html exposing (Html, button, div, hr, option, select, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Problems.Factorial as PFa
import Problems.Test as PTe


type Submodel
    = PFaModel PFa.Model
    | PTeModel PTe.Model


type alias Model =
    { problemNr : Int
    , subModel : Submodel
    }


initialModel : Model
initialModel =
    { problemNr = 1
    , subModel = PFaModel PFa.initialModel
    }


type Msg
    = ChoosePage String
    | GotPFaMsg PFa.Msg
    | GotPTeMsg PTe.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChoosePage s ->
            { model
                | problemNr = Maybe.withDefault 1 <| String.toInt s
                , subModel =
                    if s == "001" then
                        PFaModel PFa.initialModel

                    else
                        PTeModel PTe.initialModel
            }

        GotPFaMsg m1 ->
            { model
                | subModel =
                    case model.subModel of
                        PFaModel mod ->
                            PFaModel <| PFa.update m1 mod

                        _ ->
                            PFaModel PFa.initialModel
            }

        GotPTeMsg m2 ->
            { model
                | subModel =
                    case model.subModel of
                        PTeModel mod ->
                            PTeModel <| PTe.update m2 mod

                        _ ->
                            PTeModel PTe.initialModel
            }


view : Model -> Html Msg
view model =
    let
        viewpage =
            case model.subModel of
                PFaModel mod ->
                    PFa.view mod |> Html.map GotPFaMsg

                PTeModel mod ->
                    PTe.view mod |> Html.map GotPTeMsg
    in
    div []
        [ div []
            [ text "Project Euler Problem : "
            , select [ onInput ChoosePage ]
                [ option [ value "001" ] [ text "001 Factorial" ]
                , option [ value "002" ] [ text "002 Test" ]
                ]
            ]
        , hr [] []
        , viewpage
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
