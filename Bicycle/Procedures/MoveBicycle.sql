/*
Returns 0 - OK
		1 - Error by update
		2 - Trip for the bike is already open
*/
CREATE PROCEDURE [dbo].[MoveBicycle] 
	@BikeId INT, 
	@NewLocation INT,
	@Location INT -- Current Station calling the procedure
AS
BEGIN
	SET NOCOUNT ON;
	-- No open trips exist for the given bike
	IF EXISTS (SELECT [Id] FROM [Bicycle] WHERE [LastPosition] = @Location)
		AND @NewLocation <> @Location
		BEGIN
			IF NOT EXISTS (
				SELECT [Id]
				FROM [Trip]
				WHERE	([Bike] = @BikeId) AND
						([EndPoint] IS NOT NULL))
				BEGIN
					BEGIN TRY
							UPDATE [Bicycle]
							SET [LastPosition] = @NewLocation
							WHERE [Id] = @BikeId
							RETURN 0 -- OK
					END TRY
					BEGIN CATCH
						RETURN 1 -- ERROR
					END CATCH
				END
		END
	RETURN 2 -- Open Trip already exists
END