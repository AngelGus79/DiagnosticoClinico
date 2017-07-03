module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material
import Regex
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
import Material.Textfield as Textfield
import Material.Table as Table


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Color.Teal Color.DeepOrange <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedDrawer
            , Layout.fixedHeader
            , Layout.onSelectTab Seleccionar
            , Layout.selectedTab model.selectedTab
            ]
            { header = [ div [] [ h2 [] [ text "Mi médico de cabecera" ] ] ]
            , drawer =
                [ div []
                    [ img [ src "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4XbGu5kVQ8bPMB4eD9_01Xw1Rt4cl-U74FhtL3UtKdE_Y6gkPYg" ] []
                    ]
                , div [] [ viewPartesSel model ]
                ]
            , tabs = ( [ text "Datos personales", text "Parte del cuerpo", text "Parte específica del cuerpo", text "Síntomas", text "Sugerencia" ], [] )
            , main = [
                   div [] [(viewBody model)]
                  ]
            }

viewBody : Model -> Html Msg
viewBody model =
    case model.selectedTab of
        0 ->
            viewData model
        1 ->
            viewBodyLocations model

        2 ->
            viewBodySubLocations model

        3 ->
            viewSymptoms model

        4 ->
          div [style [ ( "margin", "0 auto" ) ]] 
          [ h6 [] [text (model.name ++ ", usted probablemente padece: ")]
          , Table.table []
            [ Table.thead []
              [ Table.tr []
                [ Table.th [] [ text "Posible padecimiento" ]
                , Table.th [ ] [ text "Precisión" ]
                ]
              ]
            , Table.tbody [] 
                  (List.map viewDiagnosis model.diagnosis)
            ]
          ]

--(List.append (List.map viewDiagnosis model.diagnosis) [(text model.errorMsg)])
        _ ->
            text "404"

viewData : Model -> Html Msg
viewData model = div [] 
          [Lists.ul []
            [ h3 [] [text "Ingresa tus datos"]
            , Lists.li []
              [Lists.content []
                [ (Textfield.render Mdl [0] model.mdl
                  [ Textfield.label "Escribe tu nombre"
                  , Textfield.floatingLabel
                  , Textfield.value model.name
                  , Options.onInput ChangeName 
                  ] []
                  )
                ]
              ]
            ]
          , Lists.li []
              [Lists.content []
                [ (Textfield.render Mdl [1] model.mdl
                  [ Textfield.label "Año de nacimiento"
                  , Textfield.floatingLabel
                  , Textfield.value model.age
                  , Options.onInput ChangeAge
                  , Textfield.error ("No es un numero")
                      |> Options.when (not <| match model.age (Regex.regex "[0-9]*"))
                  ] []
                  )
                ]
              ]
          , Lists.li []
              [Lists.content []
                [ (Toggles.radio Mdl [0] model.mdl
                  [ Toggles.value (isMale model.gender)
                  , Toggles.group "sexo"
                  , Toggles.ripple
                  , Options.onToggle (RadioMsg "Male")
                  ]
                  [ text "Hombre" ]
                  )
                , (Toggles.radio Mdl [1] model.mdl
                  [ Toggles.value (not(isMale model.gender))
                  , Toggles.group "sexo"
                  , Toggles.ripple
                  , Options.onToggle (RadioMsg "Female")
                  ]
                  [ text "Mujer" ]
                  )
                ]
              ]
          , Lists.li []
              [Lists.content []
                [ (Button.render Mdl [0] model.mdl
                  [ Button.raised
                  , Button.ripple
                  , Options.onClick (LoadBodyLocations 1)
                  ]
                  [ text "Iniciar consulta" ]
                  )
                ]
              ]
          

          ]

isMale:  String -> Bool
isMale sexo =
        if sexo == "Male" then
          True
        else
          False

match : String -> Regex.Regex -> Bool
match str rx =
  Regex.find Regex.All rx str
    |> List.any (.match >> (==) str)

viewBodyLocations : Model -> Html Msg
viewBodyLocations model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        ((h3 [] [text "¿Que parte del cuerpo le duele?"])::(button model.bodyLocations 1))


viewBodySubLocations : Model -> Html Msg
viewBodySubLocations model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        ((h3 [] [text "¿Que subparte del cuerpo le duele?"])::(button model.bodySubLocations 2))


viewSymptoms : Model -> Html Msg
viewSymptoms model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        ((h3 [] [text "¿Que síntomas presenta?"])::(List.append (button model.symptoms 3)  botonEnviar))

botonEnviar : List (Html Msg)
botonEnviar = [Button.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onClick ComputeDiagnosis
        , Button.raised
        , Button.colored
        , css "margin" "0 24px"
        ]
        [ text "Diagnosticar" ]]

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




toButton1 : String -> Int -> Html Msg
toButton1  cadena id =
    Button.render Mdl
        [ 0 ]
        model.mdl
        [ Options.onClick (LoadSubBodyLocations id cadena)
        , css "margin" "0 24px"
        ]
        [
       
        text cadena ]


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



viewPartesSel : Model -> Html Msg
viewPartesSel model =
    div []
        [ h6 [ ]
            [ text "Partes del cuerpo" ]
        , Lists.ul []
            [ Lists.li [] [ Lists.content [] [ text model.part ] ]
            , Lists.li [] [ Lists.content [] [ text model.subpart ] ]
            ]
        , h6 []
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
viewDiagnosis result = Table.tr []
                  [ Table.td []
                        [
                         h4 [] [ text result.issue.name]
                        ]
                  , Table.td [ Table.numeric ]
                      [
                       h4 [] [text ((toString (round result.issue.accuracy)) ++ " %"  )]
                      ]
                  ]


