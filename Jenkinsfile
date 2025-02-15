pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://localhost:9090'
        SONAR_PROJECT_KEY = 'secops_project'
        SCANNER_HOME = tool 'SonarQubeScanner'  // Ensure this matches the tool name in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {  // Ensure this matches your SonarQube server name in Jenkins
                    sh '''
                    ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONAR_HOST_URL} \
                        -Dsonar.login=sqa_6f6aa9f9ec9d89702ef40ae029e297baa8a1bbdc
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
