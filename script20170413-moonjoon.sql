USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspUserGroupDelete]    Script Date: 4/13/2017 1:22:42 PM ******/
DROP PROCEDURE [CPK].[uspUserGroupDelete]
GO
/****** Object:  StoredProcedure [CPK].[uspReportGroupDelete]    Script Date: 4/13/2017 1:22:42 PM ******/
DROP PROCEDURE [CPK].[uspReportGroupDelete]
GO
/****** Object:  StoredProcedure [CPK].[uspReportGroupDelete]    Script Date: 4/13/2017 1:22:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-13
-- Description:	delete reportgroup
-- =============================================
CREATE PROCEDURE [CPK].[uspReportGroupDelete]
	@GroupID int,
	@ReportID int
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM [CPK].[ReportGroup] 
	WHERE GroupID = @GroupID AND  ReportID = @ReportID;

END

GO
/****** Object:  StoredProcedure [CPK].[uspUserGroupDelete]    Script Date: 4/13/2017 1:22:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-13
-- Description:	Delete usergroup
-- =============================================
CREATE PROCEDURE [CPK].[uspUserGroupDelete]
	-- Add the parameters for the stored procedure here
	@GroupID int,
	@UserID varchar(30)
AS
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [CPK].[UserGroup] 
	WHERE GroupID = @GroupID AND UserID = @UserID;
END

GO
