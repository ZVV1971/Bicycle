/*
Returns 0 - OK
		1 - Error by insert
		2 - Bike is not in the trip now
*/
CREATE PROCEDURE [dbo].[EndTrip]
	@BikeId INT, 
	@EndLocation INT,
	@EndDT DATETIME
AS
BEGIN
	SET NOCOUNT ON;
	-- check if the bike is in the trip now
	IF EXISTS (
		SELECT [Id]
		FROM [Trip]
		WHERE	([Bike] = @BikeId) AND
				([EndPoint] IS NULL))
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				DECLARE @tempDT DATETIME
				SET @tempDT = GETDATE()

				UPDATE [Trip] 
					SET [EndPoint] = @EndLocation, [EndDate] = IIF(@EndDT IS NULL, @tempDT, @EndDT)
					WHERE [Bike] = @BikeId

				UPDATE [Bicycle] SET [LastPosition] = @EndLocation
					WHERE [Id] = @BikeId

				COMMIT
				RETURN 0 -- OK
			END TRY
			BEGIN CATCH
				ROLLBACK
				RETURN 1 -- Error by update
			END CATCH
		END
	RETURN 2 -- Bike is not in the trip now
END