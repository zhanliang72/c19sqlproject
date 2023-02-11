--Select * 
--from Project..['c death']
--order by 3,4

--Select * 
--from Project..['c vac']
--order by 3,4

---- select data that we are using

--Select Location, date, total_cases, new_cases, total_deaths, population
--from Project..['c death']
--order by 1,2

---- total cases, total deaths, and death rate in the U.S.

--Select Location, date, total_cases, total_deaths, total_deaths*100/total_cases as Deathrate
--from Project..['c death']
--where location like '%states%'
--order by 1,2

----total case, population, infection rate in the U.S.

--Select Location, date, total_cases, population, total_cases*100/population as infectionrate
--from Project..['c death']
--where location like '%states%'
--order by 1,2

----Highest infected rate countries

--Select Location, population, max(total_cases) as highestcase, Max(total_cases*100/population) as infectionrate 
--from Project..['c death']
--where continent is not null
--group by location, population
--order by infectionrate desc

----Highest death rate countries

--Select Location, population, max(cast(total_deaths as int)) as highestdeath, Max(cast(total_deaths as int)*100/population) as deathrate
--from Project..['c death']
--where continent is not null
--group by location, population
--order by deathrate desc

----Death Rate continent

--Select location,population, Max(cast(total_deaths as int)) as highestdeath, Max(cast(total_deaths as int)*100/population) as deathrate
--from Project..['c death']
--where continent is null
--group by location,population
--order by deathrate desc

----Global population death rate

--SELECT date, new_cases, cast(new_deaths as int) as new_death, 
--       case
--	   when new_cases = 0 then 0
--	   else cast(new_deaths as int)/new_cases*100 
--	   end as deathrate 
--FROM Project..['c death'] 
--WHERE location like '%world%' 
--ORDER BY date;

--Select date, sum(new_cases) as totalcase, sum(cast(new_deaths as int)) as totaldeath, 
--case 
--when sum(new_cases) = 0 then 0
--else sum(cast(new_deaths as int))/sum(new_cases) *100
--end as deathrate
--from Project..['c death']
--where continent is null and location in( 'South America' , 'Europe', 'North America' , 'Oceania' , 'Asia' , 'Africa' , 'International')
--group by date
--order by date

----Total vac count in the per U.S. population

----Using Cte
--With tcount (continent,location,date,population,new_vac,totalcount)
--as
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, 
--       cast(vac.new_vaccinations as BIGINT) as new_vac,
--       SUM(coalesce(cast(vac.new_vaccinations as BIGINT), 0)) 
--         over (partition by dea.location order by dea.location, dea.date) as totalcount
--FROM Project..['c death'] dea
--JOIN Project..['c vac'] vac
--ON dea.location = vac.location
--AND dea.date = vac.date
--WHERE dea.continent is not null and dea.location like '%states%'
--)
--Select *, totalcount/population as totalvac
--From tcount

----using new table
--Drop table if exists project..tcount
--Create table project..tcount
--(continent nvarchar(250),
--location nvarchar(250),
--date datetime,
--population numeric,
--new_vac numeric,
--totalcount numeric)

--insert into project..tcount
--SELECT dea.continent, dea.location, dea.date, dea.population, 
--       cast(vac.new_vaccinations as BIGINT) as new_vac,
--       SUM(coalesce(cast(vac.new_vaccinations as BIGINT), 0)) 
--         over (partition by dea.location order by dea.location, dea.date) as totalcount
--FROM Project..['c death'] dea
--JOIN Project..['c vac'] vac
--ON dea.location = vac.location
--AND dea.date = vac.date
--WHERE dea.continent is not null and dea.location like '%states%'

--Select *, totalcount/population as totalvac
--From Project..tcount

----Create view for Global population deathrate

--Create view PopDRate as
--Select date, sum(new_cases) as totalcase, sum(cast(new_deaths as int)) as totaldeath, 
--case 
--when sum(new_cases) = 0 then 0
--else sum(cast(new_deaths as int))/sum(new_cases) *100
--end as deathrate
--from Project..['c death']
--where continent is null and location in( 'South America' , 'Europe', 'North America' , 'Oceania' , 'Asia' , 'Africa' , 'International')
--group by date