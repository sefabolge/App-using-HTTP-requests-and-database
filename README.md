# Football
During this project, you will implement a Haskell program for harvesting information from the Web and saving it on a database

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
● Then, the following commands should be run in order:o

  stack setup
  stack build
  stack exec footaball-exe
  
(Running the program without any arguments or invalid arguments, the list of commands will be listed.)

stack exec footaball-exe download (this is to download and store data in the database)


*Note: When running download feature, in the database creation step, if a database already exists, the program will check whether data exists in the tables. If yes, the program will delete the old data before entering new data.
