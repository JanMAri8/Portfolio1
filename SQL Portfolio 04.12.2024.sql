SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not Null
Order By 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--Order By 3,4


Select Location, Date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
--Order by 1,2

--Looking at total cases vs total deaths

Use PortfolioProject
GO
Create View DeathPercentage as
SELECT Location, Date, total_cases, total_deaths, (CONVERT(float,total_deaths)/NULLIF(CONVERT(float,total_cases),0))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not Null
--Where Location like '%Asia%'
--Order by 1,2


--Looking at total cases vs population

Use PortfolioProject
GO
Create View  CasePercentage as
Select Location, Date, total_cases, population, (CONVERT(float,total_cases)/NULLIF(CONVERT(float,population),0))*100 as CasePercentage
From PortfolioProject..CovidDeaths
Where continent is not Null
--Where Location like '%Asia%'
--Order by 1,2


--Looking at countires with highest infection rate compared to population
Use PortfolioProject 
GO
Create View PercentPopulationInfected as
SELECT Location, population, MAX(Total_Cases) as HighestInfectionCount,
MAX(CONVERT(float,total_cases)/NULLIF(CONVERT(float,population),0))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not Null
Group by Location, population
--Order by PercentPopulationInfected desc

--showing countries with highest death count per population

Use PortfolioProject
Go
Create View TotalDeathCount2 as
Select Location, MAX(Convert(float,Total_Deaths)) as TotalDeathCount2
From PortfolioProject..CovidDeaths
Where continent is not Null
Group by Location
--Order by TotalDeathCount desc

--lets break things ito continents

Use PortfolioProject
Go
Create View TotalDeathCount1 as
SELECT continent, MAX(Cast(Total_Deaths as int)) as TotalDeathCount1
From PortfolioProject..CovidDeaths
Where continent is not Null
Group by continent
--Order by TotalDeathCount1 desc

-- showing the continents with highest death counts per population

Use PortfolioProject
GO
Create View TotalDeathCount as
SELECT continent, MAX(Cast(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not Null
Group by continent
--Order by TotalDeathCount desc


-- Breaking Global Numbers

SELECT Date, sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as Total_deaths, (SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not Null
Group By date
Order by DeathPercentage desc


-- total population vs vaccinations


Select dth.continent, dth.location, dth.date, dth.population, vax.new_vaccinations,
Sum(cast(vax.new_vaccinations as int)) OVER (Partition by dth.location Order By dth.location, dth.Date) as RollingVaxxed,
(RollingVaxxed/population)*100
FROM PortfolioProject..CovidDeaths dth
JOIN portfolioProject..CovidVaccinations vax
 ON dth.location=vax.location
 and dth.date=vax.date
 where dth.continent is not null
 Order By 1,2,3

 --USE CTE
 
 With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingVaxxed)
as
(
Select dth.continent, dth.location, dth.date, dth.population, vax.new_vaccinations,
Sum(cast(vax.new_vaccinations as int)) OVER (Partition by dth.location Order By dth.location, dth.Date) as RollingVaxxed
FROM PortfolioProject..CovidDeaths dth
JOIN portfolioProject..CovidVaccinations vax
 ON dth.location=vax.location
 and dth.date=vax.date
where dth.continent is not null
 --Order By 2,3
 )

 Select *, (RollingVaxxed/Population)*100
 From PopvsVac


 -- Temp Table

 Drop Table if exists #PercentPopulationVaxxed

 Create Table #PercentPopulationVaxxed
(Continent  nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations Numeric,
RollingVaxxed numeric)


 Insert Into #PercentPopulationVaxxed
 Select dth.continent, dth.location, dth.date, dth.population, vax.new_vaccinations,
Sum(cast(vax.new_vaccinations as int)) OVER (Partition by dth.location Order By dth.location, dth.Date) as RollingVaxxed
FROM PortfolioProject..CovidDeaths dth
JOIN portfolioProject..CovidVaccinations vax
 ON dth.location=vax.location
 and dth.date=vax.date
where dth.continent is not null
 --Order By 2,3
 

  Select *, (RollingVaxxed/Population)*100
 From #PercentPopulationVaxxed


 -- view create view to store data for later

 Use PortfolioProject
 GO
 Create View PercentPopulationVaxxed as
 Select dth.continent, dth.location, dth.date, dth.population, vax.new_vaccinations,
Sum(cast(vax.new_vaccinations as int)) OVER (Partition by dth.location Order By dth.location, dth.Date) as RollingVaxxed
FROM PortfolioProject..CovidDeaths dth
JOIN portfolioProject..CovidVaccinations vax
 ON dth.location=vax.location
 and dth.date=vax.date
where dth.continent is not null
 --Order By 2,3



 Select *
 From PercentPopulationVaxxed
