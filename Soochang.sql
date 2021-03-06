USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspUserListSort]    Script Date: 2017-04-04 11:13:45 AM ******/
DROP PROCEDURE [CPK].[uspUserListSort]
GO
/****** Object:  StoredProcedure [CPK].[uspUserList]    Script Date: 2017-04-04 11:13:45 AM ******/
DROP PROCEDURE [CPK].[uspUserList]
GO
/****** Object:  StoredProcedure [CPK].[uspUpdateUser]    Script Date: 2017-04-04 11:13:45 AM ******/
DROP PROCEDURE [CPK].[uspUpdateUser]
GO
/****** Object:  StoredProcedure [CPK].[uspRegister]    Script Date: 2017-04-04 11:13:45 AM ******/
DROP PROCEDURE [CPK].[uspRegister]
GO
/****** Object:  StoredProcedure [CPK].[uspRegister]    Script Date: 2017-04-04 11:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Soochang,Kim>
-- Create date: <03,22,2017>
-- Description:	<Create new user record>
-- =============================================

CREATE PROCEDURE [CPK].[uspRegister]
	-- Add the parameters for the stored procedure here
	@UserId varchar(30),
	@Password varchar(200),
	@FullName nvarchar(50),
	@Phone varchar(20),
	@Email varchar(50),
	@UserRole varchar(20),
	@UserType varchar(20),
	@Account int,
	@Status varchar(10)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [CPK].[Users](UserId, Password, FullName, Phone, Email, UserRole, UserType, Account, Status, ModifyDate)
	VALUES(@UserId, @Password, @FullName, @Phone, @Email, @UserRole, @UserType, @Account, @Status, GETDATE());
END
GO
/****** Object:  StoredProcedure [CPK].[uspUpdateUser]    Script Date: 2017-04-04 11:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery9.sql|7|0|C:\Users\Soo\AppData\Local\Temp\~vs892B.sql

CREATE PROCEDURE [CPK].[uspUpdateUser] 
	@UserID varchar(30),
	@Password varchar(200),
	@FullName nvarchar(50),
	@Phone varchar(20),
	@Email varchar(50),
	@UserRole varchar(20),
	@UserType varchar(20),
	@Account int,
	@Status varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE [CPK].[Users] 
	SET Password = @Password, FullName = @FullName, Phone = @Phone, 
		Email = @Email, UserRole = @UserRole, UserType = @UserType,
		Account = @Account, Status = @Status, ModifyDate = GETDATE()
	WHERE UserID = @UserID;
END

GO
/****** Object:  StoredProcedure [CPK].[uspUserList]    Script Date: 2017-04-04 11:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Soochang Kim>
-- Create date: <March 25, 2017>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [CPK].[uspUserList] 
	@PageNo INT = 1,
	@PageSize INT = 10,
	@FullName NVARCHAR(50) = NULL,
	@UserID VARCHAR(30) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    SELECT COUNT(*) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM [CPK].[Users]
	WHERE (FullName LIKE '%'+@FullName+'%' OR @FullName IS NULL OR LEN(@FullName) = 0)
		AND (UserID = @UserID OR @UserID IS NULL OR LEN(@UserID) = 0);

	SELECT UserID, UserType, FullName, Account, Status, FORMAT(ModifyDate, 'MMM dd yyyy') AS ModifyDate
	FROM [CPK].[Users]
	WHERE (FullName LIKE '%'+@FullName+'%' OR @FullName IS NULL OR LEN(@FullName) = 0)
			AND (UserID = @UserID OR @UserID IS NULL OR LEN(@UserID) = 0)
	ORDER BY UserID DESC
		OFFSET(@PageNo - 1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION (OPTIMIZE FOR(@PageNo = 1, @PageSize = 10));
END

GO
/****** Object:  StoredProcedure [CPK].[uspUserListSort]    Script Date: 2017-04-04 11:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Soochang Kim>
-- Create date: <March 28, 2017>
-- Description:	<Sort user list>
-- =============================================
CREATE PROCEDURE [CPK].[uspUserListSort] 
	@PageNo INT = 1,
	@PageSize INT = 10,
	@FullName VARCHAR(50) = NULL,
	@Sort VARCHAR(50) = 'UserTypeDESC'
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(*) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM [CPK].[Users]
	WHERE (FullName LIKE '%'+@FullName+'%' OR @FullName IS NULL OR LEN(@FullName) = 0);

	SELECT UserType, FullName, Account, Status, FORMAT(ModifyDate, 'MMM dd yyyy') AS ModifyDate
	FROM [CPK].[Users]
	WHERE (FullName LIKE '%'+@FullName+'%' OR @FullName IS NULL OR LEN(@FullName) = 0)
	ORDER BY
		CASE WHEN @Sort = 'UserTypeDESC' THEN UserType END DESC,
		CASE WHEN @Sort = 'FullNameDESC' THEN FullName END DESC,
		CASE WHEN @Sort = 'AccountDESC' THEN Account END DESC,
		CASE WHEN @Sort = 'StatusDESC' THEN Status END DESC,
		CASE WHEN @Sort = 'ModifyDateDESC' THEN ModifyDate END DESC,
		CASE WHEN @Sort = 'UserTypeASC' THEN UserType END ASC,
		CASE WHEN @Sort = 'FullNameASC' THEN FullName END ASC,
		CASE WHEN @Sort = 'AccountASC' THEN Account END ASC,
		CASE WHEN @Sort = 'StatusASC' THEN Status END ASC,
		CASE WHEN @Sort = 'ModifyDateASC' THEN ModifyDate END ASC,
		UserID DESC
			OFFSET(@PageNo - 1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION (OPTIMIZE FOR(@PageNo = 1, @PageSize = 10));
END

GO
