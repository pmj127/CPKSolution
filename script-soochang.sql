USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspUserList]    Script Date: 2017-03-28 11:00:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Soochang Kim>
-- Create date: <March 25, 2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [CPK].[uspUserList] 
	@PageNo INT = 1,
	@PageSize INT = 10,
	@FullName NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT COUNT(*) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM [CPK].[Users]
	WHERE (FullName LIKE '%'+@FullName+'%' OR @FullName IS NULL OR LEN(@FullName) = 0);

	SELECT UserID, FullName, Status, FORMAT(ModifyDate, 'MMM dd yyyy') AS ModifyDate
	FROM [CPK].[Users]
	WHERE (FullName LIKE '%'+@FullName+'%' OR @FullName IS NULL OR LEN(@FullName) = 0)
	ORDER BY UserID DESC
		OFFSET(@PageNo - 1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION (OPTIMIZE FOR(@PageNo = 1, @PageSize = 10));
END


GO
/****** Object:  StoredProcedure [CPK].[uspRegister]    Script Date: 2017-03-25 5:01:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Soochang,Kim>
-- Create date: <03,22,2017>
-- Description:	<Create new user record>
-- =============================================

ALTER PROCEDURE [CPK].[uspRegister]
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