

USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspGroupList]    Script Date: 4/3/2017 1:34:30 PM ******/
DROP PROCEDURE [CPK].[uspGroupRemove]
GO
DROP PROCEDURE [CPK].[uspGroupReportAdd]
GO
DROP PROCEDURE [CPK].[uspGroupReportRemove]
GO
DROP PROCEDURE [CPK].[uspGroupUserAdd]
GO
DROP PROCEDURE [CPK].[uspGroupUSerRemove]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CPK].[uspGroupRemove]
	@SelectedGroup INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [CPK].[Group]
	WHERE GroupID = @SelectedGroup;
	
	DELETE FROM [CPK].[ChildGroup]
	WHERE ChildGroupID = @SelectedGroup;
END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CPK].[uspGroupReportAdd]
	@GroupID INT,
	@ReportID INT
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [CPK].[ReportGroup](GroupID, ReportID, ModifyDate)
	VALUES (@GroupID, @ReportID, GETDATE());

END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CPK].[uspGroupReportRemove]
	@GroupID INT,
	@ReportID INT
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [CPK].[ReportGroup]
	WHERE GroupID = @GroupID
	  AND ReportID = @ReportID;
	
END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CPK].[uspGroupUserAdd]
	@GroupID INT,
	@UserID VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [CPK].[UserGroup](GroupID, UserID, ModifyDate)
	VALUES (@GroupId, @UserID, GETDATE());

END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CPK].[uspGroupUserRemove]
	@GroupID INT,
	@UserID VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [CPK].[UserGroup]
	WHERE GroupID = @GroupID
	  AND UserID = @UserID;
	
END
GO


