USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspUserGroupInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspUserGroupInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspReportViewCount]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspReportViewCount]
GO
/****** Object:  StoredProcedure [CPK].[uspReportUpdate]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspReportUpdate]
GO
/****** Object:  StoredProcedure [CPK].[uspReportListSort]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspReportListSort]
GO
/****** Object:  StoredProcedure [CPK].[uspReportList]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspReportList]
GO
/****** Object:  StoredProcedure [CPK].[uspReportInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspReportInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspReportGroupInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspReportGroupInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspReportDetail]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspReportDetail]
GO
/****** Object:  StoredProcedure [CPK].[uspMessageUserInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspMessageUserInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspMessageUnreadCount]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspMessageUnreadCount]
GO
/****** Object:  StoredProcedure [CPK].[uspMessageSendList]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspMessageSendList]
GO
/****** Object:  StoredProcedure [CPK].[uspMessageReceiveList]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspMessageReceiveList]
GO
/****** Object:  StoredProcedure [CPK].[uspMessageInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspMessageInsert]
GO
/****** Object:  StoredProcedure [CPK].[uspMessageDetail]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspMessageDetail]
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfoUser]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspGetReportInfoUser]
GO
/****** Object:  StoredProcedure [CPK].[uspGetReportInfo]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspGetReportInfo]
GO
/****** Object:  StoredProcedure [CPK].[uspCheckReportAuthority]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP PROCEDURE [CPK].[uspCheckReportAuthority]
GO
ALTER TABLE [CPK].[Message] DROP CONSTRAINT [DF_Message_SendDate]
GO
/****** Object:  Table [CPK].[Recipient]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP TABLE [CPK].[Recipient]
GO
/****** Object:  Table [CPK].[Message]    Script Date: 4/8/2017 2:14:28 PM ******/
DROP TABLE [CPK].[Message]
GO
/****** Object:  Table [CPK].[Message]    Script Date: 4/8/2017 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CPK].[Message](
	[MessageID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Content] [nvarchar](1000) NULL,
	[UserID] [varchar](30) NOT NULL,
	[SendDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CPK].[Recipient]    Script Date: 4/8/2017 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CPK].[Recipient](
	[MessageID] [int] NOT NULL,
	[UserID] [varchar](30) NOT NULL,
	[ReadDate] [datetime] NULL,
 CONSTRAINT [PK_Recipient] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [CPK].[Message] ADD  CONSTRAINT [DF_Message_SendDate]  DEFAULT (getdate()) FOR [SendDate]
GO
/****** Object:  StoredProcedure [CPK].[uspCheckReportAuthority]    Script Date: 4/8/2017 2:14:28 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspGetReportInfo]    Script Date: 4/8/2017 2:14:28 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspGetReportInfoUser]    Script Date: 4/8/2017 2:14:28 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspMessageDetail]    Script Date: 4/8/2017 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-08
-- Description:	read message 
-- =============================================
CREATE PROCEDURE [CPK].[uspMessageDetail]
	@MessageID int,
	@UserID varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 M.MessageID, M.Title, M.Content, M.UserID, SendDate,
		(SELECT UserID + ';' FROM [CPK].[Recipient] WHERE MessageID = @MessageID FOR XML  PATH('')) Recipients
	FROM [CPK].[Message] M
		INNER JOIN [CPK].[Recipient] R
			ON M.MessageID = R.MessageID
	WHERE M.MessageID = @MessageID AND 
		(M.UserID = @UserID OR R.UserID = @UserID);
	
	UPDATE [CPK].[Recipient]
	SET ReadDate = GETDATE()
	WHERE ReadDate IS NULL AND MessageID = @MessageID AND UserID = @UserID;

END

GO
/****** Object:  StoredProcedure [CPK].[uspMessageInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-07
-- Description:	send message for admin
-- =============================================
CREATE PROCEDURE [CPK].[uspMessageInsert]
	@Title nvarchar(200),
	@Content nvarchar(1000),
	@UserID varchar(30),
	@Recipient varchar(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @DocHandle INT;
	 
	BEGIN TRY
		BEGIN TRANSACTION;
			INSERT INTO [CPK].[Message](Title, Content, UserID, SendDate)
			VALUES (@Title, @Content, @UserID, GETDATE());

			EXEC sp_xml_preparedocument @DocHandle OUTPUT, @Recipient

			INSERT INTO [CPK].[Recipient](MessageID, UserID)
			SELECT SCOPE_IDENTITY(), UserID
			FROM OPENXML(@DocHandle, '/IDs/ID', 2)
					WITH(UserID varchar(30) 'text()');

			EXEC sp_xml_removedocument @DocHandle;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END

GO
/****** Object:  StoredProcedure [CPK].[uspMessageReceiveList]    Script Date: 4/8/2017 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-07
-- Description:	Message receive List 
-- =============================================
CREATE PROCEDURE [CPK].[uspMessageReceiveList]
	@PageNo INT = 1,
	@PageSize INT = 10,
	@UserID VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(*) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM [CPK].[Message] M
		INNER JOIN [CPK].[Recipient] R
			ON M.MessageID = R.MessageID
	WHERE R.UserID = @UserID;

	SELECT M.MessageID, M.Title, M.UserID, FORMAT(M.SendDate,'MMM dd yyyy') ReceiveDate,
		ISNULL(FORMAT(R.ReadDate,'MMM dd yyyy'), '') ReadDate
	FROM [CPK].[Message] M
		INNER JOIN [CPK].[Recipient] R
			ON M.MessageID = R.MessageID
	WHERE R.UserID = @UserID
	ORDER BY M.MessageID DESC 
		OFFSET (@PageNo -1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION(OPTIMIZE FOR(@PageNo = 1, @PageSize = 10) );

END
GO
/****** Object:  StoredProcedure [CPK].[uspMessageSendList]    Script Date: 4/8/2017 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-07
-- Description:	Message Send List 
-- =============================================
CREATE PROCEDURE [CPK].[uspMessageSendList]
	@PageNo INT = 1,
	@PageSize INT = 10,
	@UserID VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(*) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM (
		SELECT M.MessageID
		FROM [CPK].[Message] M
			INNER JOIN [CPK].[Recipient] R
				ON M.MessageID = R.MessageID
		WHERE M.UserID = @UserID
		GROUP BY M.MessageID) C;

	SELECT M.MessageID, MIN(M.Title) Title, FORMAT(MIN(M.SendDate),'MMM dd yyyy') SendDate,
		CONCAT(MIN(R.UserID), IIF(COUNT(*) = 1,'', CONCAT('(',COUNT(*)-1,')'))) UserID
	FROM [CPK].[Message] M
		INNER JOIN [CPK].[Recipient] R
			ON M.MessageID = R.MessageID
	WHERE M.UserID = @UserID
	GROUP BY M.MessageID
	ORDER BY M.MessageID DESC 
		OFFSET (@PageNo -1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION(OPTIMIZE FOR(@PageNo = 1, @PageSize = 10) );

END
GO
/****** Object:  StoredProcedure [CPK].[uspMessageUnreadCount]    Script Date: 4/8/2017 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-08
-- Description:	COUNT UNREAD MESSAGE
-- =============================================
CREATE PROCEDURE [CPK].[uspMessageUnreadCount]
	@UserID varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT COUNT(*) MessageCount
	FROM [CPK].[Recipient]
	WHERE ReadDate IS NULL AND UserID = @UserID;

END

GO
/****** Object:  StoredProcedure [CPK].[uspMessageUserInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-04-07
-- Description:	send message for user
-- =============================================
CREATE PROCEDURE [CPK].[uspMessageUserInsert]
	@Title nvarchar(200),
	@Content nvarchar(1000),
	@UserID varchar(30),
	@Recipient varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION;
			INSERT INTO [CPK].[Message](Title, Content, UserID, SendDate)
			VALUES (@Title, @Content, @UserID, GETDATE());

			INSERT INTO [CPK].[Recipient](MessageID, UserID)
			VALUES (SCOPE_IDENTITY(), @Recipient);
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		THROW;
	END CATCH

END

GO
/****** Object:  StoredProcedure [CPK].[uspReportDetail]    Script Date: 4/8/2017 2:14:28 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspReportGroupInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspReportInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspReportList]    Script Date: 4/8/2017 2:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Moonjoon Park
-- Create date: 2017-03-20
-- Description:	report List 
-- =============================================
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
/****** Object:  StoredProcedure [CPK].[uspReportListSort]    Script Date: 4/8/2017 2:14:28 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspReportUpdate]    Script Date: 4/8/2017 2:14:28 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspReportViewCount]    Script Date: 4/8/2017 2:14:28 PM ******/
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
/****** Object:  StoredProcedure [CPK].[uspUserGroupInsert]    Script Date: 4/8/2017 2:14:28 PM ******/
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
