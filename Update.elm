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

        LoadBodyLocations ->
            ( { model | selectedSymptoms = [] }
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
            ( { model | selectedSymptoms = [], selectedTab = 1 , part = cadena}
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
            ( { model | selectedSymptoms = [], selectedTab = 2 ,subpart = cadena}, Http.send Symptoms (getData (creaUrl model path)) )

        Symptoms (Err err) ->
            ( { model | errorMsg = toString err, selectedSymptoms = [] }, Cmd.none )

        Symptoms (Ok symptoms) ->
            ( { model | symptoms = symptoms, selectedSymptoms = [] }, Cmd.none )

        SelectSymptom id ->
            let
                idSelected =
                    id
            in
            if List.member idSelected model.selectedSymptoms then
                ( { model | selectedSymptoms = List.filter (\x -> x /= idSelected) model.selectedSymptoms }, Cmd.none )
            else
                ( { model | selectedSymptoms = idSelected :: model.selectedSymptoms }, Cmd.none )

        ComputeDiagnosis ->
            let
                sSymptoms =
                    toString model.selectedSymptoms

                path =
                    "diagnosis?symptoms=" ++ sSymptoms ++ "&gender=Male&year_of_birth=1988"
            in
            ( model, Http.send Diagnosis (getDiagnosisData (creaUrl model path)) )

        Diagnosis (Ok diagnosis) ->
            ( { model | diagnosis = diagnosis }, Cmd.none )

        Diagnosis (Err err) ->
             { model | errorMsg = toString err
             }  ! []
        SelectTab num -> 
            (model,  Http.send Token (getProtectedQuote model))
        Seleccionar sel num ->
            let
                _ = Debug.log "seleccionados:" sel
            in 
            case num of 
             {-   1 -> 
                    ({model | selectedTab = num  }, Cmd.none ) -}
                2 -> 
                    ({model | selectedTab = num  }, Cmd.none )
                3 -> 
                    ({model | selectedTab = num  }, Cmd.none )
                _ -> 
                    ({model | selectedTab = num  }, Cmd.none )
        Mdl msg_ ->
            Material.update Mdl msg_ model


