port module Test.Generated.Main496aafb3c4c5cf7d1e284a81de8ccea9 exposing (main)

import Tests

import Test.Runner.Node
import Test
import Json.Encode

port emit : ( String, Json.Encode.Value ) -> Cmd msg

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Tests" [Tests.all] ]
        |> Test.concat
        |> Test.Runner.Node.runWithOptions { runs = Nothing, reporter = Nothing, seed = Nothing, paths = []} emit