# Tpawlo.github.io
#   **CS-499 Computer Science Capstone**


## Exploratory Data Analysis Report Using MySQL: 
This project explores a dataset covering different companies that were impacted by the Coronavirus Pandemic. Using  MySQL, I cleaned the data, created queries, and performed aggregations that will help one better understand the trends and overall impact that the pandemic had on different types of companies in different locations around the world. 


# Original Artifact:

-- Exploratory Data Analysis

``` Select *
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





# Software Design and Engineering Enhancements:







# Enhancement Two: Algorithms and Data Structure
## Enhancement Narative:





# Algorithms and Data Structure Enhancements:





# Enhancement Three: Databases
## Enhancement Narative:





# Database Enhancements:








