create database olympics;
use olympics;
# creating and using database olympics

#creating table olympics 
CREATE TABLE olympics (
    name varchar(200) not null,
    age varchar(100) ,
    country varchar(200),
    Year int not null,
    Date_Given varchar(100),
    sports varchar(100),
    gold_medal int ,
    silver_medal int,
    brone_medal int ,
    total_medal int
    );
    
    # loading data into dataframe 
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olympix_data_organized_with_header (1) (1).csv"
INTO TABLE olympics
FIELDS TERMINATED BY ','
LINES terminated by '\n' 
IGNORE 1 ROWS;

alter table olympics
add column `athlete_id` int auto_increment unique first;
# adding auto increment id in athlete column



#deleting null values in data 
delete from olympics where name = "";
select * from olympics;



### Creating multiple tables for Normalization of data 


# creating sports table 
create table Sports(
sports_id int not null auto_increment,
sports varchar(100),
primary key (sports_id)
);

# creating country table 
create table Country(
country_id int not null auto_increment,
country_name varchar(100),
primary key (country_id)
);

# creating athlete table 
create table Athlete(
athlete_id int not null auto_increment,
athlete_name varchar(100),
sports_id int(100), 
country_id int, 
age varchar(100), 
primary key (athlete_id)
);

# creating date table
 
create table date(
year int not null , 
date_given varchar(100)
);


# creating medals table
create table Medals(
gold_medal int, 
silver_medal int, 
bronze_medal int,
total_medal int,
athlete_id int,
sports_id int,
country_id int
);

# inserting values into sports from olympics table 
insert into sports(sports)
select distinct sports from olympics
;
select * from sports;

#inserting values into country from olympics
insert into country(country_name)
select distinct country from olympics;
select * from country;

# creating a temporary table for storing and joining all the data through different tables 
create table temprory(
sports_id int ,
athlete_id int,
sports varchar(100), 
country_id int ,
country varchar(100)
);

# inserting values into temprory table with inner joins
insert into temprory(sports_id, sports, athlete_id , country_id, country)
select sports.sports_id, olympics.sports, olympics.athlete_id, c.country_id , olympics.country from olympics  
inner join sports on 
sports.sports = olympics.sports
inner join country c on 
olympics.country = c.country_name;

 # inserting values into athlete table using inner joins from temprory table 
select * from athlete;
insert into athlete(athlete_id, sports_id, athlete_name, country_id, age)
select olympics.athlete_id, sports_id, name, country_id, age from olympics
inner join temprory on
temprory.athlete_id = olympics.athlete_id;


# inserting values into medals table using temprory table 

insert into medals(athlete_id, sports_id, country_id,bronze_medal,silver_medal,gold_medal,total_medal)
select olympics.athlete_id, sports_id, country_id,brone_medal,silver_medal,gold_medal,total_medal from olympics
inner join temprory on
temprory.athlete_id = olympics.athlete_id;
select * from medals;

# average medals won by each country 
select avg(total_medal), country_name from medals
inner join country on 
country.country_id = medals.country_id
group by country_name;

# countries and the number of gold medals they have won in decreasing order
select country_name , sum(gold_medal) from country 
inner join medals on 
country.country_id = medals.country_id
group by country_name
order by sum(gold_medal) desc;

# list of people and medals they have won grouped by country 
select country_name , athlete_name , total_medal from athlete 
inner join medals on 
medals.athlete_id = athlete.athlete_id
inner join country on 
country.country_id = medals.country_id
group by country_name
order by athlete_name desc;


#list of people with medals they have won with age 
select athlete_name , age , bronze_medal, silver_medal, gold_medal, total_medal from athlete
inner join medals on
medals.athlete_id = athlete.athlete_id
order by age ;


# country with most medals
select country_name , sum(total_medal) from country 
inner join medals on 
country.country_id = medals.country_id
group by country_name 
order by sum(total_medal) desc;