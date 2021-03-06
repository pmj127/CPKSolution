USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspUserGroupInsert]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspUserGroupInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspReportViewCount]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspReportViewCount]
GO
/****** Object:  StoredProcedure [CPK].[uspReportUpdate]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspReportUpdate]
GO
/****** Object:  StoredProcedure [CPK].[uspReportListSort]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspReportListSort]
GO
/****** Object:  StoredProcedure [CPK].[uspReportList]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspReportList]
GO
/****** Object:  StoredProcedure [CPK].[uspReportInsert]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspReportInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspReportGroupInsert]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspReportGroupInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspReportDetail]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspReportDetail]
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfoUser]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspGetReportInfoUser]
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfo]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspGetReportInfo]
GO
/****** Object:  StoredProcedure [CPK].[uspCheckReportAuthority]    Script Date: 4/5/2017 12:59:37 AM ******/
DROP PROCEDURE [CPK].[uspCheckReportAuthority]
GO
/****** Object:  StoredProcedure [CPK].[uspCheckReportAuthority]    Script Date: 4/5/2017 12:59:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-03-23
-- Description:	check authority and insert log
-- =============================================
CREATE PROCEDURE [CPK].[uspCheckReportAuthority]
	@ReportID int,
	@UserID varchar(30),
	@GroupCount int output
AS
BEGIN
	SET NOCOUNT ON;

	SELECT @GroupCount = COUNT(*)
	FROM [CPK].[UserGroup] U
		INNER JOIN [CPK].[ReportGroup] R
			ON U.GroupID = R.GroupID
	WHERE U.UserID = @UserID AND R.ReportID = @ReportID;
	
	IF @GroupCount > 0 
		BEGIN
			INSERT INTO [CPK].[ReportViewLog]
			VALUES(@ReportID, @UserID, GETDATE());
		END
END
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfo]    Script Date: 4/5/2017 12:59:37 AM ******/
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

    SELECT * 
	FROM CPK.Reports
	WHERE [ReportID] = @ReportID;
END

GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfoUser]    Script Date: 4/5/2017 12:59:37 AM ******/
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

    SELECT * 
	FROM [CPK].[Reports] R
		INNER JOIN [CPK].[ReportGroup] G
			ON R.ReportID = G.ReportID
		INNER JOIN [CPK].[UserGroup] U
		ON G.GroupID = U.GroupID

	WHERE R.ReportID = @ReportID AND U.UserID = @UserId;
END

GO
/****** Object:  StoredProcedure [CPK].[uspReportDetail]    Script Date: 4/5/2017 12:59:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-03-20
-- Description:	report detail view
-- =============================================
CREATE PROCEDURE [CPK].[uspReportDetail]
	@ReportID int
AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ReportID, ReportName, ReportPath, Description, IsActive, ModifyDate
	FROM [CPK].[Reports]
	WHERE ReportID = @ReportID;
END

GO
/****** Object:  StoredProcedure [CPK].[uspReportGroupInsert]    Script Date: 4/5/2017 12:59:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-03-25
-- Description:	insert reportgroup
-- =============================================
CREATE PROCEDURE [CPK].[uspReportGroupInsert]
	@GroupID int,
	@ReportID int
AS
BEGIN

	SET NOCOUNT ON;

    MERGE [CPK].[ReportGroup] AS T
	USING (VALUES(@GroupID, @ReportID)) AS S(GroupID, ReportID)
		ON T.GroupID = S.GroupID AND T.ReportID = S.ReportID
	WHEN NOT MATCHED THEN
		INSERT(GroupID, ReportID)
		VALUES(@GroupID, @ReportID);
END

GO
/****** Object:  StoredProcedure [CPK].[uspReportInsert]    Script Date: 4/5/2017 12:59:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-03-01
-- Description:	insert report
-- =============================================
CREATE PROCEDURE [CPK].[uspReportInsert]
	@ReportName varchar(50),
	@ReportPath varchar(100),
	@Description varchar(400),
	@IsActive varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [CPK].[Reports](ReportName, ReportPath, Description, IsActive, ModifyDate)
	VALUES (@ReportName, @ReportPath, @Description, @IsActive, GETDATE());

END

GO
/****** Object:  StoredProcedure [CPK].[uspReportList]    Script Date: 4/5/2017 12:59:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CPK].[uspReportList]
	@PageNo INT = 1,
	@PageSize INT = 10,
	@ReportName VARCHAR(50) = NULL,
	@IsActive VARCHAR(50) = NULL
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
/****** Object:  StoredProcedure [CPK].[uspReportListSort]    Script Date: 4/5/2017 12:59:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CPK].[uspReportListSort]
	@PageNo INT = 1,
	@PageSize INT = 10,
	@ReportName VARCHAR(50) = NULL,
	@IsActive VARCHAR(50) = NULL,
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
/****** Object:  StoredProcedure [CPK].[uspReportUpdate]    Script Date: 4/5/2017 12:59:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-03-20
-- Description:	report edit
-- =============================================
CREATE PROCEDURE [CPK].[uspReportUpdate]
	@ReportID int,
	@ReportName varchar(50),
	@ReportPath varchar(100),
	@Description varchar(400),
	@IsActive varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [CPK].[Reports]
	SET ReportName = @ReportName,
		ReportPath = @ReportPath,
		Description = @Description,
		IsActive = @IsActive,
		ModifyDate = GETDATE()
	WHERE ReportID = @ReportID;

END

GO
/****** Object:  StoredProcedure [CPK].[uspReportViewCount]    Script Date: 4/5/2017 12:59:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-04
-- Description:	report log count
-- =============================================
CREATE PROCEDURE [CPK].[uspReportViewCount]
	@StartDate datetime,
	@EndDate datetime
AS
BEGIN

	SET NOCOUNT ON;

	SELECT L.ReportID,MIN(R.ReportName) ReportName, YEAR(L.ViewDate) ViewYear ,MONTH(L.ViewDate) ViewMonth
	, COUNT(*) ViewCount
	FROM [CPK].[ReportViewLog] L
		INNER JOIN [CPK].[Reports] R
		ON L.ReportID = R.ReportID
	WHERE (L.ViewDate >= @StartDate OR @StartDate IS NULL)
		AND (L.ViewDate <= @EndDate OR @EndDate IS NULL)
	GROUP BY L.ReportID, YEAR(L.ViewDate),MONTH(L.ViewDate)
	ORDER BY ReportName, ViewYear, ViewMonth;
END

GO
/****** Object:  StoredProcedure [CPK].[uspUserGroupInsert]    Script Date: 4/5/2017 12:59:37 AM ******/
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
