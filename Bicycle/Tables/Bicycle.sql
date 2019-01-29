CREATE TABLE [dbo].[Bicycle]
(
	[Id] INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	[InvNumber] NVARCHAR(20) NOT NULL,
	[LastPosition] INT NOT NULL,
	CONSTRAINT [FK_Bike_LastLoc] FOREIGN KEY ([LastPosition]) REFERENCES [Point]([Id])
)