module Model exposing (..)
import Http
import Json.Decode.Pipeline exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Material

type alias Model =
    {
      mdl : Material.Model    
    , data : List Data
    , bodyLocations : List Data
    , bodySubLocations : List Data
    , symptoms : List Data
    , selectedSymptoms : List Int
    , diagnosis : List General
    , token : String
    , errorMsg : String
    , action : String
    , selectedTab : Int
    }

model : Model
model =   {
      mdl = Material.model    
    , data = []
    , bodyLocations = []      
    , bodySubLocations = []
    , symptoms = []
    , selectedSymptoms = []
    , diagnosis = []
    , token = ""
    , errorMsg = ""
    , action = ""
    , selectedTab = 0
    }
       
    
init : ( Model, Cmd Msg )
init =
    ( Model Material.model [] [] [] [] [] [] "" "" "" 0
    , Cmd.none
    )
    
type alias Data =
    { id : Int
    , name : String
    }


type alias DiagnosisData =
    { id : Int
    , name : String
    , accuracy : Float
    }


type alias General =
    { issue : DiagnosisData
    }


diagnosisDataDecoder : Decoder DiagnosisData
diagnosisDataDecoder =
    decode DiagnosisData
        |> required "ID" Decode.int
        |> required "Name" Decode.string
        |> required "Accuracy" Decode.float


diagnosisGeneralDecoder : Decoder General
diagnosisGeneralDecoder =
    decode General
        |> required "Issue" diagnosisDataDecoder


diagnosisDecoder : Decoder (List General)
diagnosisDecoder =
    Decode.at [] (Decode.list diagnosisGeneralDecoder)


searchResultDecoder : Decoder Data
searchResultDecoder =
    decode Data
        |> required "ID" Decode.int
        |> required "Name" Decode.string


responseDecoder : Decoder (List Data)
responseDecoder =
    Decode.at [] (Decode.list searchResultDecoder)


tokenDecoder : Decoder String
tokenDecoder =
    Decode.field "Token" Decode.string

type Msg
    = GetToken
    | Token (Result Http.Error String)
    | LoadBodyLocations
    | BodyLocations (Result Http.Error (List Data))
    | LoadSubBodyLocations Int
    | SubBodyLocations (Result Http.Error (List Data))
    | LoadSymptoms Int
    | Symptoms (Result Http.Error (List Data))
    | SelectSymptom Int
    | ComputeDiagnosis
    | Diagnosis (Result Http.Error (List General))
    | SelectTab Int  
    | Seleccionar String Int
    | Mdl (Material.Msg Msg)  
