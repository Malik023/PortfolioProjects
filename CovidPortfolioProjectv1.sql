SELECT *
From Coviddeaths
Where continent is not null
order By 3,4

--SELECT *
--From CovidVacc
--Order BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, Population
From Coviddeaths
Order By 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, CAST(total_deaths AS REAL) / total_cases * 100 AS DeathPercentage
FROM Coviddeaths
Where location like '%states%'
Order By 1,2


--Looking at Total cases vs Population

SELECT Location, date, total_cases, Population, CAST(total_cases AS REAL) / population * 100 AS PercentPopulationInfected
FROM Coviddeaths
Where location like '%states%'
Order By 1,2



-- Looking at Countries with highest Infections Rate Compared to Population

SELECT Location, MAX(total_cases) AS MaxTotalCases, Population, CAST(total_cases AS REAL) / population * 100 AS PercentPopulationInfected
FROM Coviddeaths
-- WHERE location LIKE '%states%'
GROUP BY Location , population 
ORDER BY PercentPopulationInfected DESC

-- BREAKING THINGS DOWN BY CONTINENT

SELECT continent , MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM Coviddeaths
-- WHERE Location LIKE '%state%'
Where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Showing the Countries with highest Death Count per Population

SELECT Location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM Coviddeaths
-- WHERE Location LIKE '%state%'
Where continent is not null
GROUP BY Location 
ORDER BY TotalDeathCount DESC


-- The Continents with hgihest deaths per population

SELECT continent , MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM Coviddeaths
-- WHERE Location LIKE '%state%'
Where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

Create View ContinentDeathPerPop As
SELECT continent , MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM Coviddeaths
-- WHERE Location LIKE '%state%'
Where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Global Numbers


SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(New_deaths)/SUM(New_Cases) * 100 AS DeathPercentage
FROM Coviddeaths
Where continent is not null
-- Group By date
Order By 1,2


With PopvsVac (Continent, location, date , population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select c.continent, c.location, c.date, c.population, cv.new_vaccinations
, SUM(cast(cv.new_vaccinations as bigint)) OVER (Partition by c.location Order By c.location, c.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From Coviddeaths c 
Join CovidVacc cv 
	On c.location = cv.location
	and c.date = cv.date
Where c.continent is not null
--Order By 2,3
)
Select *, Cast(RollingPeopleVaccinated as Real) / Population *100
From PopvsVac

-- Creating a view to store for visualizations

Create View PercentPopulationVaccinated as
Select c.continent, c.location, c.date, c.population, cv.new_vaccinations
, SUM(cast(cv.new_vaccinations as bigint)) OVER (Partition by c.location Order By c.location, c.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From Coviddeaths c 
Join CovidVacc cv 
	On c.location = cv.location
	and c.date = cv.date
Where c.continent is not null
--Order By 2,3


--DROP Table if exists PercentPopulationVaccinated
--Create Temporary table PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)
--
--
--Insert Into PercentPopulationVaccinated
--Select c.continent, c.location, c.date, c.population, cv.new_vaccinations
--, SUM(cast(cv.new_vaccinations as bigint)) OVER (Partition by c.location Order By c.location, c.date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/Population)*100
--From Coviddeaths c 
--Join CovidVacc cv 
--	On c.location = cv.location
--	and c.date = cv.date
--Where c.continent is not null
----Order By 2,3
--Select *, Cast(RollingPeopleVaccinated as Real) / Population *100
--From PercentPopulationVaccinated


DROP TABLE IF EXISTS PercentPopulationVaccinated;

CREATE TEMPORARY TABLE PercentPopulationVaccinated (
  Continent NVARCHAR(255),
  Location NVARCHAR(255),
  Date DATETIME,
  Population NUMERIC,
  New_vaccinations NUMERIC,
  RollingPeopleVaccinated NUMERIC
);

INSERT INTO PercentPopulationVaccinated
  SELECT c.continent,
         c.location,
         c.date,
        c.population,
         cv.new_vaccinations,
         SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (
           PARTITION BY c.location ORDER BY c.location, c.date
        ) AS RollingPeopleVaccinated
  FROM Coviddeaths c
  JOIN CovidVacc cv ON c.location = cv.location AND c.date = cv.date
  WHERE c.continent IS NOT NULL;

SELECT *,
       CAST(RollingPeopleVaccinated AS REAL) / Population * 100
FROM PercentPopulationVaccinated;

CREATE VIEW PercentPopulationVaccinatedView AS
SELECT Continent, Location, Date, Population, New_vaccinations,
       CAST(RollingPeopleVaccinated AS REAL) / Population * 100 AS PercentPopulationVaccinated
FROM (
  SELECT c.continent, c.location, c.date, c.population, cv.new_vaccinations,
         SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY c.location ORDER BY c.location, c.date) AS RollingPeopleVaccinated
  FROM Coviddeaths c 
  JOIN CovidVacc cv ON c.location = cv.location AND c.date = cv.date
  WHERE c.continent IS NOT NULL
) t;







