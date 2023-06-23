-- Data Exploration project 

-- SELECT *
-- From coviddeaths
-- where continent is not null;

-- observing potential data
SELECT location,date,total_cases,new_cases,total_deaths,population
From coviddeaths
where continent is not null
order by 1,2;

-- Observing total cases vs total deaths
-- shows likelihood of death based on amount of cases reported in US
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From coviddeaths
where location like '%states%'
order by 1,2;

-- Looking at total cases vs population to see percentage of poplation infected
SELECT location,date,total_cases,population,(total_cases/population)*100 as PopulationInfected
From coviddeaths
where location like '%states%'
order by 1,2;

-- Looking at countries with highest infection rate compared to population
SELECT location,population,max(total_cases)as HighestInfectionCount,max(total_cases/population)*100 as PopulationInfected
From coviddeaths
where continent is not null
GROUP BY location,population
order by PopulationInfected desc;

-- Showing countries with highest death count per Population
SELECT location,max(cast(total_deaths as unsigned)) as TotalDeathCount
From coviddeaths
where continent is not null
GROUP BY location
order by Totaldeathcount;


-- Breaking things down by continent 
SELECT continent, max(cast(total_deaths as unsigned)) as Totaldeathcount
From coviddeaths
where continent is not null 
GROUP BY continent
order by Totaldeathcount;

-- Showing continets with highest death count per population
SELECT continent,sum(cast(population as unsigned)) as totalpopulation, max(cast(total_deaths as unsigned)) as Totaldeathcount
From coviddeaths
where continent is not null
GROUP BY continent
order by Totaldeathcount;

-- Global Numbers
Select date, sum(new_cases),sum(CAST(new_deaths AS unsigned)) as totaldeaths, sum(cast(new_deaths as double))/sum(cast(new_cases as double))*100 as deathpercentage
From coviddeaths
where continent is not null
group by date
order by 1,2;

-- Looking at total population vs vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as unsigned))
OVER (partition by dea.location order by dea.location,dea.date) as RollingVaccinations
from coviddeaths dea
Join covidvaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,2;
 
 -- USE CTE
 With PopvsVac (Continent,Location,date,Population,new_vaccinations,RollingVaccinations)
 as
 (
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as unsigned))
	OVER (partition by dea.location order by dea.location,dea.date) as RollingVaccinations
from coviddeaths dea
Join covidvaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 -- order by 1,2;
 )
 Select *,(RollingVaccinations/population)*100 as population_vaccinated
 From PopvsVac;
 
 -- temp table
 drop table  if exists percentpopulationvaccinated;
 create temporary table percentpopulationvaccinated
 (
 continent nvarchar(255),
 Location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 Rollingvaccinations numeric
 );
 
 insert into percentpopulationvaccinated
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as unsigned))
	OVER (partition by dea.location order by dea.location,dea.date) as RollingVaccinations
from coviddeaths dea
Join covidvaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null;
 
 create view percentpopulationvaccinated as 
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as unsigned))
	OVER (partition by dea.location order by dea.location,dea.date) as RollingVaccinations
from coviddeaths dea
Join covidvaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null;
 -- order by 2,3;
 
 select *
 from percentpopulationvaccinated;