pipeline { 
    environment { 
        DOCKERHUB_CREDENTIALS = credentials('aydemirkala')
    }
    agent any 
    stages{
        stage('Building our image') { 
            steps { 
                script { 
                    sh "docker build -t aydemirkala/dotnet-test:v1 . "
                }
            } 
        }
        stage('Login') { 
            steps { 
                script { 
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                } 
            }
        } 
         stage('Push') { 
            steps { 
                script { 
                    sh "docker push aydemirkala/dotnet-test:v1"
                } 
            }
        } 
    }
}
