USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspLogin]    Script Date: 4/10/2017 4:22:16 PM ******/
DROP PROCEDURE [CPK].[uspLogin]
GO
/****** Object:  StoredProcedure [CPK].[uspLogin]    Script Date: 4/10/2017 4:22:16 PM ******/
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
	SELECT UserID,  FullName, Phone, Email, UserRole, UserType, Account, [Status]
	FROM [CPK].[Users]
	WHERE UserID = @UserID AND Password = @Password;
END

GO
