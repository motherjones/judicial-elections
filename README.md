# Data Diary for Mother Jones Judicial Campaign Finance Investigation

This is a data diary that walks through the steps of acquiring [campaign contribution data for state supreme court and lower court candidates](), preparing it for SQL analysis and producing specific charts for an online interactive at [MotherJones.com](http://www.motherjones.com/)

## The steps

Design inspired by [NYT graphic on motorcycle fatalities](http://www.nytimes.com/interactive/2014/03/31/science/motorcycle-helmet-laws.html?_r=0)
### Quick reference

#### Source

- [The National Institute on Money in State Politics)](http://beta.followthemoney.org/show-me?c-r-ot=D,J#[{1|) - (This is the institute's beta site, which should go live any time now). We wanted all contributions to state high court candidates and below. The site will eventually allow for download of all search results in csv, xml and json formats. The kinks haven't been worked out yet, so we were able to get a [custom txt file](http://assets.motherjones.com/interactives/projects/2014/4/judicial/JudicialContributionrequest.txt) directly from the institute.

#### Tools

- [Sequel Pro](http://www.sequelpro.com/) - A free MySQL client (for Mac OS X)
- [Firefox SQLite Manager](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/?src) - A free plugin for SQLite (which will work just as well as MySQL)
- [Google Spreadsheets](https://accounts.google.com/ServiceLogin?sacu=1&continue=https%3A%2F%2Fdrive.google.com%2F%23&hl=en&service=wise) - Free to use with a Google account.

#### Produced data

NEED TO FILL THIS PART IN


## About the data

The National Institute on Money in State Politics is a nonpartisan, nonprofit organization that systematically tracks down campaign conributon data in all 50 states. The organization says its [data represents information on](http://beta.followthemoney.org/about-us/): 

> 100,000+ lobbyists and clients who register annually, and a 50-state database of contributions documenting $28 billion. Recent expansions include selected local-level data, and collection of reports submitted by independent spending entities in up to 32 states, and political action committees in up to 39 states. 


## Not sure if we're using this part***** 
*I'm leaving his stuff in this section so I can duplicate it with mine if need be*

![The BTS web form](http://i.imgur.com/ppQw6Vx.png)

The data can be downloaded as flat CSV files [from this web form](http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=259&DB_Short_Name=Air%20Carriers).

To download the __November 2013__ dataset, set the form options accordingly:

1. __Filter geography__ - `All`
2. __Filter year__ - `2013`
3. __Filter period__ - `November`
4. Check the __Select all fields__ checkbox
5. Then click the __Download__ button.

Your browser will download a __ZIP__ file weighing roughly 10.4 MB and it will be named something like: `932989999_T_T100D_SEGMENT_US_CARRIER_ONLY.zip`

Unzipping this file will produce a 94.1 MB plaintext CSV file. 

This is what the [first 200 rows of that CSV looks like](data/sample-T100D-segment-data.csv).

## Importing into SQL

We will now __import__ the T100 data file into the SQL database of your choice: [Sequel Pro](http://www.sequelpro.com/) is a great GUI for Mac and MySQL, and [Firefox's SQLite Manager Plugin](https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/?src) is cross-platform.

For the purposes of this exercise, I use [Sequel Pro](http://www.sequelpro.com/)

1. __Data preparation__ - For some reason, the [T100 data file](data/sample-T100D-segment-data.csv) has a trailing column at the end of each row, which effectively creates an empty column. 

 ![Trailing commas in the T100 data](http://i.imgur.com/wanruuE.png)

 This is problematic in the __first row__ (i.e. the __headers__) during the import phase. A quick fix is to just type in some easy-to-ignore value. In the prepared file, I've simply named it `EMPTYFIELD`

2. __Create a database__ - In your database manager, create a database named `bts_data`

3. __Create a table__ - By default, most import managers will treat each field as a `VARCHAR` of length 255. Some of the fields in the data are clearly numbers (e.g. `DISTANCE`, `DEPARTURES_SCHEDULED`), and others have values much shorter than 255 (e.g. `ORIGIN_STATE_ABR`).

 We also want to __index__ some of the columns, such as `ORIGIN_AIRPORT_ID`, to speed up our queries.

 Here's the resulting SQL to create a table named `t100_domestic_carriers`:
 ~~~sql
 CREATE TABLE `t100_domestic_carriers` (
  `DEPARTURES_SCHEDULED` int(12) DEFAULT NULL,
  `DEPARTURES_PERFORMED` int(12) DEFAULT NULL,
  `PAYLOAD` int(11) DEFAULT NULL,
  `SEATS` int(11) DEFAULT NULL,
  `PASSENGERS` int(11) DEFAULT NULL,
  `FREIGHT` int(11) DEFAULT NULL,
  `MAIL` int(11) DEFAULT NULL,
  `DISTANCE` int(11) DEFAULT NULL,
  `RAMP_TO_RAMP` int(11) DEFAULT NULL,
  `AIR_TIME` int(11) DEFAULT NULL,
  `UNIQUE_CARRIER` char(6) DEFAULT NULL,
  `AIRLINE_ID` int(11) DEFAULT NULL,
  `UNIQUE_CARRIER_NAME` varchar(255) DEFAULT NULL,
  `UNIQUE_CARRIER_ENTITY` char(10) DEFAULT NULL,
  `REGION` char(2) DEFAULT NULL,
  `CARRIER` char(5) DEFAULT NULL,
  `CARRIER_NAME` varchar(255) DEFAULT NULL,
  `CARRIER_GROUP` char(2) DEFAULT NULL,
  `CARRIER_GROUP_NEW` char(2) DEFAULT NULL,
  `ORIGIN_AIRPORT_ID` char(12) DEFAULT NULL,
  `ORIGIN_AIRPORT_SEQ_ID` char(7) DEFAULT NULL,
  `ORIGIN_CITY_MARKET_ID` char(6) DEFAULT NULL,
  `ORIGIN` varchar(255) DEFAULT NULL,
  `ORIGIN_CITY_NAME` varchar(255) DEFAULT NULL,
  `ORIGIN_STATE_ABR` char(3) DEFAULT NULL,
  `ORIGIN_STATE_FIPS` varchar(255) DEFAULT NULL,
  `ORIGIN_STATE_NM` varchar(255) DEFAULT NULL,
  `ORIGIN_WAC` int(11) DEFAULT NULL,
  `DEST_AIRPORT_ID` char(12) DEFAULT NULL,
  `DEST_AIRPORT_SEQ_ID` char(7) DEFAULT NULL,
  `DEST_CITY_MARKET_ID` char(6) DEFAULT NULL,
  `DEST` varchar(255) DEFAULT NULL,
  `DEST_CITY_NAME` varchar(255) DEFAULT NULL,
  `DEST_STATE_ABR` char(3) DEFAULT NULL,
  `DEST_STATE_FIPS` varchar(255) DEFAULT NULL,
  `DEST_STATE_NM` varchar(255) DEFAULT NULL,
  `DEST_WAC` char(2) DEFAULT NULL,
  `AIRCRAFT_GROUP` char(3) DEFAULT NULL,
  `AIRCRAFT_TYPE` char(5) DEFAULT NULL,
  `AIRCRAFT_CONFIG` char(2) DEFAULT NULL,
  `YEAR` int(11) DEFAULT NULL,
  `QUARTER` int(11) DEFAULT NULL,
  `MONTH` int(11) DEFAULT NULL,
  `DISTANCE_GROUP` int(11) DEFAULT NULL,
  `CLASS` char(2) DEFAULT NULL,
  `EMPTYFIELD` char(1) DEFAULT NULL,
  KEY `UNIQUE_CARRIER` (`UNIQUE_CARRIER`),
  KEY `ORIGIN_AIRPORT_ID` (`ORIGIN_AIRPORT_ID`),
  KEY `ORIGIN_CITY_MARKET_ID` (`ORIGIN_CITY_MARKET_ID`),
  KEY `DEST_AIRPORT_ID` (`DEST_AIRPORT_ID`),
  KEY `DEST_CITY_MARKET_ID` (`DEST_CITY_MARKET_ID`),
  KEY `ORIGIN_AIRPORT_ID_2` (`ORIGIN_AIRPORT_ID`,`DEST_AIRPORT_ID`),
  KEY `ORIGIN_STATE_ABR` (`ORIGIN_STATE_ABR`),
  KEY `DEST_STATE_ABR` (`DEST_STATE_ABR`),
  KEY `YEAR_AND_MONTH` (`YEAR`,`MONTH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
 ~~~

4. __Import the T100 CSV__ - Now simply import the CSV file into our newly created table. Sequel Pro will match up the columns in the CSV file to those in our `t100_domestic_carriers`

 ![Importing into Sequel Pro](http://i.imgur.com/OeKvLPO.png)




## Data exploration

- Create a list of carriers in this dataset, sorted in descending order by number of performed departures
 ~~~sql
 SELECT UNIQUE_CARRIER, UNIQUE_CARRIER_NAME, SUM(DEPARTURES_PERFORMED) as total_departures 
  FROM bts_data.t100_domestic_carriers
  GROUP BY UNIQUE_CARRIER
  ORDER BY total_departures DESC
 ~~~

 __Results:__

 UNIQUE_CARRIER | UNIQUE_CARRIER_NAME | total_departures
 ----------------|--------------|----------------:
 WN | Southwest Airlines Co. | 1030147
 DL | Delta Air Lines Inc. | 698188
 EV | ExpressJet Airlines Inc. | 678610
 OO | SkyWest Airlines Inc. | 568164
 AA | American Airlines Inc. | 487525
 UA | United Air Lines Inc. | 463063

- List the city-to-city routes flown by Delta Air Lines, sorted in descending order of the sum of passengers flown.

 ~~~sql
 SELECT ORIGIN_CITY_NAME, DEST_CITY_NAME, SUM(PASSENGERS) AS total_passengers
  FROM t100_domestic_carriers
  WHERE UNIQUE_CARRIER='DL'
  GROUP BY ORIGIN_AIRPORT_ID, DEST_AIRPORT_ID
  ORDER BY total_passengers DESC
 ~~~

 __Results:__

 |ORIGIN_CITY_NAME|DEST_CITY_NAME|total_passengers
 |----------------|--------------|----------------:
 |Orlando, FL|Atlanta, GA|888016
 |Atlanta, GA|Orlando, FL|882425
 |Atlanta, GA|New York, NY| 704765
 |New York, NY|Atlanta, GA|699186
 |Atlanta, GA|Los Angeles, CA|673863
 |Atlanta, GA|Fort Lauderdale, FL|659698


## Normalizing the database


### Download lookup tables

The BTS provides several lookup tables that will be useful in keeping our Air Carrier data normalized. I've included them in this diary's `data/` directory for your convenience. You can also [download them directly from the BTS webform](http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=259&DB_Short_Name=Air%20Carriers), though they annoyingly have the nonsensical file extension of `.csv-`

Table | Records | Description
------|--------:|------------
[L_AIRCRAFT_CONFIG.csv](data/lookup-tables/L_AIRCRAFT_CONFIG.csv)  |  6    | e.g. `"1","Passenger Configuration"` 
[L_AIRCRAFT_GROUP.csv](data/lookup-tables/L_AIRCRAFT_GROUP.csv)  |  10    |  e.g. `"7","Jet, 3-Engine"`
[L_AIRPORT_ID.csv](data/lookup-tables/L_AIRPORT_ID.csv)  |  6,260    |   a unique identifier for airports that persists regardless of changes to codes, e.g. `"10030","Port Vita, AK: Port Vita Airport"`
[L_AIRCRAFT_TYPE.csv](data/lookup-tables/L_AIRCRAFT_TYPE.csv)  |  385    |  e.g. `"889","B787-900 Dreamliner"`
[L_CITY_MARKET_ID.csv](data/lookup-tables/L_CITY_MARKET_ID.csv)  |  5,656    |   - a reference to a metro area that may be served by several airports., e.g. `"31703","New York City, NY (Metropolitan Area)"`
[L_REGION.csv](data/lookup-tables/L_REGION.csv)  |  6    |   e.g. `"D", "Domestic"`
[L_SERVICE_CLASS.csv](data/lookup-tables/L_SERVICE_CLASS.csv)  |  14    |  e.g.`"K","Scheduled Service K (F+G)"`
[L_UNIQUE_CARRIERS.csv](data/lookup-tables/L_UNIQUE_CARRIERS.csv)  |  1,565    |  e.g. `"DL","Delta Air Lines Inc."`
[L_WORLD_AREA_CODES.csv ](data/lookup-tables/L_WORLD_AREA_CODES.csv )  |  333    |   e.g. `"759","North Vietnam"`


(to be continued)

## Next steps

- Import the lookup tables to create a normalized database.
- Create a pruned version of the raw `t100_domestic_carriers` table
- Import the entire time range of the BTS data


