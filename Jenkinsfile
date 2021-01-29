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
                    sh "docker rmi $imageName:latest"                 }
                }
            }
	    
       }
    post { 
            success {
               hangoutsNotify message: "Chris Gallivan:::SUCCESS -Kata India",token: "8TAhr5dP97wKtVlaaWya6Hn5l", threadByJob: true    
		
            }
    
            failure {
	  	hangoutsNotify message: "Chris Gallivan:::FAILURE -Kata India",token: "8TAhr5dP97wKtVlaaWya6Hn5l", threadByJob: true
            }
    }
}
