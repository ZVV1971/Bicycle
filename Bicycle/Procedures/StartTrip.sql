/*
Returns 0 - OK
		1 - Error by insert
		2 - Bike is being rented not from the current location 
*/
CREATE PROCEDURE [dbo].[StartTrip]
	@BikeId INT, 
	@Location INT,
	@Rider INT,
	@StartDT DATETIME
AS
BEGIN
	SET NOCOUNT ON;
	-- check if bike is being lent from its current location
	IF EXISTS (SELECT [Id] FROM [Bicycle] WHERE [LastPosition] = @Location)
	-- check if for the bike no trips are yet started
		IF NOT EXISTS (
				SELECT [Id]
				FROM [Trip]
				WHERE	([Bike] = @BikeId) AND
						([EndPoint] IS NOT NULL))
			BEGIN
				BEGIN TRY
					DECLARE @tempDT DATETIME
					SET @tempDT = GETDATE()
					INSERT INTO [Trip] ([BeginPoint], [Rider], [Bike], [BeginDate])
					VALUES (@Location, @Rider, @BikeId, IIF(@StartDT IS NULL, @tempDT, @StartDT))
					RETURN 0 -- OK
				END TRY
				BEGIN CATCH
					RETURN 1 -- Error
				END CATCH
			END
	RETURN 2 -- Current location is different from that where the bike is being rented from
END