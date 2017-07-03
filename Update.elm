module Main exposing (..)
import Debug exposing (..)
import Html as H exposing (Html)
import Http 
import View exposing (..)
import Model exposing (..)
import Auth exposing (..)
import Material

main =
    H.program
        { init = (model,  Http.send Token (getProtectedQuote model))
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


getProtectedQuote : Model -> Http.Request String
getProtectedQuote model =
    Http.request
        { method = "POST"
        , headers = [ Http.header "Authorization" ("Bearer " ++ username ++ ":" ++ password) ]
        , url = priaid_authservice_url
        , body = Http.emptyBody
        , expect = Http.expectJson tokenDecoder
        , timeout = Nothing
        , withCredentials = False
        }


getData : String -> Http.Request (List Data)
getData url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }


getDiagnosisData : String -> Http.Request (List General)
getDiagnosisData url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson diagnosisDecoder
        , timeout = Nothing
        , withCredentials = False
        }


creaUrl : Model -> String -> String
creaUrl model action =
    let
        url =
            priaid_healthservice_url
    in
    if not (String.contains "?" action) then
        url ++ "/" ++ action ++ "?token=" ++ model.token ++ "&format=json&language=" ++ language
    else
        url ++ "/" ++ action ++ "&token=" ++ model.token ++ "&format=json&language=" ++ language



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeName nam->
            let
                _ = Debug.log "Nombre " model.name
            in
            ({ model | name = nam}, Cmd.none)
        ChangeAge age->
            ({ model | age = age}, Cmd.none)
        GetToken ->
            ( { model | selectedSymptoms = [] }
            , Http.send Token (getProtectedQuote model)
            )

        Token (Ok token) ->
            
             let
                 token_ =
                     token
                 
              in           
            ({ model | token = token_, selectedSymptoms = [] }, Cmd.none)


        Token (Err err) ->
            ( { model | token = "Error: " ++ toString err, selectedSymptoms = [] }
            , Cmd.none
            )

        LoadBodyLocations n ->
            ( { model | selectedSymptoms = []
                , selectedSymptomsS = []
                , part = "----"
                , subpart = "----"
                , selectedTab = 1 }
            , Http.send BodyLocations (getData (creaUrl model "body/locations"))
            )

        BodyLocations (Ok bodyLocations) ->
            ( { model | bodyLocations = bodyLocations, selectedSymptoms = [] }, Cmd.none )

        BodyLocations (Err err) ->
            ( { model | errorMsg = toString err, selectedSymptoms = [] }, Cmd.none )

        LoadSubBodyLocations id cadena->
            let
                path =
                    "body/locations/" ++ toString id
            in
            ( { model | selectedSymptoms = [], selectedTab = 2 , part = cadena}
            , Http.send SubBodyLocations (getData (creaUrl model path))
            )

        SubBodyLocations (Err err) ->
            ( { model | errorMsg = toString err, selectedSymptoms = [] }
            , Cmd.none
            )

        SubBodyLocations (Ok bodySubLocations) ->
            ( { model | bodySubLocations = bodySubLocations, selectedSymptoms = [] }, Cmd.none )

        LoadSymptoms idSubLocation cadena->
            let
                path =
                    "symptoms/" ++ toString idSubLocation ++ "/Man"
            in
            ( { model | selectedSymptoms = [], selectedTab = 3 ,subpart = cadena}, Http.send Symptoms (getData (creaUrl model path)) )

        Symptoms (Err err) ->
            ( { model | errorMsg = toString err, selectedSymptoms = [] }, Cmd.none )

        Symptoms (Ok symptoms) ->
            ( { model | symptoms = symptoms, selectedSymptoms = [] }, Cmd.none )

        SelectSymptom id cadena ->
            let
                idSelected =
                    id
            in
            if List.member idSelected model.selectedSymptoms then
                ( { model | selectedSymptoms = List.filter (\x -> x /= idSelected) model.selectedSymptoms 
                    , selectedSymptomsS = List.filter (\x -> x /= cadena) model.selectedSymptomsS}, Cmd.none )
            else
                ( { model | selectedSymptoms = idSelected :: model.selectedSymptoms
                ,selectedSymptomsS = cadena :: model.selectedSymptomsS }, Cmd.none )

        ComputeDiagnosis ->
            let
                sSymptoms =
                    toString model.selectedSymptoms

                path =
                    "diagnosis?symptoms=" ++ sSymptoms ++ "&gender=Male&year_of_birth=1988"
            in
            ( {model| selectedTab = 4}, Http.send Diagnosis (getDiagnosisData (creaUrl model path)) )

        Diagnosis (Ok diagnosis) ->
            ( { model | diagnosis = diagnosis }, Cmd.none )

        Diagnosis (Err err) ->
             { model | errorMsg = toString err
             }  ! []
        Seleccionar num ->
            if num < 4 then
                    ({model | selectedTab = num, selectedSymptoms = [], selectedSymptomsS = []}, Cmd.none )
            else
                ({model | selectedTab = num }, Cmd.none )
        Mdl msg_ ->
            Material.update Mdl msg_ model

        RadioMsg s ->
            ({model | sexo = s},Cmd.none)


