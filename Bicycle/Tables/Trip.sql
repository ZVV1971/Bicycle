CREATE TABLE [dbo].[Trip]
(
	[Id] INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	[BeginPoint] INT NOT NULL,
	[EndPoint] INT,
	[BeginDate] DATETIME NOT NULL DEFAULT GETDATE(),
	[EndDate] DATETIME NULL,
	[Bike] INT NOT NULL,
	[Rider] INT NOT NULL,
	CONSTRAINT [FK_Trip_BPnt] FOREIGN KEY ([BeginPoint]) REFERENCES [Point]([Id]),
	CONSTRAINT [FK_Trip_EPnt] FOREIGN KEY ([EndPoint]) REFERENCES [Point]([Id]),
	CONSTRAINT [FK_Trip_Rider] FOREIGN KEY ([Rider]) REFERENCES [Person]([Id]),
	CONSTRAINT [FK_Trip_Bike] FOREIGN KEY ([Bike]) REFERENCES [Bicycle]([Id]),
	CONSTRAINT [CHK_Tr_EptEdt_BothNullOrNotNull]
	CHECK  (
				(
					(1)=case when [EndPoint] IS NOT NULL 
						then case when [EndDate] IS NOT NULL 
							then (1) 
							else (0) 
							end 
						else case when [EndDate] IS NOT NULL 
							then (0) 
							else (1) 
							end 
						end
				)
			)
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Начальная точка',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Trip',
    @level2type = N'COLUMN',
    @level2name = N'BeginPoint'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Конечная точка',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Trip',
    @level2type = N'COLUMN',
    @level2name = N'EndPoint'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Дата и время начала',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Trip',
    @level2type = N'COLUMN',
    @level2name = N'BeginDate'