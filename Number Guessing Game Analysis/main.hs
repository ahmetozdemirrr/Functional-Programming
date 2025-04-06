{- main.hs -}

------------------------------------------------------------------------------------------
distancePerRound :: [Int] -> [(String, [Int])] -> [(String, [Int])]

-- Normal process: 3 target, invalid guess list
distancePerRound [tar_1, tar_2, tar_3] ((name, [guess_1, guess_2, guess_3]) : rest) = 
    (name, [abs (guess_1 - tar_1), (abs (guess_2 - tar_2)), (abs (guess_3 - tar_3))])
    : distancePerRound [tar_1, tar_2, tar_3] rest

{-
    Base case for recursion, when our guess list 
    is finish the recursive call also must finish
-}
distancePerRound [tar_1, tar_2, tar_3] [] = [("Finished", [])]

-- Error: target and guess lists are empty
distancePerRound [] [] = [("Error: Empty target and guesses", [-2])]

-- Error: target list is empty also only one 
distancePerRound [] ((dummy_name, dummy_guess) : rest) = [("Error: Empty target", [-3])]

-- Error: all other cases
distancePerRound _ guesses = [("Error: Invalid input", [-4])]
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
bestRoundPlayer :: [(String, [Int])] -> [(Int, String)]

bestRoundPlayer ((name, [score_1, score_2, score_3]) 
                : (nextName, [next_1, next_2, next_3]) 
                : rest) = 
    let current = [(score_1, name), (score_2, name), (score_3, name)]
    -- Comparison: Keep if current scores are greater than the next one

    filtered = [
                    (score, name) | 
                    (score, name) <- current, 
                       score > next_1 
                    || score > next_2 
                    || score > next_3
                ] 
    in filtered ++ bestRoundPlayer ((nextName, [next_1, next_2, next_3]) : rest)

bestRoundPlayer [] = []

bestRoundPlayer [(name, [score_1, score_2, score_3])] = 
                [(score_1, name), (score_2, name), (score_3, name)]
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- Entry Point

main :: IO ()

main = do
    print $ bestRoundPlayer (distancePerRound [1, 2, 3] [("A", [4, 5, 6]), ("B", [0, 1, 2])])  
------------------------------------------------------------------------------------------
