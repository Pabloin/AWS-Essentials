#!/bin/bash

export ENV_ALIAS_CUENTA_AWS=
export ENV_CHANGE_PASSWD=


aws iam remove-user-from-group --group-name Administrador --user-name NinjaAdmin
aws iam remove-user-from-group --group-name PowerUser     --user-name NinjaPower
aws iam remove-user-from-group --group-name Devs          --user-name Ninja1
aws iam remove-user-from-group --group-name Devs          --user-name Ninja2
aws iam remove-user-from-group --group-name Devs          --user-name Ninja3
aws iam remove-user-from-group --group-name Devs          --user-name Ninja4


aws iam detach-group-policy \
             --group-name Administrador \
             --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

aws iam detach-group-policy \
             --group-name PowerUser \
             --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

aws iam detach-group-policy \
             --group-name Devs \
             --policy-arn arn:aws:iam::${ENV_ALIAS_CUENTA_AWS}:policy/FullAccessToSomeServices


aws iam delete-policy --policy-name     FullAccessToSomeServices 
             
#---[Grupos]----------
# aws iam delete-group --group-name Administrador
# aws iam delete-group --group-name PowerUser
# aws iam delete-group --group-name Devs


# #---[Grupos Policies]----------
# aws iam delete-policy \
#              --policy-name     FullAccessToSomeServices



aws iam delete-login-profile --user-name NinjaAdmin
aws iam delete-login-profile --user-name NinjaPower
aws iam delete-login-profile --user-name Ninja1
aws iam delete-login-profile --user-name Ninja2
aws iam delete-login-profile --user-name Ninja3
aws iam delete-login-profile --user-name Ninja4

aws iam delete-access-key --user-name Ninja3 --access-key-id AKIA6CAPKJYA7EFAHNWA
aws iam delete-access-key  --access-key-id AKIA6CAPKJYA7EFAHNWA

# #---[Creo los Usuarios y Los Agrego a los Grupos]----------
aws iam delete-user --user-name NinjaAdmin
aws iam delete-user --user-name NinjaPower
aws iam delete-user --user-name Ninja1
aws iam delete-user --user-name Ninja2
aws iam delete-user --user-name Ninja3
aws iam delete-user --user-name Ninja4


aws iam
# Referencias:

https://docs.aws.amazon.com/cli/latest/userguide/cli-services-iam.html

