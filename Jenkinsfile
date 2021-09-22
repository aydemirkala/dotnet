pipeline { 
    environment { 
        DOCKERHUB_CREDENTIALS = credentials('aydemirkala')
    }
    agent any 
    stages{
        stage('Docker Build') { 
            steps { 
                script { 
                    sh "docker build -t aydemirkala/dotnet-test:v1 . "
                }
            } 
        }
        stage('Docker Login') { 
            steps { 
                script { 
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                } 
            }
        } 
         stage('Docker Push') { 
            steps { 
                script { 
                    sh "docker push aydemirkala/dotnet-test:v1"
                } 
            }
        } 
        stage('Docker Logout') { 
            steps { 
                script { 
                    sh "docker logout"
                } 
            }
        } 
    }
}
