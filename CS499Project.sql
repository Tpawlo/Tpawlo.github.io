-- Exploratory Data Analysis
-- This project explores a dataset including companies that faced partial or complete
-- layoffs during the COVID pandemic during the years of 2020 and 2023. 


-- This allows us to look at all of the dataset values
Select *
FROM layoffsdata2 
LIMIT 3000;










-- Algorithms and Data Structure Enhancements: 

-- In order to index on country, we must specific the length of the country string
ALTER TABLE layoffsdata2
MODIFY country VARCHAR(100);

-- This is going to create a composite index on the country and date columns
-- This is going to allow us to more efficiently look at the different countries
-- in the dataset and when they experienced the most lay offs.
CREATE  INDEX country_date_in
ON layoffsdata2 (country, `date`);


-- This shows all of the layoffs that occurred in China, ordering by the earliest to latest recorded. This
-- query uses the composite index to first find the specified country, then order on date. 
-- This query uses the index
SELECT *
FROM layoffsdata2
WHERE country = 'China'
ORDER BY date ASC;


-- This does the same as the query above, but for the United States. We can see when we used China, only 13 rows were 
-- returned, here, there are 1,294 rows. We can further analyze the source of this data, as well as research how each
-- country responded to the pandemic, to explain this large discrepancy. Did the pandemic disproportionately affect
-- some countries more than others, or can this gap be attributed to a lack of research and data. 
-- This query uses the index
SELECT *
FROM layoffsdata2
WHERE country = 'United States'
ORDER BY date ASC
limit 3000;


-- This shows how many people were laid off around the world every single day
-- This query uses the index
SELECT `date`, SUM(total_laid_off) AS daily_laid_off
FROM layoffsdata2
GROUP BY `date`
ORDER BY `date` ASC
LIMIT 1000;


-- This is a window function that selects the company, year, and total laid off. It shows the top companies
-- that experienced the most layoffs each year, not just overall. It then ranks each company from 
-- most to least lay offs per year, starting over for each year. This window function does not yet use a CTE. 
SELECT
    company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off,
    DENSE_RANK() OVER (
        PARTITION BY YEAR(`date`)
        ORDER BY SUM(total_laid_off) DESC
		) AS ranked
FROM layoffsdata2
WHERE `date` IS NOT NULL
GROUP BY company, year;





-- This is a rolling total CTE. It shows the rolling total of layoffs each month
-- The original query was further partitioned on country, dividing the data by the
-- different countries, showing the rolling total for each country by month, in
-- alphabetical order. 

WITH Rolling_Total AS 
(
SELECT country, SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffsdata2
WHERE `date` IS NOT NULL
GROUP BY country, `MONTH`
)
SELECT country, `MONTH`, total_off,
 SUM(total_off) OVER(
 PARTITION BY country
 ORDER BY `MONTH`
 ) AS rolling_total
FROM Rolling_Total
ORDER BY country, MONTH;




















-- Database Enhancement


-- Here, we added a common table expression to the window function. By using a CTE, the
-- query becomes much more readable and reusable. In both, we apply a dense ranking function
-- to year and laid off to find the top companies that experienced the most layoffs each
-- year. With the use of CTE's, we can seperate the logic between how mnany were laid off
-- each year and ranking the companies from greatest to least. First, we found the sum of
-- layoffs by company each year with the Common Table Expression, and then we used the
-- window funtion to rank the companies each year. I also limited it to the top 5 companies
-- each year to get a better, cleaner look at the top layoffs each year.

WITH yearly_layoffs AS (
	SELECT
		company, 
		YEAR(`date`) ASyear, 
        SUM(total_laid_off) AS total_laid_off
		FROM layoffsdata
        WHERE `date` IS NOT NULL
        GROUP BY company, YEAR(`date`)
        ),
	rankings AS (
    SELECT
		company, 
        year, 
        total_laid_off,
        DENSE_RANK() OVER (             
        PARTITION BY year
        ORDER BY total_laid_off DESC
        ) AS company_ranking
        FROM yearly_layoffs)
        SELECT * 
        FROM rankings
        WHERE company_ranking <= 5;





DESCRIBE layoffsdata2;

-- This changes the data type of country to varchar instead of text. This helps with storage
-- and makes for more efficient querying of the dataset.
ALTER TABLE layoffsdata2
MODIFY country VARCHAR(25);


DESCRIBE layoffsdata2;



-- This shows all of the columns with null values
SELECT *
FROM layoffsdata2
WHERE company IS NULL
   OR location IS NULL
   OR total_laid_off IS NULL
   OR `date` IS NULL;


-- This sets any null values for company to unknown.Then we will add a constraint
-- to fully ensure no null values are allowed

UPDATE layoffsdata2
SET company = 'Unknown'
WHERE company IS NULL;


ALTER TABLE layoffsdata2
MODIFY COLUMN company varchar(100) NOT NULL;



-- This sets any null values for location to unknown, then we will add a constraint
-- to fully ensure no null values are allowed

UPDATE layoffsdata2
SET location = 'Unknown'
WHERE location IS NULL;

ALTER TABLE layoffsdata2
MODIFY COLUMN location varchar(100) NOT NULL;

-- This sets any null values for total laid off to 0, then we will add 
-- a constraint to fully ensure no null values are allowed. I did not choose to
-- delete these records where total laid off is unknown since it still gives us 
-- insight into which types of companies and how many were affected by the pandemic.


UPDATE layoffsdata2
SET total_laid_off = 0
WHERE total_laid_off IS NULL;

ALTER TABLE layoffsdata2
MODIFY COLUMN total_laid_off int  NOT NULL;


