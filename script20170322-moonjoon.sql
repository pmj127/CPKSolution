USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspReportViewLogInsert]    Script Date: 3/23/2017 12:01:52 AM ******/
DROP PROCEDURE [CPK].[uspReportViewLogInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspReportViewLogInsert]    Script Date: 3/23/2017 12:01:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-03-22
-- Description:	insert reportviewlog
-- =============================================
CREATE PROCEDURE [CPK].[uspReportViewLogInsert]
	@ReportID int,
	@UserID varchar(30)
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO [CPK].[ReportViewLog]
	VALUES(@ReportID, @UserID, GETDATE());
END

GO
