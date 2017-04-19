

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
	FROM CPK.Reports r
		JOIN CPK.ReportGroup rg
		  ON rg.ReportID = r.ReportID
		JOIN CPK.UserGroup ug
		  ON ug.GroupID = rg.GroupID
	WHERE ug.UserID = @UserID
	  AND (rg.GroupID = @GroupId OR 0 = @GroupId);

	SELECT DISTINCT(r.ReportID), r.ReportName, r.ReportPath, r.Description, r.IsActive, FORMAT(r.ModifyDate,'MMM dd yyyy') ModifyDate
	FROM CPK.Reports r
		JOIN CPK.ReportGroup rg
		  ON rg.ReportID = r.ReportID
		JOIN CPK.UserGroup ug
		  ON ug.GroupID = rg.GroupID
	WHERE ug.UserID = @UserID
	  AND (rg.GroupID = @GroupId OR 0 = @GroupId)
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

	
	WITH TREELIST AS
	(
		SELECT G.GroupID, G.GroupName, C.GroupID ParentID, 1 Authority
			FROM [CPK].[Group] G
				INNER JOIN [CPK].[UserGroup] U
			        ON G.GroupID = U.GroupID
				LEFT OUTER JOIN [CPK].[ChildGroup] C
			        ON G.GroupID = C.ChildGroupID
		WHERE U.UserID = @UserID

		UNION ALL

		SELECT G.GroupID, G.GroupName, NULL ParentID, Authority + 1 Authority
			FROM TREELIST T
				INNER JOIN [CPK].[Group] G
		            ON T.ParentID = G.GroupID

		UNION ALL

		SELECT G.GroupID, G.GroupName, C.GroupID ParentID, Authority + 1 Authority
			FROM TREELIST T
				INNER JOIN [CPK].[Group] G
					ON T.ParentID = G.GroupID
				INNER JOIN [CPK].[ChildGroup] C
					ON G.GroupID = C.ChildGroupID
		WHERE T.ParentID IS NOT NULL

	)
	SELECT GroupID AS 'id', GroupName AS 'text',  MIN(ParentID) AS 'parentId', MIN(Authority) AS 'Authority'
	    FROM TREELIST
	GROUP BY GroupID, GroupName
	ORDER BY id
	OPTION (MAXRECURSION 4);


END
GO







