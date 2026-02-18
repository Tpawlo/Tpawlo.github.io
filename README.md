# Tpawlo.github.io
#   **CS-499 Computer Science Capstone**


## Exploratory Data Analysis Report Using MySQL: 
This project explores a dataset covering different companies that were impacted by the Coronavirus Pandemic. Using  MySQL, I cleaned the data, created queries, and performed aggregations that will help one better understand the trends and overall impact that the pandemic had on different types of companies in different locations around the world. 


# Original Artifact:

-- Exploratory Data Analysis

```
Select *
FROM layoffsdata2 LIMIT 3000;


Select  MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffsdata2;


Select *
FROM layoffsdata2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


Select company, SUM(total_laid_off)
FROM layoffsdata2
GROUP BY company
ORDER BY 2 desc;

Select MIN(`date`), MAX(`date`)
FROM layoffsdata2;

Select country, SUM(total_laid_off)
FROM layoffsdata2
GROUP BY country
ORDER BY 2 desc;


Select *
FROM layoffsdata2;

Select YEAR(`date`), SUM(total_laid_off)
FROM layoffsdata2
GROUP BY YEAR(`date`)
ORDER BY 2 desc;


Select stage, SUM(total_laid_off)
FROM layoffsdata2
GROUP BY stage
ORDER BY 2 desc;

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffsdata2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


SELECT * FROM layoffsdata2;


WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffsdata2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
 SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;



SELECT company, SUM(total_laid_off)
FROM layoffsdata2
GROUP BY company
ORDER BY 2 desc;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffsdata2
GROUP BY company, YEAR(`date`)
ORDER BY 3 desc
;
```




