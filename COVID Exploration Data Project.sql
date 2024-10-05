SELECT *
FROM PortfolioProject.dbo.CovidDeaths
where continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3,4

-- Select Data thet we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%India%'
ORDER BY 1,2

--Looking at the Total Cases vs Population
--Shows what percent of population got effected by covid

SELECT location, date, population, total_cases, (total_cases/population)*100 AS EffectedByCovid
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%India%'
ORDER BY 1,2

--Looking at countries with Hightest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentageEffectedByCovid
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%India%'
GROUP BY location, population
ORDER BY PercentageEffectedByCovid desc


--showing countries with the highest death count per population


SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%India%'
where continent is not null
GROUP BY location, population
ORDER BY TotalDeathCount desc

-- LETS BREAK THINGS DOWN BY CONTINENT


SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%India%'
 WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%India%'
 WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--continent showing highest deaths count per population


SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%India%'
 WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


-- GLOBAL NUMBERS

SELECT  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as Total_deaths , SUM(cast(new_deaths as int))/ SUM(new_cases) *100 as DeathsPercentage 
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location like '%India%'
WHERE continent is not null
--group by date
ORDER BY 1,2

-- loking at total population vs vacination

select *
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date



WITH PopvsVac(Continent,location, date,population , new_vaccinations,RollingPeopleVaccination )
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccination 
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccination/population)
from PopvsVac


--TEMP TABLE

DROP TABLE IF exists #PercentOfPopulationVaccinated
CREATE TABLE #PercentOfPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population  numeric,
new_vacccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentOfPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2,3

select *,(RollingPeopleVaccinated/population)*100
from #PercentOfPopulationVaccinated


CREATE VIEW PercentOfPopulationVaccinate AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations))over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from PortfolioProject.dbo.CovidDeaths dea
join PortfolioProject.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3

select *
from PercentOfPopulationVaccinate