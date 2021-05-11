select * from CovidVaccinations order by 3;
select * from CovidDeaths where continent is not null order by 3;

-- Select Data that we are going to be using

select location,date,total_cases,new_cases,total_deaths,population from CovidDeaths order by 1,2;

 
-- Looking at the total cases and total deaths;
-- Shows liklihood of dying by corona

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 from CovidDeaths where location like '%india%' order by 1,2;


--looking at Total Cases vs Population
--Shows what percentage ofPopulation got covid

select location,date,population,total_cases,total_deaths , (total_deaths/total_cases)*100 as Death_Percentage from CovidDeaths 
where location like '%india%' order by 1,2;


-- Loooking at Countries with highest Infection Rate

select location,population,max(total_cases) as Highest_Infection_count_per_location, max(total_cases/population)*100 as Percentage_population_infected from CovidDeaths group by location,population
order by 4 desc;


-- Countries with highest death counts

select location,max(cast(total_deaths as int)) as Total_Death_count from CovidDeaths where continent is not null group by location,population
order by Total_Death_count desc;



select location,max(cast(total_deaths as int)) as Total_Death_count from CovidDeaths where continent is not null group by location,population
order by Total_Death_count desc;


--Lets Break Evrything By Continent
--Showing continents with highest death count


select continent,max(cast(total_deaths as int)) as Total_Death_count from CovidDeaths where continent is not null group by continent order by Total_Death_count desc;


-- Global Numbers
select sum(new_cases) Total_Cases,sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage from CovidDeaths where continent is not null order by 1,2 ;


--CovidVacinations

-- Total Population Vs Vaccinated People

---cte
with popvsvac (continent,location,dat,population,rolling_People_Vaccinated,new_vaccination) as
(select dea.continent,dea.location,dea.date,
population,vac.new_vaccinations,
sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rolling_People_Vaccinated
 from CovidDeaths dea join CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date 
where dea.continent is not null) select *,(rolling_People_Vaccinated)*100 from popvsvac order by 7 desc;





--- With Temp Table
Drop table if exists percentpolulationvaccinated;
create table percentpolulationvaccinated(Continent varchar(255),location varchar(255) , date datetime,
population int,
new_vaccinations numeric,
rolling_people_vaccinated int);


insert into percentpolulationvaccinated
select dea.continent,dea.location,dea.date,
population,vac.new_vaccinations,
sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rolling_People_Vaccinated
 from CovidDeaths dea join CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date 
where dea.continent is not null

select * from percentpolulationvaccinated;


--VIEW

create view percentpolulationvaccinate as
select dea.continent,dea.location,dea.date,
population,vac.new_vaccinations,
sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rolling_People_Vaccinated
 from CovidDeaths dea join CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date 
where dea.continent is not null
--order by 2,3


select * from percentpolulationvaccinate;





