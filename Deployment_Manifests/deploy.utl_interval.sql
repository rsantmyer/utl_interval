SET DEFINE ON
DEFINE APPLICATION_NAME = 'UTL_INTERVAL'
DEFINE DEPLOY_VERSION = '1'

COLUMN CURRENT_SCHEMA       new_value CURRENT_SCHEMA      
SELECT sys_context('USERENV','CURRENT_SCHEMA') AS CURRENT_SCHEMA FROM DUAL;

SPOOL deploy.&&APPLICATION_NAME..&&CURRENT_SCHEMA..log

--PRINT BIND VARIABLE VALUES
SET AUTOPRINT ON                    

--THE START COMMAND WILL LIST EACH COMMAND IN A SCRIPT
REM SET ECHO ON                         

--DISPLAY DBMS_OUTPUT.PUT_LINE OUTPUT
SET SERVEROUTPUT ON                 

--SHOW THE OLD AND NEW SETTINGS OF A SQLPLUS SYSTEM VARIABLE
REM SET SHOWMODE ON                     

--ALLOW BLANK LINES WITHIN A SQL COMMAND OR SCRIPT
--SET SQLBLANKLINES ON                

WHENEVER SQLERROR EXIT FAILURE
WHENEVER OSERROR EXIT FAILURE

EXEC PKG_APPLICATION.delete_application_p(ip_application_name => '&&APPLICATION_NAME', ip_fail_on_not_found => 'N' );
EXEC pkg_application.begin_deployment_p(ip_application_name => '&&APPLICATION_NAME', ip_version => &&DEPLOY_VERSION, ip_deployment_type => pkg_application.c_deploy_type_initial);
--
EXEC pkg_application.add_dependency_p  (ip_application_name => '&&APPLICATION_NAME', ip_depends_on => 'CORE');
--
--EXEC pkg_application.add_sys_priv_p    (ip_application_name => '&&APPLICATION_NAME', ip_privilege => 'CREATE TYPE');
--EXEC pkg_application.add_sys_priv_p    (ip_application_name => '&&APPLICATION_NAME', ip_privilege => 'CREATE PROCEDURE');
--
--EXEC pkg_application.add_obj_priv_p    (ip_application_name => '&&APPLICATION_NAME', ip_owner => ':OBJECT_OWNER:', ip_type => ':OBJECT_TYPE:', ip_name => ':OBJECT_NAME:', ip_privilege => ':OBJECT_PRIV:');
--
--EXEC pkg_application.add_object_p(ip_application_name => '&&APPLICATION_NAME', ip_object_name => ':OBJECT_NAME:'   , ip_object_type => pkg_application.c_object_type_table);
--
--TYPE SPECS / TYPE BODIES
EXEC pkg_application.add_object_p(ip_application_name => '&&APPLICATION_NAME', ip_object_name => 'TYP_INTERVAL'        , ip_object_type => pkg_application.c_object_type_type);
EXEC pkg_application.add_object_p(ip_application_name => '&&APPLICATION_NAME', ip_object_name => 'TYP_INTERVAL'        , ip_object_type => pkg_application.c_object_type_type_body);
--FUNCTIONS
EXEC pkg_application.add_object_p(ip_application_name => '&&APPLICATION_NAME', ip_object_name => 'SUM_INTERVAL'        , ip_object_type => pkg_application.c_object_type_function);
--PACKAGE SPECS / PACKAGE BODIES
EXEC pkg_application.add_object_p(ip_application_name => '&&APPLICATION_NAME', ip_object_name => 'PKG_INTERVAL'        , ip_object_type => pkg_application.c_object_type_package);
EXEC pkg_application.add_object_p(ip_application_name => '&&APPLICATION_NAME', ip_object_name => 'PKG_INTERVAL'        , ip_object_type => pkg_application.c_object_type_package_body);
--VALIDATIONS
EXEC pkg_application.validate_dependencies_p(ip_application_name => '&&APPLICATION_NAME');
--EXEC pkg_application.validate_obj_privs_p   (ip_application_name => '&&APPLICATION_NAME');
--EXEC pkg_application.validate_sys_privs_p   (ip_application_name => '&&APPLICATION_NAME');

--Package Specifications
Prompt Creating Package Specifications
@@../Packages/pkg_interval.pks

--Package Bodies
Prompt Creating Package Bodies
@@../Packages/pkg_interval.pkb

--Types
Prompt Creating Type Specifications
@@../Types/typ_interval.tps

Prompt Creating Type Bodies
@@../Types/typ_interval.tpb                              --Depends on PACKAGE pkg_interval


--Functions
Prompt Creating Functions
@@../Functions/sum_interval.sql                          --Depends on TYPE typ_interval

SET DEFINE ON
EXEC pkg_application.validate_objects_p(ip_application_name => '&&APPLICATION_NAME');
EXEC pkg_application.set_deployment_complete_p(ip_application_name => '&&APPLICATION_NAME');

SPOOL OFF
