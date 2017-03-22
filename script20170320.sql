USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspReportUpdate]    Script Date: 3/20/2017 10:02:11 PM ******/
DROP PROCEDURE [CPK].[uspReportUpdate]
GO
/****** Object:  StoredProcedure [CPK].[uspReportListSort]    Script Date: 3/20/2017 10:02:11 PM ******/
DROP PROCEDURE [CPK].[uspReportListSort]
GO
/****** Object:  StoredProcedure [CPK].[uspReportList]    Script Date: 3/20/2017 10:02:11 PM ******/
DROP PROCEDURE [CPK].[uspReportList]
GO
/****** Object:  StoredProcedure [CPK].[uspReportInsert]    Script Date: 3/20/2017 10:02:11 PM ******/
DROP PROCEDURE [CPK].[uspReportInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspReportDetail]    Script Date: 3/20/2017 10:02:11 PM ******/
DROP PROCEDURE [CPK].[uspReportDetail]
GO
/****** Object:  StoredProcedure [CPK].[uspLogin]    Script Date: 3/20/2017 10:02:11 PM ******/
DROP PROCEDURE [CPK].[uspLogin]
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfo]    Script Date: 3/20/2017 10:02:11 PM ******/
DROP PROCEDURE [CPK].[uspGetReportInfo]
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfo]    Script Date: 3/20/2017 10:02:11 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspLogin]    Script Date: 3/20/2017 10:02:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-02-16
-- Description:	Compare UserId and Password, retrun user info
-- =============================================
CREATE PROCEDURE [CPK].[uspLogin] 
	-- Add the parameters for the stored procedure here
	@UserID varchar(30),
	@Password varchar(200)
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UserID,  FullName, Phone, Email, UserRole, UserType, Account
	FROM [CPK].[Users]
	WHERE UserID = @UserID AND Password = @Password;
END

GO
/****** Object:  StoredProcedure [CPK].[uspReportDetail]    Script Date: 3/20/2017 10:02:11 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspReportInsert]    Script Date: 3/20/2017 10:02:11 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspReportList]    Script Date: 3/20/2017 10:02:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CPK].[uspReportList]
	@PageNo INT = 1,
	@PageSize INT = 10,
	@ReportName VARCHAR(50) = NULL,
	@IsActive CHAR(1) = NULL
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
/****** Object:  StoredProcedure [CPK].[uspReportListSort]    Script Date: 3/20/2017 10:02:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CPK].[uspReportListSort]
	@PageNo INT = 1,
	@PageSize INT = 10,
	@ReportName VARCHAR(50) = NULL,
	@IsActive CHAR(1) = NULL,
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
/****** Object:  StoredProcedure [CPK].[uspReportUpdate]    Script Date: 3/20/2017 10:02:11 PM ******/
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
