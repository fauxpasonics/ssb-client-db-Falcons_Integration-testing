CREATE TABLE [dbo].[ManualRun_CRMResults]
(
[contactid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[accountid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorCode] [int] NULL,
[ErrorColumn] [int] NULL,
[CrmErrorMessage] [nvarchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
