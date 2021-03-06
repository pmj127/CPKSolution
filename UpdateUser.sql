USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspUpdateUser]    Script Date: 2017-04-02 1:21:07 PM ******/
DROP PROCEDURE [CPK].[uspUpdateUser]
GO
/****** Object:  StoredProcedure [CPK].[uspUpdateUser]    Script Date: 2017-04-02 1:21:07 PM ******/
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
