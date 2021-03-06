USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfoUser]    Script Date: 4/17/2017 5:28:36 PM ******/
DROP PROCEDURE [CPK].[uspGetReportInfoUser]
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfo]    Script Date: 4/17/2017 5:28:36 PM ******/
DROP PROCEDURE [CPK].[uspGetReportInfo]
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfo]    Script Date: 4/17/2017 5:28:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CPK].[uspGetReportInfo]
	@ReportID int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT * , 0 AS Account, 'Admin' AS UserType
	FROM CPK.Reports
	WHERE [ReportID] = @ReportID;
END

GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfoUser]    Script Date: 4/17/2017 5:28:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-04
-- Description:	report info for user
-- =============================================
CREATE PROCEDURE [CPK].[uspGetReportInfoUser]
	@ReportID int,
	@UserId varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT r.*, I.Account, I.UserType
	FROM [CPK].[Reports] R
		INNER JOIN [CPK].[ReportGroup] G
			ON R.ReportID = G.ReportID
		INNER JOIN [CPK].[UserGroup] U
			ON G.GroupID = U.GroupID
		INNER JOIN [CPK].[Users] I
			ON U.UserID = I.UserID
	WHERE R.ReportID = @ReportID AND U.UserID = @UserId AND I.Status = 'Active';
END

GO
