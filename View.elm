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
            , Layout.onSelectTab SelectTab
            , Layout.selectedTab model.selectedTab
            ]
            { header = [ div [] [ h1 [] [ text "Programa médico" ] ] ]
            , drawer =
                [ div []
                    [ img [ src "https://getmdl.io/templates/dashboard/images/user.jpg" ] []
                    ]
                , div [] [ viewPartesSel model ]
                ]
            , tabs = ( [ text "Parte general del cuerpo", text "Parte específica del cuerpo", text "Síntoma", text "Síntomas propuestos", text "Sugerencia" ], [] )
            , main = [
                   div [] [
                        Html.button [onClick LoadBodyLocations ] [text "iniciar"]
                       ]
                   , viewBody model
                  ]
            }


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
            viewSintomas2 model

        4 ->
            text "Aqui va el resultado"

        _ ->
            text "404"


viewBodyLocations : Model -> Html Msg
viewBodyLocations model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        (button (List.map (\x -> x.name) model.bodyLocations) 1)


viewBodySubLocations : Model -> Html Msg
viewBodySubLocations model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        (button (List.map (\ x -> x.name) model.bodySubLocations ) 2)


viewSymptoms : Model -> Html Msg
viewSymptoms model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        (button (List.map(\ x -> x.name) model.symptoms) 3)


viewSintomas2 : Model -> Html Msg
viewSintomas2 model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        (check [ "Sintoma P1", "Sintoma P2", "Sintoma P3" ] [ False, False, False ])


button : List String -> Int -> List (Html Msg)
button partes tab =
    case tab of
        1 ->
            List.map toButton1 partes

        2 ->
            List.map toButton2 partes

        3 ->
            List.map toButton3 partes

        _ ->
            List.map toButton1 partes


check : List String -> List Bool -> List (Html Msg)
check partes selec =
    List.map2 toButton4 partes selec


toButton1 : String -> Html Msg
toButton1  cadena =
    Button.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onClick (LoadSubBodyLocations 7)
        , css "margin" "0 24px"
        ]
        [ text cadena ]


toButton2 : String -> Html Msg
toButton2 cadena =
    Button.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onClick (LoadSymptoms 48)
        , css "margin" "0 24px"
        ]
        [ text cadena ]


toButton3 : String -> Html Msg
toButton3 cadena =
    Button.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onClick (Seleccionar cadena 3)
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


viewPartesSel : Model -> Html msg
viewPartesSel model =
    div []
        [ h4 []
            [ text "Partes del cuerpo" ]
        , Lists.ul []
            [ Lists.li [] [ Lists.content [] [ text "parte1" ] ]
            , Lists.li [] [ Lists.content [] [ text "parte2" ] ]
            ]
        , h4 []
            [ text "Síntomas" ]
        , Lists.ul []
            [ Lists.li [] [ Lists.content [] [ text "Sintoma1" ] ]
            , Lists.li [] [ Lists.content [] [ text "Sintoma2" ] ]
            ]
        ]


viewSearchResult : Data -> Html Msg
viewSearchResult result =
    li []
        [ div []
            [ a [ href "#", onClick (LoadSubBodyLocations result.id) ] [ text result.name ]
            ]
        ]


viewSubpartes : Data -> Html Msg
viewSubpartes result =
    li []
        [ div []
            [ a [ href "#", onClick (LoadSymptoms result.id) ] [ text result.name ]
            ]
        ]


{-viewSymptoms : Data -> Html Msg
viewSymptoms result =
    li []
        [ div []
            [ input [ attribute "unchecked" "", type_ "checkbox", onClick (SelectSymptom result.id) ] []
            , text result.name
            , br [] []
            ]
        ]
-}

viewDiagnosis : General -> Html Msg
viewDiagnosis result =
    li []
        [ text ("Probable padecimiento: " ++ result.issue.name ++ ", con presición del: " ++ toString result.issue.accuracy ++ "%")
        ]



{-
   type alias Mdl =
       Material.Model

   view : Model -> Html Msg
   view model =
       Material.Scheme.topWithScheme Color.Teal Color.DeepOrange
       <| Layout.render Mdl
           model.mdl
               [ Layout.fixedDrawer
               , Layout.fixedHeader
               , Layout.onSelectTab SelectTab
               , Layout.selectedTab model.selectedTab
               ]
               {header = [div [] [h1 [] [text "Programa médico"]]]
                   , drawer = [div []
                       [img [src "https://getmdl.io/templates/dashboard/images/user.jpg"] []
                       ],div [] [viewPartesSel model] ]
                   , tabs = ([text "Parte general del cuerpo", text "Parte específica del cuerpo" , text "Síntoma", text "Síntomas propuestos", text "Sugerencia"] , [])
                   , main = [viewBody model]
               }

   viewBody : Model -> Html Msg
   viewBody model =
       case model.selectedTab of
           0 -> viewPartes model
           1 -> viewPartes2 model
           2 -> viewSintomas1 model
           3 -> viewSintomas2 model
           4 -> text "Aqui va el resultado"
           _ -> text "404"


   viewPartes : Model -> Html Msg
   viewPartes model =
       div
           [ style [ ( "padding", "2rem" ) ] ]
           (button ["Parte 1","Parte 2","Parte 3"] 1)

   viewPartes2 : Model -> Html Msg
   viewPartes2 model =
       div
           [ style [ ( "padding", "2rem" ) ] ]
           (button ["Parte C1","Parte C2","Parte C3"] 2)

   viewSintomas1 : Model -> Html Msg
   viewSintomas1 model =
       div
           [ style [ ( "padding", "2rem" ) ] ]
           (button ["Sintoma 1","Sintoma 2","Sintoma 3"] 3)

   viewSintomas2 : Model -> Html Msg
   viewSintomas2 model =
       div
           [ style [ ( "padding", "2rem" ) ] ]
           (check ["Sintoma P1","Sintoma P2","Sintoma P3"] [False,False,False])

   button : List (String) -> Int -> List (Html Msg)
   button partes tab =
       case tab of
           1 -> List.map toButton1 partes
           2 -> List.map toButton2 partes
           3 -> List.map toButton3 partes
           _ -> List.map toButton1 partes

   check : List (String) -> List (Bool) -> List (Html Msg)
   check partes selec= List.map2 toButton4 partes selec


   toButton1: String -> Html Msg
   toButton1 cadena = Button.render Mdl
               [ 0 ]
               model.mdl
               [ Options.onClick (Seleccionar cadena 1)
               , css "margin" "0 24px"
               ]
               [ text cadena ]

   toButton2: String -> Html Msg
   toButton2 cadena = Button.render Mdl
               [ 0 ]
               model.mdl
               [ Options.onClick (Seleccionar cadena 2)
               , css "margin" "0 24px"
               ]
               [ text cadena ]
   toButton3: String -> Html Msg
   toButton3 cadena = Button.render Mdl
               [ 0 ]
               model.mdl
               [ Options.onClick (Seleccionar cadena 3)
               , css "margin" "0 24px"
               ]
               [ text cadena ]

   toButton4: String -> Bool-> Html Msg
   toButton4 cadena sel= Toggles.checkbox Mdl [0] model.mdl
     [ Options.onToggle (Seleccionar cadena 4)
     , Toggles.ripple
     , Toggles.value sel
     ]
     [ text cadena ]


   viewPartesSel : Model -> Html msg
   viewPartesSel model = div []
       [ h4 []
           [text "Partes del cuerpo"]
           ,Lists.ul []
           [Lists.li [] [ Lists.content [] [ text model.parte1 ] ]
           ,Lists.li [] [ Lists.content [] [ text model.parte2 ] ]
           ]
       , h4 []
           [text "Síntomas"]
           ,Lists.ul []
           [Lists.li [] [ Lists.content [] [ text model.sintoma1 ] ]
           ,Lists.li [] [ Lists.content [] [ text model.sintoma2 ] ]
           ]
       ]

-}