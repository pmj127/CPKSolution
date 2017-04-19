

USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspGroupList]    Script Date: 4/3/2017 1:34:30 PM ******/
DROP PROCEDURE [CPK].[uspReportListByGroup]
GO
DROP PROCEDURE [CPK].[uspUserListByGroup]
GO
DROP PROCEDURE [CPK].[uspGroupAdd]
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
CREATE PROCEDURE [CPK].[uspReportListByGroup]
--	@PageNo INT = 1,
--	@PageSize INT = 10,
--	@ReportName VARCHAR(50) = NULL,
--	@IsActive VARCHAR(50) = NULL, 
	@GroupId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(r.ReportID) AS TotalRows
	FROM CPK.Reports r
	LEFT JOIN [CPK].[ReportGroup] g
	ON r.ReportID = g.ReportID
	WHERE (g.GroupID = @GroupId OR @GroupId = 0)
	GROUP BY r.ReportID;

	SELECT r.ReportID, r.ReportName, r.ReportPath, r.Description, r.IsActive, FORMAT(r.ModifyDate,'MMM dd yyyy') ModifyDate
	FROM CPK.Reports r
	LEFT JOIN [CPK].[ReportGroup] g
	ON r.ReportID = g.ReportID
	WHERE (g.GroupID = @GroupId OR @GroupId = 0)
	GROUP BY r.ReportID, r.ReportName, r.ReportPath, r.Description, r.IsActive, r.ModifyDate
	ORDER BY ReportID DESC;

END
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CPK].[uspUserListByGroup]
--	@PageNo INT = 1,
--	@PageSize INT = 10,
--	@FullName NVARCHAR(50) = NULL,
	@UserID VARCHAR(30) = NULL,
	@GroupId INT
AS
BEGIN
	SET NOCOUNT ON;

    SELECT COUNT(u.UserID) AS TotalRows
	FROM [CPK].[Users] u
	LEFT JOIN [CPK].[UserGroup] g
	ON u.UserID = g.UserID
	WHERE (g.GroupID = @GroupId OR @GroupId = 0)
	GROUP BY u.UserID;

	SELECT u.UserID, u.UserType, u.FullName, u.Account, u.Status, FORMAT(u.ModifyDate, 'MMM dd yyyy') AS ModifyDate
	FROM [CPK].[Users] u
	LEFT JOIN [CPK].[UserGroup] g
	ON u.UserID = g.UserID
	WHERE (g.GroupID = @GroupId OR @GroupId = 0)
	GROUP BY u.UserID, u.UserType, u.FullName, u.Account, u.Status, u.ModifyDate
	ORDER BY u.UserID DESC;
END
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CPK].[uspGroupAdd]
	@GroupName NVARCHAR(50) ,
	@Description NVARCHAR(100),
	@ParentGroup INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MAXINT int;
	SELECT @MAXINT = MAX(GroupID) + 1  FROM [CPK].[Group];

    INSERT INTO [CPK].[Group](GroupID, GroupName, Description, IsActive, ModifyDate)
	VALUES (@MAXINT, @GroupName, @Description, 'TRUE', GETDATE());

	INSERT INTO [CPK].[ChildGroup](GroupID, ChildGroupID)
	VALUES (@ParentGroup, @MAXINT);
END
GO
