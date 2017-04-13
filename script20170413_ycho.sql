

USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspGroupList]    Script Date: 4/3/2017 1:34:30 PM ******/
DROP PROCEDURE [CPK].[uspReportUserList]
GO
DROP PROCEDURE [CPK].[uspReportUserListSort]
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
CREATE PROCEDURE [CPK].[uspReportUserList]
	@PageNo INT = 1,
	@PageSize INT = 10,
	@ReportName VARCHAR(50) = NULL,
	@IsActive VARCHAR(50) = NULL,
	@UserID VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(*) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM CPK.Reports
	WHERE (ReportName LIKE '%'+@ReportName+'%' OR @ReportName IS NULL OR LEN(@ReportName) = 0) 
		AND (IsActive = @IsActive OR @IsActive IS NULL OR LEN(@IsActive) = 0);

	SELECT ReportID, ReportName, ReportPath, Description, IsActive, FORMAT(ModifyDate,'MMM dd yyyy') ModifyDate
	FROM CPK.Reports
	WHERE (ReportName LIKE '%'+@ReportName+'%' OR @ReportName IS NULL OR LEN(@ReportName) = 0) 
		AND (IsActive = @IsActive OR @IsActive IS NULL OR LEN(@IsActive) = 0)
	ORDER BY ReportID DESC 
		OFFSET (@PageNo -1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION(OPTIMIZE FOR(@PageNo = 1, @PageSize = 10) );

END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CPK].[uspReportUserListSort]
	@PageNo INT = 1,
	@PageSize INT = 10,
	@ReportName VARCHAR(50) = NULL,
	@IsActive VARCHAR(50) = NULL,
	@UserID VARCHAR(50) = NULL,
	@Sort VARCHAR(50) = 'ReportIDDESC'
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(*) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM CPK.Reports
	WHERE (ReportName LIKE '%'+@ReportName+'%' OR @ReportName IS NULL OR LEN(@ReportName) = 0) 
		AND (IsActive = @IsActive OR @IsActive IS NULL OR LEN(@IsActive) = 0);

	SELECT ReportID, ReportName, ReportPath, Description, IsActive, FORMAT(ModifyDate,'MMM dd yyyy') ModifyDate
	FROM CPK.Reports
	WHERE (ReportName LIKE '%'+@ReportName+'%' OR @ReportName IS NULL OR LEN(@ReportName) = 0) 
		AND (IsActive = @IsActive OR @IsActive IS NULL OR LEN(@IsActive) = 0)
	ORDER BY CASE WHEN @Sort = 'ReportIDDESC' THEN ReportID END DESC,
			 CASE WHEN @Sort ='ReportNameDESC' THEN ReportName END DESC,
			 CASE WHEN @Sort = 'ModifyDateDESC' THEN ModifyDate END DESC,
			 CASE WHEN @Sort = 'ReportIDASC' THEN ReportID END ASC ,
			 CASE WHEN @Sort = 'ReportNameASC' THEN ReportName END ASC ,
			 CASE WHEN @Sort = 'ModifyDateASC' THEN ModifyDate END ASC,
			 ReportID
		OFFSET (@PageNo -1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION(OPTIMIZE FOR(@PageNo = 1, @PageSize = 10) );

END
GO