# Code Review Video:
[Click here to watch the code review video](https://www.youtube.com/watch?v=2yWYi0GbsFI)



# Enhancement One: Software Design and Engineering
## Enhancement Narative:
    I had to use a personal project for this artifact since I had to delete many source files from previous projects due to low storage. I thought this was a good project to work on since it was a personal project. I worked on it before, and this was an opportunity to continue thinking about the project, seeing how I can improve my queries to further analyze the dataset. My goal is to enter the field of data analysis, and this project will help me showcase the skills needed for this type of career. Knowledge of data cleaning, databases, MySQL, querying, and data manipulation are all very pertinent skills related to data analysis. Designing, writing, and maintaining the code are key parts of software development that were also demonstrated in this project. This project was improved in a few ways, including adding views and stored procedures to improve the software design and engineering principles within the project. I also added comments to help explain my code, as well as my thoughts behind creating it.

     I believe I met the three outcomes that I had planned to with this project enhancement. The three course outcomes I thought I would achieve through this enhancement include: Employ strategies for building collaborative environments that enable diverse audiences to support organizational decision-making in the field of computer science; design, develop, and deliver professional-quality oral, written, and visual communications that are coherent, technically sound, and appropriately adapted to specific audiences and contexts; and develop a security mindset that anticipates adversarial exploits in software architecture and designs to expose potential vulnerabilities, mitigate design flaws, and ensure privacy and enhanced security of data and resources.  I feel as though I did meet the first one since I made queries that anyone can look at and use to help analyze the data and make better, data-backed decisions, even if the person does not hold a technical background with MySQL. Secondly, I included comments for both the original code as well as my enhancements, which go over what the code does and my thought process behind designing and writing the code. Lastly, I developed a security mindset when creating views. With views, one can create a table that can be queried on that only contains part of the original table. This helps limit the amount of unnecessary or potentially-sensitive data that unauthorized users have access to. 





## Software Design and Engineering Enhancements:

```


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
GROUP BY location, country
ORDER BY country;


-- Stored procedure of the top 30 companies that faced the most amount of layoffs. It can
-- be recalled later on to find the top thirty countries with the greatest number of layoffs
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
```







# Enhancement Two: Algorithms and Data Structure
## Enhancement Narative:
    I had to use a personal project for this artifact since I had to delete many source files from previous projects due to low storage on my personal computer. I thought this was a good project to work on since it was a personal project. I worked on it before, and this was an opportunity to continue thinking about the project, seeing how I can improve my queries to further analyze the dataset. My goal is to enter the field of data analysis, and this project will help me showcase the skills needed for this type of career. Knowledge of data cleaning, databases, MySQL, querying, and data manipulation are all very pertinent skills related to data analysis. This week, I tried to hone my skills related to algorithms and data structure. I added an index to strengthen the structure and querying ability of my dataset. I also added a pre-fix sum algorithm to see the ranking of different countries that experienced layoffs. These data structures and algorithms help the overall efficiency and storage of data.
     I did meet the course outcomes that I had planned on achieving through this milestone. The three outcomes I focused on in this milestone were to design, develop, and deliver professional-quality oral, written, and visual communications that are coherent, technically sound, and appropriately adapted to specific audiences and contexts; design and evaluate computing solutions that solve a given problem using algorithmic principles and computer science practices and standards appropriate to its solution while managing the trade-offs involved in design choices; and demonstrate an ability to use well-founded and innovative techniques, skills, and tools in computing practices for the purpose of implementing computer solutions that deliver value and accomplish industry-specific goals. I included comments that explain my thought process and what each query does. I used algorithms to help solve analysis problems and make data analysis a much easier and more efficient process. Lastly, I used computer science practices and techniques to help reach goals specific to the data science industry, such as strengthening queries to make them more efficient, optimize storage, and get the most information out of my data. 






## Algorithms and Data Structure Enhancements:


```

-- In order to index on country, we must specify a specific length for the country string
ALTER TABLE layoffsdata2
MODIFY country VARCHAR(100);

-- This is going to create a composite index on the country and date columns
-- This is going to allow us to more efficiently look at the different countries
-- in the dataset and when they experienced the most layoffs.
CREATE  INDEX country_date_in
ON layoffsdata2 (country, `date`);


-- This shows all of the layoffs that occurred in China, ordering by the earliest to latest recorded. This
-- query uses the composite index to first find the specified country, then order on date. 
SELECT *
FROM layoffsdata2
WHERE country = 'China'
ORDER BY date ASC;


-- This does the same as the query above, but for the United States. We can see when we queried on China, only 13 rows were 
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
-- This query uses the composite index
SELECT `date`, SUM(total_laid_off) AS daily_laid_off
FROM layoffsdata2
GROUP BY `date`
ORDER BY `date` ASC
LIMIT 1000;


-- This is a window function that selects the company, year, and total laid off. It shows the top companies
-- that experienced the most layoffs each year, not just overall. It then ranks each company from 
-- most to least layoffs per year, starting over for each year. This window function does not yet use a CTE,
-- but will later be strengthened with one. 

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
```


# Enhancement Three: Databases
## Enhancement Narative:

    I had to use a personal project for this artifact since I had to delete many source files from previous projects due to low storage on my personal computer. I thought this was a good project to work on since it was a personal project. I worked on it before, and this was an opportunity to continue thinking about the project, seeing how I can improve my queries to further analyze the dataset. My goal is to enter the field of data analysis, and this project will help me showcase the skills needed for this type of career. Knowledge of data cleaning, databases, MySQL, querying, and data manipulation are all very important skills related to data analysis. This week I enhanced the database portion of this assignment. While the whole project is in MySQL working on a database, I tried to perform several different enhancements that would optimize the efficiency and structure of the database. First, I furthered a previous enhancement by adding a Common Table Expression to a window function to make it more readable and organized. Then, I changed some of the data types to help with storage and make querying faster. Lastly, I used null and check constraints to ensure that there were no null values and all values were within an appropriate and expected range. This helps with data validation and accuracy. 
    I met the three course outcomes I had planned on achieving in this module. First, I employed strategies for building collaborative environments that enable diverse audiences to support organizational decision-making in the field of computer science, I also designed, developed, and delivered professional-quality oral, written, and visual communications that are coherent, technically sound, and appropriately adapted to specific audiences, and lastly I demonstrated an ability to use well-founded and innovative techniques, skills, and tools in computing practices for the purpose of implementing computer solutions that deliver value and accomplish industry-specific goals. At this point, I have achieved all of the five course outcomes




## Database Enhancements:

```

-- Here, we added a common table expression to the window function from above. By using a CTE, the
-- query becomes much more readable and reusable. In both, we apply a dense ranking function
-- to year and total laid off to find the top companies that experienced the most layoffs each
-- year. With the use of CTE's, we can seperate the logic between finding how many were laid off
-- each year and ranking the companies from greatest to least. First, we found the sum of
-- layoffs by company each year with the Common Table Expression, and then we used the
-- window funtion to rank the companies each year. I also limited it to the top 5 companies
-- each year to get a better, cleaner look at the top layoffs each year.

WITH yearly_layoffs AS (
	SELECT
		company, 
		YEAR(`date`) AS year, 
        SUM(total_laid_off) AS total_laid_off
		FROM layoffsdata2
        WHERE `date` IS NOT NULL
        GROUP BY company, year
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





-- This shows all of the columns with null values. Ultimately, we would like a table
-- with no null values present
SELECT *
FROM layoffsdata2
WHERE company IS NULL
   OR location IS NULL
   OR total_laid_off IS NULL
   OR `date` IS NULL;


-- This sets any null values for company to unknown. Then we will add a constraint
-- to fully ensure no null values are allowed to be entered into the tablr

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


-- Here, we must delete the records with no date in order to add the
-- constraint that the date must be present. Now, we have a dataset where
-- all information is present. 
DELETE FROM layoffsdata2
WHERE `date` IS NULL;

ALTER TABLE layoffsdata2
MODIFY COLUMN `date` date  NOT NULL;





-- This shows all of the columns with null values. After the constraints, we can see there
-- are now no null values in the dataset. Now if more data is found and added to the table,
-- we can ensure that only complete, non-null values can be added thanks to the constraints.
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
```






