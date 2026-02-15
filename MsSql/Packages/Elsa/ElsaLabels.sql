-- =============================================
-- Name:        ElsaLabels
-- Description: Elsa 3.5.3 Labels table for SQL Server
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaLabels')
BEGIN
    CREATE TABLE [dbo].[ElsaLabels]
    (
        [Id] NVARCHAR(450) NOT NULL,
        [Name] NVARCHAR(450) NOT NULL,
        [TenantId] NVARCHAR(450) NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    )
END
