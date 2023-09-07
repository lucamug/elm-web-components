module Main exposing (main)

--
-- It requires
--
-- ```
-- git clone https://github.com/mdgriffith/elm-animator.git
-- git clone https://github.com/mdgriffith/elm-ui.git
-- ```
--
-- ### Debugging
--
-- To subscribe to event
--
-- $0.addEventListener("sl-change", (event) => {console.log(event);});
--

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Ui exposing (..)


type alias Model =
    { count : Int
    , switch : Bool
    , string : String
    }


initialModel : Model
initialModel =
    { count = 0
    , switch = True
    , string = ""
    }


type Msg
    = Increment
    | Decrement
    | ToggleSwitch
    | NewValue String


update : Msg -> Model -> Model
update msg model =
    case msg |> Debug.log "msg" of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }

        ToggleSwitch ->
            { model | switch = not model.switch }

        NewValue string ->
            { model | string = string }


comp1 : Html msg
comp1 =
    node "sl-alert"
        [ attribute "open" "true" ]
        [ node "sl-icon" [ attribute "slot" "icon", attribute "name" "info-circle" ] []
        , Html.text "This is a standard alert. You can customize its content and even the icon."
        ]


comp2 : Html Msg
comp2 =
    node "sl-color-picker"
        [ attribute "label" "Select a color"
        , onChange
        ]
        []


comp3 : Html msg
comp3 =
    node "sl-tooltip"
        [ attribute "content" "This is a tooltip" ]
        [ node "sl-button" [] [ Html.text "Hover Me" ] ]


comp4 : Bool -> Html Msg
comp4 bool =
    node "sl-switch"
        [ name "switch-1"
        , value "123"
        , on "sl-change" (Json.Decode.succeed ToggleSwitch)
        , checked bool
        ]
        []


comp5 : Bool -> Html Msg
comp5 bool =
    node "sl-switch"
        [ on "sl-change" (Json.Decode.succeed ToggleSwitch)
        , name "switch-2"
        , value "123"
        , checked (not bool)
        ]
        []


comp6 : Html Msg
comp6 =
    node "sl-input"
        [ type_ "date"
        , placeholder "Date"
        , onChange
        ]
        []


onChange : Html.Attribute Msg
onChange =
    Json.Decode.string
        |> Json.Decode.at [ "target", "value" ]
        |> Json.Decode.map NewValue
        |> Html.Events.on "sl-change"


onEnter : msg -> Html.Attribute msg
onEnter msg =
    let
        isEnterKey : number -> Json.Decode.Decoder msg
        isEnterKey keyCode =
            if keyCode == 13 then
                Json.Decode.succeed msg

            else
                Json.Decode.fail "silent failure :)"

        f : Json.Decode.Decoder msg
        f =
            Json.Decode.andThen isEnterKey Html.Events.keyCode
    in
    Html.Events.on "keyup" f


view : Model -> Html Msg
view model =
    div []
        [ Html.node "style" [] [ Html.text """
            .myExplain {outline: 6px solid rgba(174,121,15,0.5)}
            .myExplain > .s {outline: 4px dashed rgba(0,151,167,0.5)}""" ]
        , layout [] <|
            column [ padding 10, spacing 10 ]
                [ Ui.row [ spacing 10, htmlAttribute <| Html.Attributes.class "myExplain" ]
                    [ Ui.text "A", Ui.text "B" ]
                , Ui.row [ spacing 10, explain <| Debug.todo ]
                    [ Ui.text "A", Ui.text "B" ]
                ]
        ]


view2 : Model -> Html Msg
view2 model =
    div []
        [ div [] [ a [ href "https://shoelace.style/" ] [ Html.text "https://shoelace.style/" ] ]
        , div [ style "margin" "2rem 0" ] [ Html.text <| Debug.toString model ]
        , div [ style "margin" "2rem 0" ] [ comp1 ]
        , node "sl-card"
            [ class "card-overview" ]
            [ img
                [ attribute "slot" "image"
                , src "https://images.unsplash.com/photo-1559209172-0ff8f6d49ff7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=80"
                , alt "A kitten sits patiently between a terracotta pot and decorative grasses."
                ]
                []
            , strong [] [ Html.text "Mittens" ]
            , br [] []
            , Html.text "This kitten is as cute as he is playful. Bring him home today!"
            , br [] []
            , small [] [ Html.text "6 weeks old" ]
            , div [ attribute "slot" "footer" ]
                [ node "sl-button"
                    [ attribute "variant" "primary", attribute "pill" "true" ]
                    [ Html.text "More Info" ]
                , node "sl-rating" [] []
                ]
            ]
        , comp2
        , comp3
        , comp4 model.switch
        , comp5 model.switch
        , comp6
        ]


madeWithElmUi2 : Model -> Html Msg
madeWithElmUi2 model =
    layout
        [ padding 50
        , background <| rgb 250 200 200
        , border 5
        , borderColor <| rgb 150 100 0
        , rounded 20
        ]
    <|
        column [ spacing 20 ]
            [ el [] <| html <| comp1
            , el [] <| html <| comp2
            , el [] <| html <| comp3
            , el [ linkNewTab "https://shoelace.style/components/switch" ] <| Ui.text "https://shoelace.style/components/switch"
            , el [] <| html <| comp4 model.switch
            , el [] <| html <| comp5 model.switch
            , el [] <| html <| comp6
            ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
