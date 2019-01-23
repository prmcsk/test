node {
    def app

        stage('Downloading MVN cache') {
            steps {
                sh 'wget https://storage.googleapis.com/aliz/repository.tar'
            }
        }
    
    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("nexus")
    }
}
