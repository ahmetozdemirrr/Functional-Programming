-- Functional Programming/text manipulator/main.hs --

-- remove punctuations -------------------------------------------------
removePunctuationsHelper :: Char -> Bool
removePunctuationsHelper c  = (c `elem` ['A'..'Z']
                            || c `elem` ['a'..'z']
                            || c `elem` [' ', '\n', '\t']
                            || c `elem` ['0'..'9'])

removePunctuations :: String -> String
removePunctuations str = [ s | s <- str, removePunctuationsHelper s ]
------------------------------------------------------------------------

-- normalize text ------------------------------------------------------
isCapital' :: Char -> Bool
isCapital' c = (c `elem` ['A'..'Z'])

trLower :: Char -> Char
trLower   c =
    let mappingList  = zip ['A'..'Z'] ['a'..'z']
    in  case lookup c mappingList of
        Just lowerChar -> lowerChar
        Nothing        -> c

ltrim :: String -> String
ltrim [] = []
ltrim (c:xs)
    | c == ' '    = ltrim xs
    | c == '\xA0' = ltrim xs
    | otherwise   = (c:xs)

rtrim :: String -> String
rtrim = reverse . ltrim . reverse

trim :: String -> String
trim = ltrim . rtrim

squashSpaces :: String -> String
squashSpaces []  = []
squashSpaces [x] = [x]
squashSpaces (x:' ':y:zs)
    |   x == ' '    = squashSpaces (' ':y:zs)
    |   otherwise   = x : squashSpaces (' ':y:zs)
squashSpaces (x:xs) = x : squashSpaces xs

normalizeText :: String -> String
normalizeText []  =  "This string is empty!\n"
normalizeText str =
    let trimmedStr  = trim str
        squashedStr = squashSpaces trimmedStr
        loweredStr  = [ if isCapital' s
                        then trLower s
                        else s
                        | s <- squashedStr ]
    in loweredStr
------------------------------------------------------------------------
