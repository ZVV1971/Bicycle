/*
Шаблон скрипта после развертывания							
--------------------------------------------------------------------------------------
 В данном файле содержатся инструкции SQL, которые будут добавлены в скрипт построения.		
 Используйте синтаксис SQLCMD для включения файла в скрипт после развертывания.			
 Пример:      :r .\myfile.sql								
 Используйте синтаксис SQLCMD для создания ссылки на переменную в скрипте после развертывания.		
 Пример:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

-- Base should always exist
INSERT INTO Point ([LocationName])
VALUES	(N'Base')

-- A couple of bikes
INSERT INTO [Bicycle] ([InvNumber])
VALUES	(N'000 000 001'),	-- #1
		(N'000 000 002'),	-- #2
		(N'000 000 003'),	-- #3
		(N'000 020 001'),	-- #4
		(N'000 003 004')	-- #5

--Some persons too
INSERT INTO [Person]
VALUES	(N'Ivan'),	--#1
		(N'Vasya'), --#2
		(N'Peter'), --#3
		(N'Olga') , --#4
		(N'Ivan')	--#5

--And a set of rent points as well
INSERT INTO [Point]
VALUES	(N'A', DEFAULT, DEFAULT),	-- #2
		(N'B', DEFAULT, DEFAULT),	-- #3
		(N'C', DEFAULT, DEFAULT),	-- #4
		(N'D', DEFAULT, DEFAULT),	-- #5
		(N'E', DEFAULT, DEFAULT)	-- #6

-- Move bikes to their renting places
DECLARE @base INT 
SELECT @base = [Id] FROM [Point] WHERE [LocationName] = N'Base'
DECLARE @i INT = 1
DECLARE @j INT
SET @j = @i + 1
DECLARE @k INT
SELECT @k = COUNT([Id]) FROM [Bicycle]

WHILE @i <= @k
	BEGIN
		EXEC MoveBicycle @i, @j, @base
		SET @i += 1
		SET @j += 1
	END

-- Organize trips for the riders on the corresponding bikes
DECLARE Bike_cursor CURSOR FOR
SELECT [Id], [LastPosition] FROM [Bicycle]

DECLARE @tbl TABLE -- Will contain numbers from 1 to 5
([Id] INT UNIQUE CHECK (([Id]<=5)AND([Id]>=1)))
INSERT INTO @tbl VALUES (1), (2), (3), (4), (5)

DECLARE @end INT, @Bike INT, @Location INT
SET @i = 1

OPEN Bike_cursor

FETCH NEXT FROM Bike_cursor
INTO @Bike, @Location

WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT TOP 1 @end = [Id] FROM @tbl ORDER BY NEWID()
		EXEC StartTrip @Bike, @Location, @end, NULL
		FETCH NEXT FROM Bike_cursor INTO @Bike, @Location
	END

CLOSE Bike_cursor
DEALLOCATE Bike_cursor

-- Put Bikes to their Endpoints
WHILE @i <= 5
BEGIN
	SELECT TOP 1 @end = [Id] FROM @tbl ORDER BY NEWID()
	EXEC EndTrip @i, @end, NULL
	SET @i += 1
END
