EXEC Zz_DropTable 'AAA_Users_Roles';
EXEC Zz_DropTable 'AAA_Roles';
EXEC Zz_DropTable 'AAA_Roles_Attributes';
EXEC Zz_DropTable 'AAA_Users';
EXEC Zz_DropTable 'AAA_Users_Attributes';
EXEC Zz_DropTable 'Common_ActivityLog';
EXEC Zz_DropTable 'Common_BaseInfo';

EXEC Zzz_Deploy 'AppEnd/Common_ActivityLog.sql';
EXEC Zzz_Deploy 'AppEnd/Common_BaseInfo.sql';
EXEC Zzz_Deploy 'AppEnd/AAA_Roles.sql';
EXEC Zzz_Deploy 'AppEnd/AAA_Users.sql';
EXEC Zzz_Deploy 'AppEnd/AAA_Users_Roles.sql';

