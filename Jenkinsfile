def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
]
def loadValuesYaml(x){
  def valuesYaml = readYaml (file: './pipeline.yml')
  return valuesYaml[x];
}

pipeline {
  environment {
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
	    //stores token to use terraform cloud
	    TF_CLI_CONFIG_FILE='/var/jenkins_home/.terraformrc' 
   }
    agent any
    stages {
  //      stage('Build Node App') {
  //          steps {
  //              echo 'Building Node app...'
  //		    sh 'npm install-test --prefer-offline &> /dev/null'
  //          }
  //      }
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
                    sh "docker rmi $imageName:latest"                 }
                }
            }
       }
    post { 
        success {
      hangoutsNotify message: "Chris Gallivan:::SUCCESS - node:12-alpine",token: "8TAhr5dP97wKtVlaaWya6Hn5l", threadByJob: true    
		
        }
    
        failure {
	  	hangoutsNotify message: "Chris Gallivan:::FAILURE - node:12-alpine",token: "8TAhr5dP97wKtVlaaWya6Hn5l", threadByJob: true
        }
   }
}

