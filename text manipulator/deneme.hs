isCapital' :: Char -> Bool
isCapital' c = (c `elem` ['A'..'Z'])

trLower :: Char -> Char
trLower   c =
    let mappingList  = zip ['A'..'Z'] ['a'..'z']
    in  case lookup c mappingList of
        Just lowerChar -> lowerChar
        Nothing        -> c


normalizeText :: String -> String

normalizeText str = [if isCapital' s then trLower s else s | s <- str]
