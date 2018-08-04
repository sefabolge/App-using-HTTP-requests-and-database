module Database (dbConnect,initialiseDB,insertStadiumDB, insertLocationDB, updateStadiumCapacityDB, getStadiumDetailsDB, getStadiumListDB) where 

import Database.HDBC
import Database.HDBC.Sqlite3
import Types

{- | Create database connection. -}
dbConnect :: IO Connection
dbConnect = do
   conn <- connectSqlite3 "dataStadium.db"
   return conn

{- | Initialise or prepare the databse tables. -}
initialiseDB :: IO ()
initialiseDB = do
   conn <- dbConnect
   tables <- getTables conn
   if not (elem "location" tables) then do -- if a table named "location" does not exist.
      -- create location table
      run conn "CREATE TABLE location (locationID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, country VARCHAR(40), city VARCHAR(40), unique(city))" []
      commit conn
   else do
      -- delete all data of location table
      run conn "DELETE FROM location" []
      commit conn

   if not (elem "stadium" tables) then do -- if a table named "stadium" does not exist.
      -- create stadium table
      run conn "CREATE TABLE stadium (stadiumID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, locationID INTEGER NOT NULL, team VARCHAR(40),fdcouk VARCHAR(40),  name VARCHAR(40),capacity INTEGER,latitude DOUBLE,longitude DOUBLE, FOREIGN KEY(locationID) REFERENCES location(locationID), unique(name))" []
      commit conn
   else do
      -- delete all data of stadium
      run conn "DELETE FROM stadium" []
      commit conn
   
   putStrLn $ "Database created succesfully. "
   disconnect conn

{- | Insert data into the stadium table. -}
insertStadiumDB :: Stadium -> IO ()
insertStadiumDB stadiumStr = do
   conn <- dbConnect
   let query = "INSERT OR IGNORE INTO stadium (locationID, team,fdcouk,name,capacity,latitude,longitude) VALUES ((SELECT locationID from location WHERE city = ? AND country = ?),?,?,?,?,?,?) "
   let record = [    
                  toSql.stdCity $ stadiumStr    
                , toSql.stdCountry $ stadiumStr        
                , toSql.team $ stadiumStr
                , toSql.fdcouk $ stadiumStr   
                , toSql.name $ stadiumStr
                , toSql.capacity $ stadiumStr
                , toSql.latitude $ stadiumStr
                , toSql.longitude $ stadiumStr                
                ]
   run conn query record 
   commit conn
   disconnect conn

{- | Insert data into location table. -}
insertLocationDB :: Location -> IO ()
insertLocationDB location = do
   conn <- dbConnect
   let query = "INSERT OR IGNORE INTO location (country,city) VALUES (?,?)"
   let record = [ 
                 toSql.country $ location
                , toSql.city $ location
                ]
   run conn query record 
   commit conn

{- | Update capacity of a stadium. -}
updateStadiumCapacityDB :: String -> String -> IO ()
updateStadiumCapacityDB name capacity = do
  conn <- dbConnect
  let query = "UPDATE stadium SET capacity = ? WHERE stadium.name = ?"
  let record = [ 
                  toSql capacity
                , toSql name
               ]
  run conn query record 
  commit conn
  putStrLn $ "Capacity of " ++ name ++ "updated succesfully."
  disconnect conn

{- | Get stadium details -}
getStadiumDetailsDB :: String -> IO ([String])
getStadiumDetailsDB stadium = do
  conn <- dbConnect
  res <- quickQuery' conn "SELECT stadium.team, stadium.fdcouk, stadium.name, stadium.capacity, stadium.latitude, stadium.longitude, location.city, location.country FROM stadium, location ON stadium.locationID = location.locationID AND stadium.name = ?" [toSql stadium]
  disconnect conn
  putStrLn $ "Details of " ++ stadium ++ ": "
  return (map convRow res)  
  where convRow :: [SqlValue] -> String
        convRow [team, fdcouk, name, capacity, longitude, latitude, city, country] = 
            "  Team: " ++ team2 ++ ", Capacity: " ++ capacity2 ++ ", Longitude: " ++ longitude2 ++ ", Latitude: " ++ latitude2 ++ ", City: " ++ city2 ++ ", Country: " ++ country2
            where team2 = (fromSql team) :: String
                  name2 = (fromSql name) :: String
                  capacity2 = (fromSql capacity) :: String
                  longitude2 = (fromSql longitude) :: String
                  latitude2 = (fromSql latitude) :: String
                  city2 = (fromSql city) :: String
                  country2 = (fromSql country) :: String
        convRow x = fail $ "Unexpected result: " ++ show x

{- | Get stadium list for a city -}
getStadiumListDB :: String -> IO ([String])
getStadiumListDB city = do
  conn <- dbConnect
  res <- quickQuery' conn "SELECT stadium.name FROM stadium, location ON stadium.locationID = location.locationID AND location.city = ?" [toSql city]
  disconnect conn
  putStrLn $ "Stadiums in " ++ city ++ ": "
  return (map convRow res)  
  where convRow :: [SqlValue] -> String
        convRow [stadium] = 
            " - " ++ stadium2
            where stadium2 = (fromSql stadium) :: String
        convRow x = fail $ "Unexpected result: " ++ show x