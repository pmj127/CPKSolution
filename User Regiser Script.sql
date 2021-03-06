USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspRegister]    Script Date: 2017-03-28 11:10:41 AM ******/
DROP PROCEDURE [CPK].[uspRegister]
GO
/****** Object:  StoredProcedure [CPK].[uspRegister]    Script Date: 2017-03-28 11:10:41 AM ******/
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
