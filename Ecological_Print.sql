Select *
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
order by Region

Select region, country, cropland_footprint, grazing_footprint, forest_footprint, carbon_footprint, 
	fish_footprint, built_up, total_footprint
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Order by Region

Select Sum(convert(int, cropland_footprint)) as total_cropland, Sum(convert(int, grazing_footprint)) as total_grazing, 
	Sum(convert(int, forest_footprint)) as total_forest, Sum(convert(int, carbon_footprint)) as total_carbon, 
	Sum(convert(int, fish_footprint)) as total_fish, Sum(built_up) as total_built, 
	Sum(convert(int, total_footprint)) as grand_total
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
order by 1,2

Select Sum(built_up) as total_built, Sum(cast(carbon_footprint as int)) as total_carbon,
	Sum(cast(carbon_footprint as int))/Sum(built_up)*100 as BuiltEffectPercent
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
order by 1,2

Select region, country, carbon_footprint, total_footprint, Round((carbon_footprint/total_footprint),3)*100 as CarbonPrintPercent 
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
Order by region

Select country, region,   grazing_footprint, total_footprint, Round((grazing_footprint/total_footprint),3)*100 as GrazingPrintPercent 
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
Order by region

Select country, region, built_up, total_footprint, Round((built_up/total_footprint),3)*100 as BuiltUpPrintPercent 
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
Order by region

Select country, region, income_group, population, carbon_footprint, total_footprint, Round((carbon_footprint/total_footprint),3)*100 as CarbonPrintPercent 
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
Order by region desc

Select region, country, population, total_biocapacity, total_footprint,
	Sum(total_biocapacity - total_footprint) OVER (partition by country order by country)
	as capacity_difference
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
order by 2,3

With ActualvsReal (Region, Country, Population, total_biocapacity, total_footprint, 
capacity_difference)
as
(
Select Region, Country, Population, [total_biocapacity ], total_footprint,
	Sum([total_biocapacity ] - total_footprint) OVER (partition by country order by country)
	as capacity_difference
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
--order by 2,3
)
Select *,  Round(capacity_difference/[total_biocapacity ], 3)*100 as CapacityDiffPercent
From ActualvsReal


DROP Table if exists #PercentCapacityDiff
Create Table #PercentCapacityDiff
(
Region nvarchar(255),
Country nvarchar(255),
Population numeric,
total_biocapacity numeric,
total_footprint numeric,
capacity_difference numeric
)
Insert into #PercentCapacityDiff
Select Region, Country, Population, [total_biocapacity ], total_footprint,
	Sum([total_biocapacity ] - total_footprint) OVER (partition by country order by country)
	as capacity_difference
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
--order by 2,3

Select *,  Round(capacity_difference/1, 3)*100  as CapacityDiffPercent
From #PercentCapacityDiff

Create View CapacityDiffPercent as
Select Region, Country, Population, [total_biocapacity ], total_footprint,
	Sum([total_biocapacity ] - total_footprint) OVER (partition by country order by country)
	as capacity_difference
From ProjectPortfolio.dbo.Global_Ecological_Footprint_2024
Where region is not null
--order by 2,3
