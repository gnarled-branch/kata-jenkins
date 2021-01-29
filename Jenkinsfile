//vault setup
def aws_secrets = [
  [path: 'secret/jenkins/aws', engineVersion: 2, secretValues: [
     [envVar: 'DEPLOYMENT_USERNAME', vaultKey: 'aws_access_id'],
     [envVar: 'DEPLOYMENT_PASSWORD', vaultKey: 'aws_secret_key']
    ]],
]
def azure_secrets = [
  [path: 'secret/jenkins/azure/angular', engineVersion: 2, secretValues: [
     [envVar: 'CLIENT_ID', vaultKey: 'client_id'],
     [envVar: 'CLIENT_SECRET', vaultKey: 'client_secret'],
     [envVar: 'SUBSCRIPTION_ID', vaultKey: 'subscription_id'],
     [envVar: 'TENANT_ID', vaultKey: 'tenant_id']
		  
    ]],
]

def configuration = [vaultUrl: 'http://host.docker.internal:8200',  vaultCredentialId: 'vault_app_role', engineVersion: 2]

def loadValuesYaml(x){
  def valuesYaml = readYaml (file: './pipeline.yml')
  return valuesYaml[x];
}

pipeline {
  environment {
  	    cloudProvider = loadValuesYaml('cloudProvider')
	  //credentials
	    dockerHubCredential = loadValuesYaml('dockerHubCredential')
            awsCredential = loadValuesYaml('awsCredential')
	    
	    //docker config
	    imageName = loadValuesYaml('imageName')
	    slackChannel = loadValuesYaml('slackChannel')
	    dockerImage = ''
	    
	    //s3 config
            backendFile = loadValuesYaml('backendFile')
            backendPath = loadValuesYaml('backendPath')
	    
	    //additional external feedback
	    successAction = loadValuesYaml('successAction')
	    failureAction = loadValuesYaml('failureAction')  
	    app_url = ''      
	  
	    
   }
    agent any
    stages {
        stage('Build Docker Image') {
             steps {
                script{
                    echo 'Building Docker image...'
                    docker.withRegistry( '', dockerHubCredential ) {
          		          dockerImage = docker.build imageName
		                }
                }
             }
        }
        stage('Deploy to Docker Hub') {
            steps {
               script {
                    echo 'Publishing Image to Docker Hub...'
                    docker.withRegistry( '', dockerHubCredential ) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')   
                    }
                    echo 'Removing Image...'
                    sh "docker rmi $imageName:$BUILD_NUMBER"
                    sh "docker rmi $imageName:latest"                 
	        }
            }
         }
         stage('Deploy Image to Target') {
                steps {
                    script {

			    if (cloudProvider == "AWS") {
	    		         secrets = aws_secrets
	    		         withVault([configuration: configuration, vaultSecrets: secrets]) {
			  
	                         echo 'Provisioning to AWS...'
          				sh 'terraform init'    
                                        sh 'terraform plan -out=plan.tfplan -var deployment_username=$DEPLOYMENT_USERNAME -var deployment_password=$DEPLOYMENT_PASSWORD'
		                        sh 'terraform apply -auto-approve plan.tfplan'
	                                app_url = sh (
			                   script: "terraform output app_url",
                                           returnStdout: true
                                         ).trim()   
		
                                 }
		             }
			     else if (cloudProvider == "AZURE"){
				 secrets = azure_secrets
	    		         withVault([configuration: configuration, vaultSecrets: secrets]) {
				     echo 'Provisioning to Azure...'
                                     sh 'terraform init'    
                                     sh 'terraform plan -out=plan.tfplan -var deployment_subscription_id=$SUBSCRIPTION_ID -var deployment_tenant_id=$TENANT_ID -var deployment_client_id=$CLIENT_ID -var deployment_client_secret=$CLIENT_SECRET'
		                     sh 'terraform apply -auto-approve plan.tfplan'
	                             app_url = sh (
			                script: "terraform output app_url",
                                        returnStdout: true
                                     ).trim()   
		
                                  }
			     } // end if else
                         }//end script
                     }//end steps
                 }//end stage
    }//end stages
     post { 
        success {
      hangoutsNotify message: "Chris Gallivan:::SUCCESS - node:12-alpine",token: "8TAhr5dP97wKtVlaaWya6Hn5l", threadByJob: true    
		
        }
    
        failure {
	  	hangoutsNotify message: "Chris Gallivan:::FAILURE - node:12-alpine",token: "8TAhr5dP97wKtVlaaWya6Hn5l", threadByJob: true
        }
   }
}
