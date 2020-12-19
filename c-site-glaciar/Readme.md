# Site Glaciar

Es un sitio con HTML/css

## Lab 01: Se sube en S3 + Policies

   - Se sube en S3 manualmente, 
   - Se configura una Policy para excluir publicamente el dir de config

## Lab 01: Se sube con CodeDeploy

   - Pudo Funcionar la Demo, son muchos pasos por la consola.
     La base es:

      # CodeDeploy Agent

      sudo yum update -y 
      sudo yum install -y wget ruby 

      cd /home/ec2-user
      wget https://aws-codedeploy-eu-central-1.s3.amazonaws.com/latest/install
      chmod +x ./install

      sudo service codedeploy-agent status

      # My App Zip

      aws deploy create-application --application-name d-site-glaciar
      aws deploy push               --application-name d-site-glaciar \
               s3://<glaciar-bucket>/c-site-glaciar-lab-02.zip \
            --ignore-hidden-files



      aws deploy push --application-name glaciar-app \
               --s3-location s3://glaciar2/site-glaciar-lab-02.zip \
               --ignore-hidden-files