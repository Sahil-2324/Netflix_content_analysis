CREATE DATABASE netflix_project;
USE netflix_project;

-- Main table
CREATE TABLE movies (
  show_id VARCHAR(50),
  type VARCHAR(20),
  title VARCHAR(255),
  director VARCHAR(255),
  cast VARCHAR(2000),
  country VARCHAR(1000),
  date_added VARCHAR(50),
  release_year VARCHAR(20),
  rating VARCHAR(10),
  duration VARCHAR(50),
  listed_in VARCHAR(100),
  description TEXT,
  duration_cleaned VARCHAR(20),
  duration_unit VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'D:/Data Analytics Projects/Netflix/Dataset/updated2_netflix_titles.csv'
INTO TABLE movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Basic Count & Distribution Queries
# Count total titles by type (Movie vs TV Show):
SELECT type, COUNT(*) AS Titles 
FROM movies 
GROUP BY type;

# Count titles by release year to see content addition trends:
SELECT release_year, COUNT(*) AS Count
FROM movies 
GROUP BY release_year 
ORDER BY release_year;

# Top genres listed:
SELECT listed_in, COUNT(*) List_count 
FROM movies 
GROUP BY listed_in 
ORDER BY COUNT(*) DESC LIMIT 10;

# Distribution of ratings:
SELECT rating, COUNT(*) AS Rating_count 
FROM movies 
GROUP BY rating 
ORDER BY COUNT(*) DESC;

-- Content Freshness and Trends
# Titles added each year/month (extract year/month from date_added):
SELECT YEAR(STR_TO_DATE(date_added, '%M %e, %Y')) AS Year_Added, COUNT(*) AS Count
FROM movies GROUP BY Year_Added 
ORDER BY Year_Added;

# Average duration of movies and shows:
SELECT type, AVG(CAST(duration_cleaned AS UNSIGNED)) AS AvgDuration 
FROM movies GROUP BY type;

-- Gap Analysis
# Find genres or countries with low content numbers:
SELECT country, COUNT(*) AS Content_count 
FROM movies 
GROUP BY country 
ORDER BY COUNT(*) ASC LIMIT 10;

# Titles by country and type for regional content gaps:
SELECT country, type, COUNT(*) AS Content 
FROM movies 
GROUP BY country, type 
ORDER BY country, type;

-- Advanced Analysis
# Identify directors with the most content:
SELECT director, COUNT(*) AS Count 
FROM movies 
WHERE director != '' 
GROUP BY director 
ORDER BY COUNT(*) DESC LIMIT 10;

# Most frequent actors:
SELECT cast, COUNT(*) Count 
FROM movies WHERE cast != '' 
GROUP BY cast 
ORDER BY COUNT(*) DESC LIMIT 10;

# Genres underrepresented in specific countries:
SELECT 
  country, 
  listed_in, 
  COUNT(*) AS num_titles
FROM movies
WHERE 
  country IS NOT NULL 
  AND TRIM(country) NOT IN ('', 'Unknown', 'N/A') 
  AND listed_in IS NOT NULL 
  AND TRIM(listed_in) NOT IN ('', 'Unknown', 'N/A')
GROUP BY country, listed_in
HAVING num_titles < 5
ORDER BY num_titles ASC;

# Identify countries with the least diverse content genres:
SELECT country, COUNT(DISTINCT listed_in) AS genre_variety
FROM movies
GROUP BY country
ORDER BY genre_variety ASC;

--  Release Trend and Seasonality
# Analyze the distribution of added titles by month/year for release strategy insights:
SELECT
  YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year_added,
  MONTH(STR_TO_DATE(date_added, '%M %d, %Y')) AS month_added,
  COUNT(*) AS titles_added
FROM movies
GROUP BY year_added, month_added
ORDER BY year_added, month_added;

-- Rating Gap Analysis
# Discover genres lacking suitable content for young audiences (PG/Family):
SELECT listed_in, COUNT(*) AS family_titles
FROM movies
WHERE rating IN ('PG', 'TV-G', 'G', 'PG-13')
GROUP BY listed_in
HAVING family_titles < 10
ORDER BY family_titles ASC;

-- Duration and Content Quality Gaps
# Identify genres predominantly featuring shorter content (possible need for more long-form titles):
SELECT listed_in, AVG(CAST(duration_cleaned AS UNSIGNED)) AS avg_duration
FROM movies
WHERE type = 'Movie'
GROUP BY listed_in
ORDER BY avg_duration ASC;

-- Director and Cast Diversity
# Find directors and actors who have very few titles (potential talent gaps):
SELECT director, COUNT(*) AS num_titles
FROM movies
WHERE director IS NOT NULL AND director != ''
GROUP BY director
HAVING num_titles = 1
ORDER BY director;

-- Content Overlap/Gaps by Type
# Compare movie vs TV show coverage by genre and region:
SELECT country, listed_in, type, COUNT(*) AS total
FROM movies
GROUP BY country, listed_in, type
ORDER BY country, listed_in, type;

-- Missing Years Gap
# Identify years with very low or no content released/added:
SELECT release_year, COUNT(*) AS Count
FROM movies
GROUP BY release_year
HAVING COUNT(*) < 5
ORDER BY release_year;

select count(title) from movies

