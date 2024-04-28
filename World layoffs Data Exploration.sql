-- Data Exploration
-- Here we are just going to explore the data and find trends or patterns or anything interesting

select * from layoffs_prep2;

-- looking at the company, its location and industry that laid off the highest number of people
select company, location, industry, max(total_laid_off)
from layoffs_prep2;

-- Which companies had 1 which is basically 100 percent of they company laid off
select * 
from layoffs_prep2
where percentage_laid_off = 1; 
-- these are mostly startups

-- if we order by funds_raised_millions we can see how big some of these companies were
select * 
from layoffs_prep2
where percentage_laid_off = 1
order by funds_raised_millions;

-- Companies with the most total Layoff
select company, sum(total_laid_off)
from layoffs_prep2
group by company
order by 2 desc;

-- by industry
select industry, sum(total_laid_off)
from layoffs_prep2
group by industry
order by 2 desc; 

-- the total in this particular dataset or in the past 3 years
select country, sum(total_laid_off)
from layoffs_prep2
group by country
order by 2 desc;

select year(date), sum(total_laid_off)
from layoffs_prep2
group by year(date)
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_prep2
group by stage
order by 2 desc;

-- Selecting the minimum and maximum dates from the layoffs_prep2 table to know when the first and last layoff occurred
select min(`date`), max(`date`)
from layoffs_prep2;


select * from layoffs_prep2;


-- Selecting the month extracted from the date column and summing total laid off employees for each month, excluding null values, then ordering them by month in ascending order.
select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_prep2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

with rolling_Total as 
(select substring(`date`,1,7) as `month`, sum(total_laid_off) as sacked
from layoffs_prep2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, sacked, sum(sacked) over (order by `month`) as rolling_total
from rolling_Total;

-- we looked at Companies with the most Layoffs. Now let's look at that per year and their rankings

select company, year(`date`) , sum(total_laid_off)
from layoffs_prep2
group by company, year(`date`)
order by 3 desc;

with company_year (company, years, total_laid_off) as 
(
select company, year(`date`) , sum(total_laid_off)
from layoffs_prep2
group by company, year(`date`)
), company_year_rank as 
(select *,
dense_rank() over(partition by years order by total_laid_off desc) as rankings
from company_year
where years is not null
)

select * from
company_year_rank
where rankings <= 5; 
