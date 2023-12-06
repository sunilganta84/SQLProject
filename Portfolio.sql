Select *
From Portfolio.coviddeaths
order by 3,4;


SELECT DISTINCT continent
FROM Portfolio.coviddeaths;

Select DISTINCT location
From Portfolio.coviddeaths
where continent is not null AND continent <> '';


-- Select *
-- From Portfolio.covidvaccinations
-- order by 3,4;

-- Select the data we would be working with

Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolio.coviddeaths
where continent is not null AND continent <> ''
order by 1,2;

-- Looking at Total cases vs Total Deaths in United States

SELECT location, date, total_deaths
    (total_deaths  / total_cases ) * 100 AS DeathPercentage
FROM
    Portfolio.coviddeaths
where continent is not null AND continent <> ''
ORDER BY
    location, date;



-- Looking at the total cases vs the population in Germany
-- Shows percentage of population in Germany that got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
From Portfolio.coviddeaths
where continent is not null AND continent <> ''
and location like '%Germany%'
order by 1,2;

-- Looking at countries with highest infection compared to population



SELECT Location, population, Max(cast(total_cases as float)) as HighestInfectionCount, 
       concat(Round((Max(total_cases)/population)*100,2), '%') as CasePercentage
FROM Portfolio.coviddeaths
where continent is not null AND continent <> ''
GROUP BY Location, population
ORDER BY CasePercentage DESC;

-- Show the countries with highest death count per population


--
SELECT Location, Max(cast(total_deaths as float)) as TotalDeathCount
FROM Portfolio.coviddeaths
where continent is not null AND continent <> ''
GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Lets break it down by Continent and Income groups

SELECT location, Max(cast(total_deaths as float)) as TotalDeathCount
FROM Portfolio.coviddeaths
where continent is null or continent = ''
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Filtering only to show the Continents and world

SELECT location, Max(cast(total_deaths as float)) as TotalDeathCount
FROM Portfolio.coviddeaths
where continent is null or continent = '' 
and location in ('Europe', 'Asia', 'North America', 'South America', 'Africa', 'Oceania', 'World', 'European Union')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Separating Income Groups

SELECT location, Max(cast(total_deaths as float)) as TotalDeathCount
FROM Portfolio.coviddeaths
where continent is null or continent = '' 
and location in ('High Income', 'Upper middle income', 'Lower middle income', 'Low income', 'World')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Global numbers

SELECT DATE_FORMAT(date, '%Y-%m-%d') AS FormattedDate, 
sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, 
concat(round(sum(new_deaths)/sum(new_cases)*100,2),'%') AS DeathPercentage
FROM Portfolio.coviddeaths
where continent is not null AND continent <> ''
group by FormattedDate
ORDER BY DATE_FORMAT(date, '%Y-%m-%d') ;

-- Total Deaths
SELECT  format(sum(new_cases),0) as total_cases, format(sum(new_deaths),0) as total_deaths, 
concat(round(sum(new_deaths)/sum(new_cases)*100,2),'%') AS DeathPercentage
FROM Portfolio.coviddeaths
where continent is not null AND continent <> ''
ORDER BY 1,2 ;


Select *
from Portfolio.coviddeaths dea
join Portfolio.covidvaccinations vac 
on dea.location = vac.location AND dea.date = vac.date;

-- Total population vs Vaccination
Select dea.continent, dea.location, date_format(dea.date, '%Y-%m-%d') as formatteddate,
 dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) over (PARTITION BY dea.location ORDER BY dea.date) AS Rolling_vaccinations
from Portfolio.coviddeaths dea
join Portfolio.covidvaccinations vac 
on dea.location = vac.location AND dea.date = vac.date
where dea.continent is not null AND dea.continent <> ''
order by 2,3;

-- Use CTE

With PopvsVac as ( Select dea.Continent,dea.location,dea.date,dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) over (PARTITION BY dea.location ORDER BY dea.date) AS Rolling_vaccinations
from Portfolio.coviddeaths dea
join Portfolio.covidvaccinations vac 
on dea.location = vac.location AND dea.date = vac.date
where dea.continent is not null AND dea.continent <> ''
order by 2,3 )

Select *, concat(round((Rolling_vaccinations/population)*100,2),'%')
From PopvsVAC;

-- Creating view to store data for visualization


Create View PopvsVAC as Select dea.Continent,dea.location,dea.date,dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) over (PARTITION BY dea.location ORDER BY dea.date) AS Rolling_vaccinations
from Portfolio.coviddeaths dea
join Portfolio.covidvaccinations vac 
on dea.location = vac.location AND dea.date = vac.date
where dea.continent is not null AND dea.continent <> '';


Select *
From popvsvac;
