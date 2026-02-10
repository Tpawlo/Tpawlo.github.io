
-- Exploratory Data Analysis

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




