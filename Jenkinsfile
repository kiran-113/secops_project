pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://localhost:9090'
        SONAR_PROJECT_KEY = 'secops_project'
        SCANNER_HOME=tool 'sonar-scanner'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {  // Match Jenkins config name
                    sh '''
                    $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectKey=secops-project \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://localhost:9090 \
                        -Dsonar.login=sqp_d88ed0ea48b13814ab08be8c1dc55d73bc326602
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}



// pipeline {
//     agent any

//     environment {
//         SONAR_HOST_URL = 'http://localhost:9090'  // Update if running on a different server
//         SONAR_PROJECT_KEY = 'secops_project'
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 checkout scm
//             }
//         }

//         stage('SonarQube Analysis') {
//             steps {
//                 withSonarQubeEnv('sonar-server') { // Ensure 'sonar-server' matches your Jenkins SonarQube configuration
//                     sh '''
//                     $SCANNER_HOME/bin/sonar-scanner \
//                       -Dsonar.projectName=SecOpsProject \
//                       -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
//                       -Dsonar.sources=. \
//                       -Dsonar.language=js \
//                       -Dsonar.exclusions="node_modules/**, client/**, **/*.test.js"
//                     '''
//                 }
//             }
//         }

//         stage('Quality Gate') {
//             steps {
//                 timeout(time: 5, unit: 'MINUTES') {
//                     waitForQualityGate abortPipeline: true
//                 }
//             }
//         }
//     }
// }
