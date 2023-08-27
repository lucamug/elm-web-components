module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode


version : String
version =
    "0.1"



-- VIEW


viewCard : String -> Model -> Html Msg
viewCard themeClass model =
    node "sl-card"
        [ class "card-main", class themeClass ]
        [ h2 [ style "text-transform" "capitalize" ] [ text (String.replace "-" " " (String.replace "sl-" "" themeClass)) ]
        , h3 [] [ text "Alert" ]
        , node "sl-alert" [ open ] [ node "sl-icon" [ slot "icon", name "info-circle" ] [], text "This is a standard alert." ]
        , h3 [] [ text "Format Date" ]
        , p [] [ text "Localization is handled by the browser’s Intl.DateTimeFormat API" ]
        , ul [] [ viewDate "en-US", viewDate "en-GB", viewDate "it-IT", viewDate "ja-JP" ]
        , h3 [] [ text "Card with Image, Button (that opens the left Drawer), and Rating" ]
        , node "sl-card"
            [ class "card-overview" ]
            [ img [ slot "image", src "https://images.unsplash.com/photo-1559209172-0ff8f6d49ff7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=80", alt "A kitten sits patiently between a terracotta pot and decorative grasses." ] []
            , strong [] [ text "Mittens" ]
            , p [ style "margin" "0.5rem 0" ] [ text "This kitten is as cute as he is playful. Bring him home today!" ]
            , small [] [ text "6 weeks old" ]
            , div [ slot "footer" ]
                [ node "sl-button" [ onClick (ChangeDrawerOpen True), variant "primary", pill ] [ text "More info" ]
                , node "sl-rating" [ precision "1", value model.rating, onChangeFloat ChangeRatingAsFloat ] []
                ]
            ]
        , p [ style "display" "flex", style "align-items" "center", style "flex-wrap" "wrap", style "gap" "1rem" ]
            [ text "Rating Value", node "sl-input" [ onInputString ChangeRatingAsString, value model.rating, pill ] [] ]
        , h3 [] [ text "Color Picker" ]
        , p [ style "display" "flex", style "align-items" "center", style "flex-wrap" "wrap", style "gap" "1rem" ]
            [ node "sl-color-picker" [ value model.color, onInputString ChangeColor ] []
            , text "Color value"
            , node "sl-input" [ value model.color, onInputString ChangeColor, pill ] []
            ]
        , h3 [] [ text "Tooltip" ]
        , p [] [ node "sl-tooltip" [ onClick (ChangeDrawerOpen True), content "This is a tooltip" ] [ node "sl-button" [ pill ] [ text "Hover Me" ] ] ]
        , h3 [] [ text "Date Input Field" ]
        , p [ style "display" "flex" ] [ node "sl-input" [ pill, type_ "date", placeholder "Date", value model.date, onInputString ChangeDate ] [] ]
        , h3 [] [ text "Carousel with Switch that changes the Carousel Navigation" ]
        , node "sl-button" [ style "margin-bottom" "1rem", pill, onClick (ChangeCarouselNavigation (not model.carouselNavigation)) ] [ node "sl-switch" [ slot "suffix", checked model.carouselNavigation ] [], text "Navigation" ]
        , node "sl-carousel"
            [ mouseDragging
            , loop
            , attrIf { condition = model.carouselNavigation, key = "pagination" }
            , attrIf { condition = model.carouselNavigation, key = "navigation" }
            , attrValueIf { condition = not model.carouselNavigation, key = "style", value = "--scroll-hint: 10%; --slide-gap: 5px" }
            ]
            [ carouselItem "mountains", carouselItem "waterfall", carouselItem "sunset", carouselItem "field", carouselItem "valley" ]
        ]


carouselItem : String -> Html msg
carouselItem name =
    node "sl-carousel-item" [] [ img [ alt name, src ("https://shoelace.style/assets/examples/carousel/" ++ name ++ ".jpg") ] [] ]


viewDate : String -> Html msg
viewDate language =
    li []
        [ text language
        , text ": "
        , node "sl-format-date"
            [ month "long"
            , day "numeric"
            , year "numeric"
            , lang language
            ]
            []
        ]


assetsUrl : String
assetsUrl =
    "https://lucamug.github.io/elm-web-components/images/"


