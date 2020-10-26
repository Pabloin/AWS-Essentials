#!/bin/bash

echo -n "AWS Account Number / Alias? "
read AWS_Account


echo -n "A Random and OTP Passord that users should change? "
read AWS_Users_OTP_Passwd

export ENV_ALIAS_CUENTA_AWS=${AWS_Account}
export ENV_CHANGE_THIS_PASSWD=${AWS_Users_OTP_Passwd}



#---[Grupos]----------
aws iam create-group --group-name Administrador
aws iam create-group --group-name PowerUser
aws iam create-group --group-name Devs
aws iam create-group --group-name Auditores


#---[Grupos Policies]----------
aws iam attach-group-policy \
             --group-name Administrador \
             --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

aws iam attach-group-policy \
             --group-name PowerUser \
             --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

aws iam create-policy \
             --policy-name     FullAccessToSomeServices \
             --policy-document file://Policy_FullAccessToSomeServices.json

aws iam attach-group-policy \
             --group-name Devs \
             --policy-arn arn:aws:iam::${ENV_ALIAS_CUENTA_AWS}:policy/FullAccessToSomeServices

aws iam attach-group-policy \
             --group-name Auditores \
             --policy-arn arn:aws:iam::${ENV_ALIAS_CUENTA_AWS}:policy/AWSCloudTrailReadOnlyAccess

#---[Creo los Usuarios y Los Agrego a los Grupos]----------
aws iam create-user --user-name NinjaAdmin
aws iam create-user --user-name NinjaPower
aws iam create-user --user-name Ninja1
aws iam create-user --user-name Ninja2
aws iam create-user --user-name Ninja3
aws iam create-user --user-name Ninja4
aws iam create-user --user-name Sensei


aws iam add-user-to-group --group-name Administrador --user-name NinjaAdmin
aws iam add-user-to-group --group-name PowerUser     --user-name NinjaPower
aws iam add-user-to-group --group-name Devs          --user-name Ninja1
aws iam add-user-to-group --group-name Devs          --user-name Ninja2
aws iam add-user-to-group --group-name Devs          --user-name Ninja3
aws iam add-user-to-group --group-name Devs          --user-name Ninja4
aws iam add-user-to-group --group-name Auditores     --user-name Sensei

#---[Creo los Usuarios y Los Agrego a los Grupos]----------
aws iam create-login-profile --user-name NinjaAdmin --password ${ENV_CHANGE_THIS_PASSWD} --password-reset-required
aws iam create-login-profile --user-name NinjaPower --password ${ENV_CHANGE_THIS_PASSWD} --password-reset-required
aws iam create-login-profile --user-name Ninja1     --password ${ENV_CHANGE_THIS_PASSWD} --password-reset-required
aws iam create-login-profile --user-name Ninja2     --password ${ENV_CHANGE_THIS_PASSWD} --password-reset-required
aws iam create-login-profile --user-name Ninja3     --password ${ENV_CHANGE_THIS_PASSWD} --password-reset-required
aws iam create-login-profile --user-name Ninja4     --password ${ENV_CHANGE_THIS_PASSWD} --password-reset-required

aws iam create-login-profile --user-name NinjaAdmin
aws iam create-login-profile --user-name NinjaPower
aws iam create-access-key    --user-name Ninja1
aws iam create-access-key    --user-name Ninja2
aws iam create-access-key    --user-name Ninja3
aws iam create-access-key    --user-name Ninja4
aws iam create-access-key    --user-name Sensei


## Referencias:

# [LINKS]
# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-iam.html

# [UTILES]
#  aws sts get-caller-identity

# TODO:

# O el usuario no está autorizado a realizar iam:ChangePassword 