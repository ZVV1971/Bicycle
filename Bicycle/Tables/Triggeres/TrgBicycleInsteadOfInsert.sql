CREATE TRIGGER [TrgBicycleInsteadOfInsert]
ON [dbo].[Bicycle]
INSTEAD OF INSERT
AS
BEGIN
	SET NOCOUNT ON
	IF (SELECT DISTINCT [LastPosition] FROM inserted) IS NULL
		INSERT INTO [dbo].Bicycle
			SELECT	[InvNumber],
			(SELECT [Id] FROM [Point] WHERE [LocationName] = N'Base')
			FROM inserted
	ELSE
		INSERT INTO [Bicycle] ([InvNumber], [LastPosition])
		SELECT [InvNumber], [LastPosition] FROM inserted
END