CREATE TABLE [dbo].[Point]
(
	[Id] INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	[LocationName] NVARCHAR(50) NOT NULL,
	[Latitude] DECIMAL(18,15) NOT NULL DEFAULT 54.9167,
	[Longitude] DECIMAL(18,15) NOT NULL DEFAULT 27.55, 
    CONSTRAINT [UNQ_Pt_Location] UNIQUE ([LocationName], [Latitude], [Longitude])
)