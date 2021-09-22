pipeline {
    agent {label "linux"}
    stages {
        stage('Dockerbuild') {
            steps {
                sh '/tmp/build.sh'
            }
        }
    }
}
