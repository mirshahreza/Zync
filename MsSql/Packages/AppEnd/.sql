EXEC ZzDropTable 'AAA_Users_Roles';
EXEC ZzDropTable 'AAA_Roles';
EXEC ZzDropTable 'AAA_Roles_Attributes';
EXEC ZzDropTable 'AAA_Users';
EXEC ZzDropTable 'AAA_Users_Attributes';
EXEC ZzDropTable 'Common_ActivityLog';
EXEC ZzDropTable 'Common_BaseInfo';

EXEC DBO.Zync 'AppEnd/Common_ActivityLog.sql';
EXEC DBO.Zync 'AppEnd/Common_BaseInfo.sql';
EXEC DBO.Zync 'AppEnd/AAA_Roles.sql';
EXEC DBO.Zync 'AppEnd/AAA_Users.sql';
EXEC DBO.Zync 'AppEnd/AAA_Users_Roles.sql';

