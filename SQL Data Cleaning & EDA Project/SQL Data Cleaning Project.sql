# Data Cleaning Project

CREATE DATABASE World_Layoffs;
SELECT * FROM layoffs;

# Data Cleaning Steps
# 1. Check & Remove Duplicates especially for Primary Keys
# 2. Standardize the data
# 3. Check and handle the Null & Blank values
# 4. Removing any columns & rows that arent necessary (We have intances that this is required esp when the dataset has massive columns/rows that arent required in any analysis stage)
    
    
# Copying all the raw data from the original table to a new table for cleaning

CREATE TABLE Layoffs_Staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT Layoffs_Staging
SELECT * FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
             partition by company, location, industry, total_laid_off, percentage_laid_off, "date") AS "Row Number"
FROM Layoffs_staging;

# Creating a CTE to pull data where duplicates are available i.e > 2

WITH Duplicate_CTE AS (
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM Layoffs_Staging
)
SELECT * FROM Duplicate_CTE 
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = "Casper";

SELECT *
FROM layoffs_staging
WHERE company = "Cazoo";

SELECT *
FROM layoffs_staging
WHERE company = "Hibob";

SELECT *
FROM layoffs_staging
WHERE company = "Wildlife Studios";

SELECT *
FROM layoffs_staging
WHERE company = "Yahoo";


# Copying table: Layoffs_Staging to clipboard and recreating another table: layoffs_staging2 from it and including a new column "Row_Num" for cleaning duplicates.

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  Row_Num INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM Layoffs_Staging;


# Retrieving and deleting duplicate records from table; Layoffs_Staging2
    
SELECT * 
FROM layoffs_staging2
WHERE Row_Num > 1;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE Row_Num > 1;

SELECT * FROM layoffs_staging2;

# 2. Standardizing Data (Trim, Capitalization, Date formats, Integers from Texts...)

--- Trimming Company Column
SELECT Company, TRIM(Company)
FROM layoffs_staging2;

--- Updating the Trimmed column onto the table
UPDATE layoffs_staging2
SET Company = TRIM(Company);

--- Cleaning Industry Column
SELECT DISTINCT Industry
FROM layoffs_staging2
ORDER BY Industry ASC;

SELECT * 
FROM layoffs_staging2
WHERE Industry LIKE "Crypto%";

UPDATE layoffs_staging2
SET Industry = "Crypto"
WHERE Industry LIKE "Crypto%";

--- Cleaning Location column
SELECT DISTINCT Location
FROM layoffs_staging2
ORDER BY Location;
--- Location looks good

--- Cleaning Country
SELECT DISTINCT Country
FROM layoffs_staging2
ORDER BY Country;

UPDATE layoffs_staging2
SET Country = "United States"
WHERE Country = "United States.";

--- Cleaning and formating date column from text data type to Date data type
SELECT `date`,
str_to_date(`date`, "%m/%d/%Y")
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, "%m/%d/%Y");

SELECT `date` FROM layoffs_staging2;

# Since the date column is still in text format, we'll modify it to be a date column
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

--- Changing the percentage_laid_off column from text to INT
ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off INT;

# 3. Checking and handling the Null & Blank values
--- percentage_laid_off column

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE Industry IS NULL
OR Industry = "";

--- Updating the blank cell for below Companies in industry column
# 1. Airbnb Blank cells replacing blanks with same industry for those that operate within the same location
SELECT * 
FROM layoffs_staging2
WHERE Company = "Airbnb";

SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging2
SET Industry = "Travel"
WHERE Company = "Airbnb" AND Industry = "";

# 2. Bally's Interactive
SELECT * 
FROM layoffs_staging2
WHERE Company = "Bally's Interactive";

# 3. Carvana
SELECT * 
FROM layoffs_staging2
WHERE Company = "Carvana";

UPDATE layoffs_staging2
SET Industry = "Transportation"
WHERE Company = "Carvana" AND Industry = "";

# 4. Juul
SELECT * 
FROM layoffs_staging2
WHERE Company = "Juul";

UPDATE layoffs_staging2
SET Industry = "Consumer"
WHERE Company = "Juul" AND Industry = "";

SELECT *
FROM layoffs_staging2
WHERE Industry IS NULL 
OR industry = "";

--- Since in EDA we will be using the Total_laid_off & Percentage_laid_off columns, its a good idea to delete all the rows with both NULL and 
--- blank Total_laid_off & Percentage_laid_off cells from the table

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;

# 4. Removing any Columns
--- There is a row_num column that I added I will need to delete it from the dataset

ALTER TABLE layoffs_staging2
DROP COLUMN Row_Num;

# Now the messy dataset has been cleaned and is ready for analysis

SELECT * 
FROM layoffs_staging2;




















