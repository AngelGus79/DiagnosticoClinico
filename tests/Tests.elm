module Tests exposing (..)

import Test exposing (..)
import Fuzz exposing (..)
import Expect exposing (Expectation)
import Json.Decode exposing (decodeString, Value, field, string)
import String


all : Test
all =
    describe "request"
        [test "realizar una peticion al servidor" <|
             \() ->
             let
                 json = "{'ValidThrough': 7200, 'Token': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFndXN0YXZvNzlAZ21haWw}"
              
                 tokenDecoder =
                     field "Token" Json.Decode.string
             
                 isErrorResult result =
                    case result of
                        Err _ ->
                           True
                        Ok _ ->
                           False
             in
                  json
                    |> decodeString tokenDecoder 
                    |> isErrorResult
                    |> Expect.true "Expected decoding an invalid response to return an Err."
                  
        ]
            

