# EDA - Exploratory Data Analysis using a clean dataset Layoffs_Staging2

--- The layoffs for the companies in my dataset started when COVID-19 struck (Time Period)
SELECT MIN(Date) AS "Start Date", MAX(Date) AS "End Date"
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2;

--- I am randomly looking at these:

# The highest Layoff a company has made and the highest % layoff (100%) a company has made
SELECT MAX(Total_laid_off) AS "Big Layoff", MAX(percentage_laid_off) AS "Highest % Layoff"
FROM layoffs_staging2;

# Print everything with max % layoffs, order by total_laid_off DESC
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY Total_laid_off DESC;

# Print everything with max % layoff order by funds_raised_millions DESC (Top 5 highest funds raised)
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC LIMIT 5;

# Print the Company and the Sum of Total Layoff Order by Total lay off desc (Top 5 Co.s with biggest layoffs)
SELECT Company, SUM(total_laid_off) AS "Total Layoff Per Company"
FROM layoffs_staging2
GROUP BY Company
ORDER BY SUM(total_laid_off) DESC LIMIT 5;

# Print the Industry and the Sum of Total Layoff Order by Total lay off desc (Top 5 Industries that were hit hard with the layoffs)
SELECT Industry, SUM(total_laid_off) AS "Total Layoff Per Company"
FROM layoffs_staging2
GROUP BY Industry
ORDER BY SUM(total_laid_off) DESC LIMIT 5;


# Print the Industry and the Sum of Total Layoff Order by Total lay off (Bottom 5 Industries that were not hit so hard with the layoffs)
SELECT Industry, SUM(total_laid_off) AS "Total Layoff Per Company"
FROM layoffs_staging2
WHERE Industry IS NOT NULL
GROUP BY Industry
ORDER BY SUM(total_laid_off) ASC LIMIT 5;


# Print the country and the Sum of Total Layoff Order by Total lay off (Top 5 countries that were hit hard with the layoffs)
SELECT Country, SUM(total_laid_off) AS "Total Layoff Per Company"
FROM layoffs_staging2
GROUP BY Country
ORDER BY SUM(total_laid_off) DESC LIMIT 5;


# Print the country and the Sum of Total Layoff Order by Total lay off (Bottom 5 countries that were not hit so hard with the layoffs)
SELECT Country, SUM(total_laid_off) AS "Total Layoff Per Company"
FROM layoffs_staging2
GROUP BY Country
ORDER BY SUM(total_laid_off) ASC LIMIT 15;

# Print the country and the Sum of Total Layoff Order by Total lay off (Bottom 11th to 15th countries that were not hit so hard with the layoffs)
SELECT Country, SUM(total_laid_off) AS "Total Layoff Per Company"
FROM layoffs_staging2
GROUP BY Country
ORDER BY SUM(total_laid_off) ASC LIMIT 5 OFFSET 10;

# Print the Year and the Sum of Total Layoff, Order by date/year latest (To get layoffs per year)
SELECT YEAR(Date) AS "Year", SUM(total_laid_off) AS "Total Layoff Per Company"
FROM layoffs_staging2
WHERE YEAR(Date) IS NOT NULL
GROUP BY YEAR(Date)
ORDER BY YEAR(Date) DESC;

# Print the stage of the company and the Sum of Total Layoff Order by Total lay offs (Getting top 10 total layoffs per company's phase)
SELECT stage, SUM(total_laid_off) AS "Total Layoff Per Company"
FROM layoffs_staging2
GROUP BY Stage
ORDER BY SUM(total_laid_off) DESC LIMIT 10;

# Progression of layoffs - Rolling sum
--- Checking the months available in my dataset
SELECT MONTH(Date) AS "Month"
FROM layoffs_staging2
GROUP BY MONTH(Date) ORDER BY MONTH(Date);

# Print the total layoff per month on yearly basis
SELECT SUBSTRING(Date, 1, 7) AS "Year & Month", SUM(Total_laid_off) AS "Total Layoff/Co."
FROM layoffs_staging2
WHERE SUBSTRING(Date, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(Date, 1, 7) 
ORDER BY SUBSTRING(Date, 1, 7) ASC;

# Print a rolling sum of layoffs on yearly basis per month using a CTE
WITH Rolling_Total AS (
    SELECT SUBSTRING(`Date`, 1, 7) AS `Year_Month`, SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`Date`, 1, 7) IS NOT NULL
    GROUP BY `Year_Month`
    ORDER BY 1 ASC
)
SELECT `Year_Month`, total_off,
SUM(total_off) OVER(ORDER BY `Year_Month`) AS rolling_total
FROM Rolling_Total;

# Print a rolling sum of layoffs on yearly basis using a CTE for each company for comparative analysis
SELECT Company, YEAR(`Date`) AS "Year", SUM(Total_laid_off) AS "Total Layoffs"
FROM layoffs_staging2
GROUP BY Company, YEAR(`Date`)
ORDER BY Company ASC;

--- Ranking the above companies in DESC per the Total Layoffs creating a CTE
SELECT Company, YEAR(`Date`) AS "Year", SUM(Total_laid_off) AS "Total Layoffs"
FROM layoffs_staging2
GROUP BY Company, YEAR(`Date`)
ORDER BY 3 DESC;

--- The CTE for above EDA

WITH Company_Year AS (
    SELECT Company, YEAR(`Date`) AS `Year`, SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE `Date` IS NOT NULL
    GROUP BY Company, YEAR(`Date`)
)
SELECT *,
SUM(total_off) OVER(PARTITION BY Company ORDER BY `Year` ASC) AS rolling_total
FROM Company_Year
ORDER BY Company ASC, `Year` ASC;

SELECT Company, YEAR(`Date`) AS "Year", SUM(Total_laid_off) AS "Total Layoffs",
dense_rank() OVER(partition by YEAR(`Date`)) AS "Rank"
FROM layoffs_staging2
WHERE `Date` IS NOT NULL
GROUP BY Company, YEAR(`Date`)
ORDER BY "Rank" ASC;
