module Main where
import Database
import Download
import Types
import System.Environment


{- | Start. -}
main :: IO ()
main = 
   do args <- getArgs
      case args of 
         ["download"] -> initialise
         ["update", "capacity", stadiumName, capacity] -> updateCapacity stadiumName capacity  
         ["details", "stadium", stadiumName] -> getDetails stadiumName
         ["list", "stadium", city] -> getStadiums city
         _ -> syntaxError -- invalid or no input argument(s)

{- | Download data, initialise the database and enter data to the database. -}
initialise =
   do initialiseDB -- initialise database
      downloadData "stadiums_20150302" -- download data

{- | Get details of a stadium. Input arguments: city - "Stamford Bridge "-}
getDetails stadiumName = 
   do stadiumDetails <- getStadiumDetailsDB stadiumName
      mapM_ putStrLn $ stadiumDetails

{- | Get stadiums in a city. Input arguments: city - "London ". -}
getStadiums city =
   do stadiumList <- getStadiumListDB city
      mapM_ putStrLn $ stadiumList

{- | Update the capacity of a stadium. Input arguments: name - "Victoria Park ", capacity - 300. -}
updateCapacity stadiumName capacity =
   do updateStadiumCapacityDB stadiumName capacity

{- | All available commands. Invokes at a invalid or no arugment case." -}
syntaxError = putStrLn
   "Usage: command [args]\n\
   \\n\
   \download                                    Downloads all the stadium data.\n\
   \details stadium <stadium name>              Details of a stadium.\n\
   \update capacity <stadium name> <capacity>   Updates the capacity of a stadium.\n\
   \list stadium <city>                         Lists stadiums in a city.\n"

{- | Downloads the data, formats the data and insert data to the datbase. -}
downloadData :: String -> IO ()
downloadData std = do
   putStrLn $ "Downloading data..."
   file <- downloadURL ("http://opisthokonta.net/wp-content/uploads/2015/03/"++ std ++".csv")
   putStrLn $ "Download successful. "
   case file of
      Right content -> do
         let datas = tail.lines $ content
         -- location data
         let locRecords = map (readLocation std) datas -- get location records
         mapM_ insertLocationDB locRecords -- insert data
         -- stadium data
         let stdRecords = map (readStadium std) datas -- get stadium records
         mapM_ insertStadiumDB stdRecords -- insert data      
         putStrLn $ "Data entered succesfully. "
         
      Left errorMsg -> print errorMsg