module Types ( Stadium
            , Location
            , locResults
            , stdResults
            , team
            , fdcouk
            , city
            , name
            , capacity
            , latitude
            , longitude
            , country
            , stdCity
            , stdCountry
            , readStadium
           , readLocation
            ) where 

import Data.List
import Debug.Trace

{- | Stadium. -}
data Stadium = Stadium { stdResults :: String
                       , team :: String
                       , fdcouk :: String
                       , name :: String
                       , capacity :: Int
                       , latitude :: Double
                       , longitude :: Double
                       , stdCountry :: String  
                       , stdCity :: String                   
                       } deriving (Show,Eq,Read)

{- | Stadium. -}
data Location = Location { locResults :: String
                         , country :: String  
                         , city :: String
                         }

{- | Use a delimiter to parse a line to get the data. -}
breakAll :: Char -> String -> [String]
breakAll c line | elem c line = x : (breakAll c (tail xs))
                | otherwise = [line]
   where
      (x,xs) = break (==c) line

{- | Read stadium data. -}
readStadium :: String -> String -> Stadium
readStadium stdResults line = 
   Stadium  { stdResults = stdResults
            , team = tokens !! 0
            , fdcouk = tokens !! 1     
            , name = tokens !! 3
            , capacity = read (tokens !! 4) :: Int
            , latitude = read (tokens !! 5) :: Double
            , longitude = read (tokens !! 6) :: Double
            , stdCity = tokens !! 2
            , stdCountry = tokens !! 7
         }
   where
      tokens = breakAll ',' line

{- | Read location data. -}
readLocation :: String -> String -> Location
readLocation locResults line = 
   Location  {  locResults = locResults
              , city = tokens !! 2
              , country = tokens !! 7
          }
   where
      tokens = breakAll ',' line
