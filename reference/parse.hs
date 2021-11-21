import Text.Parsec
import Text.Parsec.Char
import Text.Parsec.Token (lexeme, makeTokenParser)
import Text.Parsec.Language (emptyDef)
import Text.ParserCombinators.Parsec
import Data.Map
import Data.List

alloww = lexeme . makeTokenParser $ emptyDef

mapFst :: (a -> c) -> (a, b) -> (c, b)
mapFst func (a, b) = (func a, b)

stripUntil :: Int -> String -> (Int, String)
stripUntil x (c:rest) | c == ' ' && x > 0 = mapFst (+1) . stripUntil (x-1) $ rest
stripUntil _ str = (0, str)

levelOutWhitespace :: [String] -> [String]
levelOutWhitespace = recur maxBound
  where recur _ [] = []
        recur level (e:rest) = snd res : recur (fst res) rest
          where res = stripUntil level e
        

-- from nix lexer: ID          [a-zA-Z\_][a-zA-Z0-9\_\'\-]*
iden :: CharParser ()  String
iden = (:) <$> begin <*> many rest
  where
    begin_chars = ['a'..'z']++['A'..'Z']++"_"
    begin = oneOf begin_chars
    rest = oneOf (begin_chars ++ "'-")

attr :: CharParser ()  String
attr = iden <|> between (char '"') (char '"') iden

attrpath :: CharParser () [String]
attrpath = attr `sepBy` string "."

commentBlock :: CharParser ()  String
commentBlock =
  do res <- between (string "/*" <* spaces) (spaces *> string "*/") . many . noneOf $ "*/"
     return (processComment res)
  where processComment com = intercalate "\n" (head ls : levelOutWhitespace (tail ls))
          where ls = lines com


commentLine :: CharParser ()  String
commentLine = between (char '#' <* spaces) eol . many . noneOf $ "\n"

binding :: CharParser () (String, String)
binding =
  do key <- alloww attr
     alloww (char '=')
     value <- alloww . many . noneOf $ ";"
     alloww (char ';')
     return (key, value)

commentBinding = :wq


eol :: CharParser () Char
eol = oneOf "\n"

main =
  do c <- getContents
     case parse binding "(stdin)" c of
       Left e -> do putStrLn "Error parsing input:"
                    print e
       Right r -> print r