-- Here, we must delete the companies with no date in order to add the
-- constraint that the date must be present. Now, we have a dataset where
-- all information is present. 
DELETE FROM layoffsdata2
WHERE `date` IS NULL;

ALTER TABLE layoffsdata2
MODIFY COLUMN `date` date  NOT NULL;





-- This shows all of the columns with null values. After the constraints, we can see there
-- are now no null values in the dataset. Now if more data is found and added to the table,
-- we can ensure that only complete, non-null values can be added.
SELECT *
FROM layoffsdata2
WHERE company IS NULL
   OR location IS NULL
   OR total_laid_off IS NULL
   OR `date` IS NULL;



-- This constraint ensures that all entries have a valid date range that includes the times of the pandemic.
ALTER TABLE layoffsdata2
ADD CONSTRAINT valid_date_range CHECK (`date` >= '2020-01-01' AND `date` <= '2024-01-01');



-- This constraint ensures that all entries have a valid percent range, which ranges from 0 to 1 (100).
ALTER TABLE layoffsdata2
ADD CONSTRAINT valid_percent_range CHECK (percentage_laid_off>= 0 AND percentage_laid_off <= 1);



















-- This shows us the max total number of employees that were laid off from
--  a single company, as well as the percentage of that company that was laid off
Select   MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffsdata2;


-- This results in all the companies that shut down (complete layoffs)
Select *
FROM layoffsdata2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;



-- This shows how many layoffs each company experienced, ordered from greatest to least
Select company, SUM(total_laid_off)
FROM layoffsdata2
GROUP BY company
ORDER BY 2 desc;


-- This shows the time range from when this data was recorded
Select MIN(`date`), MAX(`date`)
FROM layoffsdata2;


-- This shows how many lay offs each country experienced, ordered greatest to least
Select country, SUM(total_laid_off)
FROM layoffsdata2
GROUP BY country
ORDER BY 2 desc;



Select *
FROM layoffsdata2;


-- This shows how many lay offs occurred each year
Select YEAR(`date`), SUM(total_laid_off)
FROM layoffsdata2
GROUP BY YEAR(`date`)
ORDER BY 2 desc;


-- This shows the total number of lay offs, organized by the stage the business was in
Select stage, SUM(total_laid_off)
FROM layoffsdata2
GROUP BY stage
ORDER BY 2 desc;


-- This shows the number of layoffs that occurred each month
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffsdata2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;



SELECT * FROM layoffsdata2;




-- This shows which companies and in which year experienced the most layoffs.
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffsdata2
GROUP BY company, YEAR(`date`)
ORDER BY 3 desc
;














-- SOFTWARE DESIGN AND ENGINEERING ENHANCEMENTS:


-- This view creates a table that includes all columns except for funds raised.
-- If we want to share this information with the public, but not do not want to
-- disclose how much money each company raised, rather for security or legal
-- reasons, we can use this view table and query on this. 
CREATE VIEW layoffs_no_sensitive_data AS 
SELECT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country
FROM layoffsdata2;

SELECT * FROM layoffs_no_sensitive_data
LIMIT 3000;

-- This query uses the view to see how many lay offs were experienced by businesses in each stage.
-- This gives an insight into the type and success of a company, but still allows us to keep some
-- privacy while withholding information about how much funding was raised by these companies.
SELECT  stage, SUM(total_laid_off)
FROM layoffs_no_sensitive_data
GROUP BY  stage
ORDER BY 2 DESC
;





-- This view creates a table where no null values are allowed. Say we are working on a very important
-- project where it is extremely important that all of our data is correct and has come from reliable
-- sources. We may not be able to trust records where some of the values are unknown. It is safer to 
-- simply take the entire record out than trying to guess or assume its value. After we have this
-- table where all records are completely full, we can query on the data an continue on with our project.

CREATE VIEW layoffs_no_nulls AS 
SELECT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
FROM layoffsdata2
WHERE company != '' AND location != '' AND industry != ''
AND total_laid_off != '' AND percentage_laid_off != '' AND
date IS NOT NULL AND stage != '' AND country != '' AND
funds_raised_millions != '';

SELECT * FROM layoffs_no_nulls
LIMIT 3000;


-- This uses the view table with no null values to query based on the total number of layoffs 
-- in each industry. We can see the consumer industry faced the most, followed by retail, other,
-- and transportation, etc. This makes sense since people had less money to spend on unneccessary
-- goods, as well as public spaces (such as malls or trains) were shut down or faced limits
-- as to how many people could enter the space.
SELECT industry, SUM(total_laid_off)
FROM layoffs_no_nulls
GROUP BY industry
ORDER BY 2 desc;

-- This uses the view to show the sum of the total number of employees laid off
-- in each country, grouped by the location in which the company was located in.

SELECT country, location, SUM(total_laid_off)
FROM layoffs_no_nulls
GROUP BY country, location
ORDER BY country;


-- Stored procedure of the top 30 companies that faced the most amount of layoffs
drop procedure top_thirty_layoffs;

DELIMITER $$

CREATE PROCEDURE top_thirty_layoffs()
BEGIN
    SELECT company, 
    MAX(location) AS location, 
    MAX(industry) AS industry, 
	SUM(total_laid_off) AS total_laid_off,
    MAX(percentage_laid_off) AS percentage_laid_off, 
    MAX(date) AS date,
    MAX(stage) AS stage,
	MAX(country) AS country, 
    MAX(funds_raised_millions) AS funds_raised_in_millions
    FROM layoffsdata2
    GROUP BY company
    ORDER BY SUM(total_laid_off) DESC
    LIMIT 30;
END $$

DELIMITER ;


-- This shows the results of the stored procedure just created. We can see Amazon,
-- Google, Meta, Salesforce, and Microsoft had the highest total number of lay offs.
CALL top_thirty_layoffs();






