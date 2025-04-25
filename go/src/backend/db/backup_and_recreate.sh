
echo "==================== Copy DB to Backup ===================="


echo "==================== Granting drop privileges for drop and recreate process... ===================="




echo "==================== Drop DB ===================="

echo "==================== Recreate DB ===================="
#Notes: trones is the superuser, all bojects should be created as trones 



echo "==================== Harden against accidental drops ===================="
echo "Revoking drop privileges..."
#Notes: trones is the superuser, ensure that app_user can't do any object alterations (outside of CRUD)
