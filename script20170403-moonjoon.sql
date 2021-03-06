USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspUserGroupInsert]    Script Date: 4/3/2017 1:34:30 PM ******/
DROP PROCEDURE [CPK].[uspUserGroupInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspUserGroupInsert]    Script Date: 4/3/2017 1:34:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-03-25
-- Description:	insert usergroup
-- =============================================
CREATE PROCEDURE [CPK].[uspUserGroupInsert]
	-- Add the parameters for the stored procedure here
	@GroupID int,
	@UserID varchar(30)
AS
BEGIN

	SET NOCOUNT ON;

    MERGE [CPK].[UserGroup] AS T
	USING (VALUES(@GroupID, @UserID)) AS S(GroupID, UserID)
		ON T.GroupID = S.GroupID AND T.UserID = S.UserID
	WHEN NOT MATCHED THEN
		INSERT(GroupID, UserID)
		VALUES(@GroupID, @UserID);
END

GO