view : Model -> Html Msg
view model =
    div []
        [ div [ style "margin" "20px" ]
            [ h1 [ class "wrapped" ]
                [ img [ style "width" "200px", src (assetsUrl ++ "wordmark.svg") ] []
                , span [ style "font-size" "50px", style "color" "#0d94d8" ] [ text " ╳ " ]
                , img [ style "height" "60px", src (assetsUrl ++ "elm-logo-2.png") ] []
                ]
            , p []
                [ text "A random collection of interactive web components from the "
                , a [ target "_blank", href "https://shoelace.style/" ] [ text "Shoelace" ]
                , text " library glued together using "
                , a [ target "_blank", href "https://elm-lang.org/" ] [ text "Elm" ]
                , text "."
                ]
            , ul []
                [ li []
                    [ a [ target "_blank", href "https://github.com/lucamug/elm-web-components/blob/master/src/Main.elm" ] [ text "Code" ]
                    , text ", "
                    , a [ target "_blank", href "https://ellie-app.com/nNbgNpbfKHZa1" ] [ text "Code on-line (Ellie)" ]
                    , text ", "
                    , text "Version: "
                    , text version
                    , text ""
                    ]
                , li [] [ text "The Elm Debugger at the bottom right corner has been left active for testing purposes" ]
                , li []
                    [ text "State: "
                    , text <| Debug.toString model
                    ]
                ]
            ]
        , node "sl-tab-group"
            []
            [ node "sl-tab" [ slot "nav", panel "split" ] [ text "Split Themes" ]
            , node "sl-tab" [ slot "nav", panel "light" ] [ text "Theme Light" ]
            , node "sl-tab" [ slot "nav", panel "dark" ] [ text "Theme Dark" ]
            , node "sl-tab-panel"
                [ name "split" ]
                [ node "sl-split-panel"
                    [ css "--divider-width: 20px" ]
                    [ node "sl-icon" [ slot "divider", name "grip-vertical" ] []
                    , div [ slot "start", css "overflow: hidden; margin-left: 20px" ] [ viewCard "sl-theme-light" model ]
                    , div [ slot "end", css "overflow: hidden; margin-right: 20px" ] [ viewCard "sl-theme-dark" model ]
                    ]
                ]
            , node "sl-tab-panel" [ name "light" ] [ viewCard "sl-theme-light" model ]
            , node "sl-tab-panel" [ name "dark" ] [ viewCard "sl-theme-dark" model ]
            ]
        , node "sl-drawer"
            [ attrIf { condition = model.drawerOpen, key = "open" }, onEvent "sl-hide" (ChangeDrawerOpen False), placement "start" ]
            [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            , node "sl-button" [ class "closeButton", slot "footer", onClick (ChangeDrawerOpen False), pill, variant "primary" ] [ text "Close" ]
            ]
        ]



-- THE ELM ARCHITECTURE


type alias Model =
    { carouselNavigation : Bool, date : String, color : String, rating : String, drawerOpen : Bool }


init : Model
init =
    { carouselNavigation = True, date = "", color = "", rating = "", drawerOpen = False }


type Msg
    = ChangeCarouselNavigation Bool
    | ChangeRatingAsFloat Float
    | ChangeRatingAsString String
    | ChangeDrawerOpen Bool
    | ChangeColor String
    | ChangeDate String


update : Msg -> Model -> Model
update msg model =
    case msg |> Debug.log "msg" of
        ChangeCarouselNavigation bool ->
            { model | carouselNavigation = bool }

        ChangeColor string ->
            { model | color = string }

        ChangeDate string ->
            { model | date = string }

        ChangeRatingAsFloat float ->
            { model | rating = String.fromFloat float }

        ChangeRatingAsString string ->
            { model | rating = string }

        ChangeDrawerOpen bool ->
            { model | drawerOpen = bool }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- EVENT HELPERS


onInputString : (String -> Msg) -> Attribute Msg
onInputString msg =
    onEventGeneric "sl-input" msg Json.Decode.string


onChangeFloat : (Float -> Msg) -> Attribute Msg
onChangeFloat msg =
    onEventGeneric "sl-change" msg Json.Decode.float


onEventGeneric : String -> (a -> Msg) -> Json.Decode.Decoder a -> Attribute Msg
onEventGeneric eventName msg decoder =
    decoder
        |> Json.Decode.at [ "target", "value" ]
        |> Json.Decode.map msg
        |> Html.Events.on eventName


onEvent : String -> Msg -> Attribute Msg
onEvent eventName msg =
    msg
        |> Json.Decode.succeed
        |> Html.Events.on eventName



-- ATTRIBUTE HELPERS


attr : String -> Attribute msg
attr string =
    attribute string "true"


attrValueIf : { condition : Bool, key : String, value : String } -> Attribute msg
attrValueIf { condition, key, value } =
    if condition then
        attribute key value

    else
        classList []


attrIf : { condition : Bool, key : String } -> Attribute msg
attrIf { condition, key } =
    attrValueIf { condition = condition, key = key, value = "true" }


pill : Attribute msg
pill =
    attr "pill"


open : Attribute msg
open =
    attr "open"


mouseDragging : Attribute msg
mouseDragging =
    attr "mouse-dragging"


loop : Attribute msg
loop =
    attr "loop"


slot : String -> Attribute msg
slot =
    attribute "slot"


panel : String -> Attribute msg
panel =
    attribute "panel"


precision : String -> Attribute msg
precision =
    attribute "precision"


css : String -> Attribute msg
css =
    attribute "style"


content : String -> Attribute msg
content =
    attribute "content"


month : String -> Attribute msg
month =
    attribute "month"


day : String -> Attribute msg
day =
    attribute "day"


year : String -> Attribute msg
year =
    attribute "year"


lang : String -> Attribute msg
lang =
    attribute "lang"


placement : String -> Attribute msg
placement =
    attribute "placement"


variant : String -> Attribute msg
variant =
    attribute "variant"
