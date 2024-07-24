SELECT *
FROM [Portfolio Project]..Covidsdeaths
where continent is not null
ORDER BY 3,4

--SELECT *
--FROM [Portfolio Project]..CovidsVaccinations
--ORDER BY 3,4

SELECT Location,date,total_cases,new_cases,total_deaths,population
FROM [Portfolio Project]..Covidsdeaths
where continent is not null
ORDER BY 1,2

--TOTAL CASES VS TOTAL DEATHS
SELECT location, date,total_cases,new_cases,total_deaths, (cast(total_deaths as float) / cast(total_cases as float))*100 as
DeathPercentage
FROM [Portfolio Project]..Covidsdeaths
--Where location like '%States%'
Where continent is not null
ORDER BY 1,2;

--total cases vs population
SELECT location, date,total_cases,Population, (cast(total_cases as float) / cast(population as float))*100 as
PercentPopulationInfected
FROM [Portfolio Project]..Covidsdeaths
--Where location like '%States%'
where continent is not null
ORDER BY 1,2;

--country with highest contraction rate wrt Population
SELECT location,Population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases /population)*100 as
PercentPopulationInfected
FROM [Portfolio Project]..Covidsdeaths
Where continent is not null
GROUP BY POPULATION,LOCATION
ORDER BY PercentPopulationInfected DESC

--COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT location,Population, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..Covidsdeaths
Where continent is not null
GROUP BY POPULATION,LOCATION
ORDER BY TotalDeathCount DESC

--continent wise data
--continens with highest count
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..Covidsdeaths
Where continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC


--Global Numbers
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(NULLIF(new_cases,0))*100 as GlobalDeathPercentage
FROM [Portfolio Project]..Covidsdeaths
--Where location like '%States%'
where continent is not null
--Group By date
ORDER BY 1,2


--total population vs vaccination
With PopvsVac(Continent,Location,Date,Population, new_vaccinations,RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location
,dea.date)as RollingPeopleVaccinated
FROM [Portfolio Project]..Covidsdeaths dea
Join [Portfolio Project]..CovidsVaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac

--temp table
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location
,dea.date)as RollingPeopleVaccinated
FROM [Portfolio Project]..Covidsdeaths dea
Join [Portfolio Project]..CovidsVaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null
--order by 2,3
Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated





--for Visualization later


Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location
,dea.date)as RollingPeopleVaccinated
FROM [Portfolio Project]..Covidsdeaths dea
Join [Portfolio Project]..CovidsVaccinations vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated