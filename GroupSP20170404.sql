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

    SELECT GroupID AS 'id', GroupName AS 'text'
	FROM [CPK].[Group]
	WHERE GroupID NOT IN (SELECT ChildGroupID FROM [CPK].[ChildGroup]);
		
	
	
END

GO
