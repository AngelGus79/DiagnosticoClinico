module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material
import Material.Button as Button
import Material.Color as Color
import Material.Dialog as Dialog
import Material.Icon as Icon
import Material.Layout as Layout
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (css)
import Material.Scheme
import Material.Toggles as Toggles
import Model exposing (..)


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Color.Teal Color.DeepOrange <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedDrawer
            , Layout.fixedHeader
            , Layout.onSelectTab LoadBodyLocations
            , Layout.selectedTab model.selectedTab
            ]
            { header = [ div [] [ h1 [] [ text "Programa médico" ] ] ]
            , drawer =
                [ div []
                    [ img [ src "https://getmdl.io/templates/dashboard/images/user.jpg" ] []
                    ]
                , div [] [ viewPartesSel model ]
                ]
            , tabs = ( [ text "Parte general del cuerpo", text "Parte específica del cuerpo", text "Síntomas", text "Sugerencia" ], [] )
            , main = [
                   div [] (sessionOrBody model)
                  ]
            }

sessionOrBody : Model -> List (Html Msg)
sessionOrBody model = 
  case model.bodyLocations of
    [] -> [
            Html.button [onClick (LoadBodyLocations 0)] [text "Iniciar"]
          ]
    _ -> [viewBody model]

viewBody : Model -> Html Msg
viewBody model =
    case model.selectedTab of
        0 ->
            viewBodyLocations model

        1 ->
            viewBodySubLocations model

        2 ->
            viewSymptoms model

        3 ->
          div [] (List.append (List.map viewDiagnosis model.diagnosis) [(text model.errorMsg)])

        _ ->
            text "404"

viewBodyLocations : Model -> Html Msg
viewBodyLocations model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        (button model.bodyLocations 1)


viewBodySubLocations : Model -> Html Msg
viewBodySubLocations model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        (button model.bodySubLocations 2)


viewSymptoms : Model -> Html Msg
viewSymptoms model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        (List.append (button model.symptoms 3)  botonEnviar)

botonEnviar : List (Html Msg)
botonEnviar = [Button.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onClick ComputeDiagnosis
        , Button.raised
        , Button.colored
        , css "margin" "0 24px"
        ]
        [ text "Enviar" ]]

button : List Data -> Int -> List (Html Msg)
button partes tab =
    case tab of
        1 ->
            List.map2 toButton1 (List.map (\ x -> x.name) partes) (List.map (\ x -> x.id) partes)

        2 ->
            List.map2 toButton2 (List.map (\ x -> x.name) partes) (List.map (\ x -> x.id) partes)

        3 ->
            List.map2 toButton3 (List.map (\ x -> x.name) partes) (List.map (\ x -> x.id) partes)

        _ ->
            List.map2 toButton1 (List.map (\ x -> x.name) partes) (List.map (\ x -> x.id) partes)


check : List String -> List Bool -> List (Html Msg)
check partes selec =
    List.map2 toButton4 partes selec


toButton1 : String -> Int -> Html Msg
toButton1  cadena id =
    Button.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onClick (LoadSubBodyLocations id cadena)
        , css "margin" "0 24px"
        ]
        [ text cadena ]


toButton2 : String -> Int -> Html Msg
toButton2 cadena id =
    Button.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onClick (LoadSymptoms id cadena)
        , css "margin" "0 24px"
        ]
        [ text cadena ]


toButton3 : String -> Int -> Html Msg
toButton3 cadena id =
    Button.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onClick (SelectSymptom id cadena)
        , css "margin" "0 24px"
        ]
        [ text cadena ]


toButton4 : String -> Bool -> Html Msg
toButton4 cadena sel =
    Toggles.checkbox Mdl
        [ 0 ]
        model.mdl
        [ Options.onToggle (Seleccionar cadena 4)
        , Toggles.ripple
        , Toggles.value sel
        ]
        [ text cadena ]


viewPartesSel : Model -> Html Msg
viewPartesSel model =
    div []
        [ h4 []
            [ text "Partes del cuerpo" ]
        , Lists.ul []
            [ Lists.li [] [ Lists.content [] [ text model.part ] ]
            , Lists.li [] [ Lists.content [] [ text model.subpart ] ]
            ]
        , h4 []
            [ text "Síntomas" ]
        , Lists.ul []
            (List.map sintomas model.selectedSymptomsS)
        ]

sintomas: String -> Html Msg
sintomas nombre =  Lists.li [] [ Lists.content [] [ text nombre ]]

viewSearchResult : Data -> Html Msg
viewSearchResult result =
    li []
        [ div []
            [ a [ href "#", onClick (LoadSubBodyLocations result.id result.name) ] [ text result.name ]
            ]
        ]


viewSubpartes : Data -> Html Msg
viewSubpartes result =
    li []
        [ div []
            [ a [ href "#", onClick (LoadSymptoms result.id result.name) ] [ text result.name ]
            ]
        ]


viewDiagnosis : General -> Html Msg
viewDiagnosis result =
    li []
        [ text ("Probable padecimiento: " ++ result.issue.name ++ ", con presición del: " ++ toString result.issue.accuracy ++ "%")
        ]


