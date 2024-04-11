USE Titanic;
-- 1. **Survival Rates by Passenger Class:**

SELECT 
    PClass,
    COUNT(*) AS TotalPassengers,
    SUM(Survived) AS Survivors,
    (SUM(Survived) / COUNT(*)) * 100 AS SurvivalRate
FROM 
    Ticketing T
JOIN 
    Survival S ON T.PNumber = S.PNumber
GROUP BY 
    PClass;


-- 2. **Survival Rates by Age Group:**

SELECT 
    CASE
        WHEN PAge < 18 THEN 'Child'
        WHEN PAge >= 18 AND PAge < 65 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeGroup,
    COUNT(*) AS TotalPassengers,
    SUM(Survived) AS Survivors,
    (SUM(Survived) / COUNT(*)) * 100 AS SurvivalRate
FROM 
    Passenger P
JOIN 
    Survival S ON P.PNumber = S.PNumber
GROUP BY 
    AgeGroup;


-- 3. **Impact of Family Size on Survival:**

SELECT 
    CASE
        WHEN PSib + PPOC = 0 THEN 'Single'
        WHEN PSib + PPOC > 0 THEN 'With Family'
    END AS FamilyStatus,
    COUNT(*) AS TotalPassengers,
    SUM(Survived) AS Survivors,
    (SUM(Survived) / COUNT(*)) * 100 AS SurvivalRate
FROM 
    Companions C
JOIN 
    Survival S ON C.PNumber = S.PNumber
GROUP BY 
    FamilyStatus;


-- 4. **Survival Rates by Embarkation Port:**

SELECT 
    Embarked,
    COUNT(*) AS TotalPassengers,
    SUM(Survived) AS Survivors,
    (SUM(Survived) / COUNT(*)) * 100 AS SurvivalRate
FROM 
    Ticketing T
JOIN 
    Survival S ON T.PNumber = S.PNumber
GROUP BY 
    Embarked;




-- 7. **Comparison of Survival Rates Across Gender and Class:**

SELECT 
    PGender,
    PClass,
    COUNT(*) AS TotalPassengers,
    SUM(Survived) AS Survivors,
    (SUM(Survived) / COUNT(*)) * 100 AS SurvivalRate
FROM 
    Passenger P
JOIN 
    Ticketing T ON P.PNumber = T.PNumber
JOIN 
    Survival S ON P.PNumber = S.PNumber
GROUP BY 
    PGender, PClass;


-- 8. **Survival Rates Among Families vs. Individuals:**

SELECT 
    CASE
        WHEN PSib + PPOC > 0 THEN 'With Family'
        ELSE 'Individual'
    END AS FamilyStatus,
    COUNT(*) AS TotalPassengers,
    SUM(Survived) AS Survivors,
    (SUM(Survived) / COUNT(*)) * 100 AS SurvivalRate
FROM 
    Companions C
JOIN 
    Survival S ON C.PNumber = S.PNumber
GROUP BY 
    FamilyStatus;


-- 9. **Analysis of Survival Among Crew Members:**

SELECT 
    CASE
        WHEN PClass = 0 THEN 'Crew Member'
        ELSE 'Passenger'
    END AS PassengerType,
    COUNT(*) AS TotalPassengers,
    SUM(Survived) AS Survivors,
    (SUM(Survived) / COUNT(*)) * 100 AS SurvivalRate
FROM 
    Passenger P
JOIN 
    Ticketing T ON P.PNumber = T.PNumber
JOIN 
    Survival S ON P.PNumber = S.PNumber
GROUP BY 
    PassengerType;


-- 10. **Investigation of Survival Patterns Among Special Passenger Groups:**

SELECT 
    CASE
        WHEN PAge < 18 THEN 'Child'
        WHEN PAge >= 60 THEN 'Elderly'
        ELSE 'Regular'
    END AS PassengerGroup,
    COUNT(*) AS TotalPassengers,
    SUM(Survived) AS Survivors,
    (SUM(Survived) / COUNT(*)) * 100 AS SurvivalRate
FROM 
    Passenger P
JOIN 
    Survival S ON P.PNumber = S.PNumber
GROUP BY 
    PassengerGroup;


-- 11. **List the discount dollar value for 10 female passengers that survived the sinking:**
SELECT p.PNumber, p.PGender AS 'Gender', p.PAge AS 'Age', t.FarePrice AS 'Ticket Price', t.FarePrice * 0.1 AS 'Discount', s.Survived
FROM Passenger P JOIN Ticketing T ON p.PNumber=t.PNumber
JOIN Survival S ON t.PNumber=s.PNumber
WHERE p.PGender='female' 
AND s.Survived=1
LIMIT 10;



-- 12. **Show the average fare price for female passengers that survived the sinking:**
SELECT AVG(t.FarePrice) AS 'Average Fare Price For Survived Female Passenger'
FROM Passenger P JOIN Ticketing T ON p.PNumber=t.PNumber
JOIN Survival S ON t.PNumber=s.PNumber
WHERE p.PGender='female' 
AND s.Survived=1;



-- 13. **List the names and the number of siblings, parents or children with them for 10 female first-class passengers that survived the sinking.**
SELECT ps.PName, p.PGender, t.PClass, c.PSib AS 'Siblings', c.PPOC AS 'Parents or Children'
FROM PassengerName ps JOIN Passenger p ON ps.PNumber=p.PNumber
JOIN Ticketing t ON p.PNumber=t.PNumber
JOIN Companions c ON t.PNumber=c.PNumber
JOIN Survival s on c.PNumber=s.PNumber
WHERE p.PGender='female' 
AND s.Survived=1
AND t.PClass=1
LIMIT 10;


-- 14. **Show the average age of first-class male passengers that died in the sinking.**
SELECT AVG(p.PAge) AS 'Average Age of Killed First Class Male Passenger'
FROM Passenger P JOIN Ticketing T ON p.PNumber=t.PNumber
JOIN Survival S ON t.PNumber=s.PNumber
WHERE p.PGender='male' 
AND s.Survived=0
AND t.PClass=1;



-- 15. **List the number of female and male first-class passengers that died in the sinking.**
SELECT CONCAT (p.PGender,' First Class Dead:',count(p.PNumber)) AS 'First Class Death By Gender'
FROM Passenger P JOIN Ticketing T ON p.PNumber=t.PNumber
JOIN Survival S ON t.PNumber=s.PNumber
WHERE s.Survived=0
AND t.PClass=1
GROUP by p.PGender;