USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspGroupList]    Script Date: 4/3/2017 1:34:30 PM ******/
DROP PROCEDURE [CPK].[uspGroupList]
GO
/****** Object:  StoredProcedure [CPK].[uspGroupList]    Script Date: 4/3/2017 1:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yoonsuk Cho
-- Create date: 2017-04-04
-- Description:	select group list
-- =============================================
CREATE PROCEDURE [CPK].[uspGroupList]
	-- Add the parameters for the stored procedure here
	@GroupID int,
	@UserID varchar(30)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @ParentIds TABLE(parentId INT);

    SELECT g.GroupID AS 'id', g.GroupName AS 'text', 0 AS 'parentId'
	FROM [CPK].[Group] g
		LEFT JOIN [CPK].[ChildGroup] c
		ON g.GroupID = c.ChildGroupID
    WHERE c.ChildGroupID IS NULL;

	SELECT g.GroupID AS 'id', g.GroupName AS 'text', c.GroupID AS 'parentId'
	FROM [CPK].[Group] g
		JOIN [CPK].[ChildGroup] c
		ON g.GroupID = c.ChildGroupID;

END

GO
