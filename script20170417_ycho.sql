

USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspGroupList]    Script Date: 4/3/2017 1:34:30 PM ******/
DROP PROCEDURE [CPK].[uspReportListByUser]
GO

DROP PROCEDURE [CPK].[uspGroupListByUser]
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
CREATE PROCEDURE [CPK].[uspReportListByUser]
	@GroupId INT,
	@UserID VARCHAR(50) = NULL,
	@PageNo INT = 1,
	@PageSize INT = 10,
	@ReportName VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(DISTINCT(r.ReportID)) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM CPKSolution.CPK.Reports r
		JOIN CPKSolution.CPK.ReportGroup rg
		  ON rg.ReportID = r.ReportID
		JOIN CPKSolution.CPK.UserGroup ug
		  ON ug.GroupID = rg.GroupID
	WHERE ug.UserID = @UserID

	SELECT DISTINCT(r.ReportID), r.ReportName, r.ReportPath, r.Description, r.IsActive, FORMAT(r.ModifyDate,'MMM dd yyyy') ModifyDate
	FROM CPKSolution.CPK.Reports r
		JOIN CPKSolution.CPK.ReportGroup rg
		  ON rg.ReportID = r.ReportID
		JOIN CPKSolution.CPK.UserGroup ug
		  ON ug.GroupID = rg.GroupID
	WHERE ug.UserID = @UserID
	ORDER BY r.ReportID DESC 
		OFFSET (@PageNo -1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION(OPTIMIZE FOR(@PageNo = 1, @PageSize = 10) );

END
GO


CREATE PROCEDURE [CPK].[uspGroupListByUser]
	@GroupId INT,
	@UserID VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(DISTINCT(r.ReportID)) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM CPKSolution.CPK.Reports r
		JOIN CPKSolution.CPK.ReportGroup rg
		  ON rg.ReportID = r.ReportID
		JOIN CPKSolution.CPK.UserGroup ug
		  ON ug.GroupID = rg.GroupID
	WHERE ug.UserID = @UserID

	SELECT DISTINCT(r.ReportID), r.ReportName, r.ReportPath, r.Description, r.IsActive, FORMAT(r.ModifyDate,'MMM dd yyyy') ModifyDate
	FROM CPKSolution.CPK.Reports r
		JOIN CPKSolution.CPK.ReportGroup rg
		  ON rg.ReportID = r.ReportID
		JOIN CPKSolution.CPK.UserGroup ug
		  ON ug.GroupID = rg.GroupID
	WHERE ug.UserID = @UserID
	ORDER BY r.ReportID DESC 
		OFFSET (@PageNo -1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION(OPTIMIZE FOR(@PageNo = 1, @PageSize = 10) );

END
GO







