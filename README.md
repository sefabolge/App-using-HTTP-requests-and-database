# Football
During this project, we will implement a Haskell program for harvesting information from the Web and saving it on a database

# Introduction:

a. Web source:

● We obtain data by downloading from a URL.
● Our program downloads the csv file for 165 Football Stadiums with geographic coordinates around Europe from http://opisthokonta.net/wp-content/uploads/2015/03/stadiums_20150302.csv

b. Data Extraction:

● We downloaded csv file, from which we will save the data in 2 tables: 

Stadium (with StadiumID as the primary key attribute) – this table includes 6 attributes: Team, FDCOUK, Name, Capacity, Latitude and Longitude. Each stadium also has a foreign key LocationID representing its corresponding location (8 columns in total) 

Location (with LocationID as the primary key attribute) – this table includes
attributes: Country and City. (3 columns in total)

# How to compile/run
a. To compile:

● Firstly, users need to change the directory to the project folder program using cd command..

● Then, the following commands should be run in order:

  stack setup
  stack build
  stack exec footaball-exe
  
(Running the program without any arguments or invalid arguments, the list of commands will be listed.)

stack exec footaball-exe download (this is to download and store data in the database)


*Note: When running download feature, in the database creation step, if a database already exists, the program will check whether data exists in the tables. If yes, the program will delete the old data before entering new data.


----------------------------------------------------------------------------------------------------------------------
# Program’s feature

1. Showing details of corresponding information when users input a stadium name:

● Command: stack exec footaball-exe details stadium “Stadium_name ”

● Information includes Team name, Capacity, Latitude, Longitude, City and Country.

● e.g. stack exec footaball-exe details “Stamford Bridge ”

⇨ Output: Details of Stamford Bridge: Team: Chelsea, Capacity: 42499, Long: 51.481667, Lat: -0.191111, City: London,
Country: England

(Some stadium names for testing: “Emirates Stadium ”, “Victoria Park ”, “Anoeta ”)

2. Allowing users to update information in the table:

● Command: stack exec footaball-exe update capacity “Stadium_name” new_capacity_value

● Users can input a stadium name and choose to update information of the stadium’s capacity.

● e.g. stack exec footaball-exe update capacity “Anoeta ” 20

⇨ Output: Capacity of Anoeta updated successfully. The capacity of Anoeta changed to 20 from 32076.

For testing: 

stack exec footaball-exe details “Anoeta ” to see its original capacity of 32076 

stack exec footaball-exe update capacity “Anoeta ” 20 to update the capacity 

stack exec footaball-exe details “Anoeta ” again to see its capacity has been updated to 20.
